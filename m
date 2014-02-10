Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 006DA7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 16:39:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DBBDE8F804B
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:39:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e2GGRFNJhVq11f6Y for
	<xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:39:44 -0800 (PST)
Message-ID: <52F9552C.7020001@redhat.com>
Date: Mon, 10 Feb 2014 17:39:40 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: avoid AGI/AGF deadlock scenario for inode chunk
	allocation
References: <1392042807-41697-1-git-send-email-bfoster@redhat.com>
	<20140210220134.GU13647@dastard>
In-Reply-To: <20140210220134.GU13647@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/10/2014 05:01 PM, Dave Chinner wrote:
> On Mon, Feb 10, 2014 at 09:33:27AM -0500, Brian Foster wrote:
>> The inode chunk allocation path can lead to deadlock conditions if
>> a transaction is dirtied with an AGF (to fix up the freelist) for
>> an AG that cannot satisfy the actual allocation request. This code
>> path is written to try and avoid this scenario, but it can be
>> reproduced by running xfstests generic/270 in a loop on a 512b fs.
> 
> Yup, I've been seeing this problem for a few months now. Frequently
> enough that I expunged 269 and 270 from my 1k block size test
> machines. I simply hadn't found the time to debug it...
> 

Yeah, I've been doing something similar here and had spent a few hours
here and there to try and narrow in on it.

>> An example situation is:
>> - process A attempts an inode allocation on AG 3, modifies
>>   the freelist, fails the allocation and ultimately moves on to
>>   AG 0 with the AG 3 AGF held
>> - process B is doing a free space operation (i.e., truncate) and
>>   acquires the AG 0 AGF, waits on the AG 3 AGF
>> - process A acquires the AG 0 AGI, waits on the AG 0 AGF (deadlock)
> 
> Yup, the "dirty an AGF then fail to allocate" is the typical cause
> of shutdowns due to cancelling a dirty create transaction because of
> ENOSPC. I'm not surprised that we can trigger deadlocks like this,
> either.
> 
>> The problem here is that process A acquired the AG 3 AGF while
>> moving on to AG 0 (and releasing the AG 3 AGI with the AG 3 AGF
>> held).
> 
> Right, AGF/AGI locking order is ascending AG order only.
> 
>> xfs_dialloc() makes one pass through each of the AGs when
>> attempting to allocate an inode chunk. The expectation is a clean
>> transaction if a particular AG cannot satisfy the allocation
>> request. xfs_ialloc_ag_alloc() is written to support this through
>> use of the minalignslop allocation args field.
> 
> *nod*
> 
>> When using the agi->agi_newino optimization, we attempt an exact
>> bno allocation request based on the location of the previously
>> allocated chunk. minalignslop is set to inform the allocator that
>> we will require alignment on this chunk, and thus to not allow the
>> request for this AG if the extra space is not available. Suppose
>> that the AG in question has just enough space for this request, but
>> not at the requested bno.
> 
> Ok, so an exact (XFS_ALLOCTYPE_THIS_BNO) allocation fails?
> 

I didn't dig all the way down to precisely characterize the state of
things at the point of allocation failure, but I observed a pattern of a
process attempting the THIS_BNO request, which passed through the
fix_freelist code but ultimately fails (in terms of returning a
NULLFSBLOCK). It then attempts the NEAR_BNO request which fails in the
fix_freelist code. Some instrumentation down in the fix_freelist code
confirmed that the latter failure occurred because the request sizes had
changed from the previous invocation (for which it apparently allowed
the agfl to be modified and thus agf locked).

>>
>> xfs_alloc_fix_freelist() will proceed as
>> normal as it determines the request should succeed, and thus it is
>> allowed to modify the agf. xfs_alloc_ag_vextent() ultimately fails
>> because the requested bno is not available.
> 
> *nod*
> 
>> In response, the caller
>> moves on to a NEAR_BNO allocation request for the same AG. The
>> alignment is set, but the minalignslop field is never reset. This
>> increases the overall requirement of the request from the first
>> attempt. If this delta is the difference between allocation success
>> and failure for the AG, xfs_alloc_fix_freelist() rejects this
>> request outright the second time around and causes the allocation
>> request to unnecessarily fail for this AG.
> 
> Yup, that looks like a bug.
> 
>> To address this situation, reset the minalignslop field when we
>> transition from a THIS_BNO to a NEAR_BNO allocation request in
>> xfs_ialloc_ag_alloc().
>>
>> [NOTE: It appears at first glance that the optimized agi_newino
>>  allocation case is problematic in that it doesn't consider use of
>>  mp->m_sinoalign, if enabled. If the m_sinoalign allocation fails,
>>  however, we revert back to normal cluster alignment, which I think
>>  makes the overall sequence safe.]
> 
> The agi_newino allocation case is not meant to stripe align the new
> inode chunk. What it is meant to do is cluster inode allocation
> within a stripe. i.e. the first allocation will be stripe aligned,
> which sets newino. then newino will move to the adjacent cluster,
> and we'll try to allocate that. i.e. we try to densely pack inodes
> within a stripe unit before we spread them out onto other stripe
> units. Hence when you are doing large file workloads, inodes get
> clustered into a single stripe unit rather than being distributed
> around between files....
> 

Ah, thanks. That turns on a light bulb. ;) I wasn't familiar with the
purpose of m_sinoalign to this point and was a little confused about
what (or why, more specifically) was going on there in the allocation
algorithm. It makes much more sense now. I'll probably remove the above
bit of confusion from the commit log (and replace it with a more
accurate comment called for below)...

>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_ialloc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index 5d7f105..584daf0 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -382,6 +382,8 @@ xfs_ialloc_ag_alloc(
>>  			isaligned = 1;
>>  		} else
>>  			args.alignment = xfs_ialloc_cluster_alignment(&args);
>> +		args.minalignslop = 0;
>> +
>>  		/*
>>  		 * Need to figure out where to allocate the inode blocks.
>>  		 * Ideally they should be spaced out through the a.g.
> 
> I think I'd prefer that this is cleared immediately after the
> allocation that required it, regardless of whether it succeeds or
> not. i.e. confine the minalignslop context to that specific
> allocation call, and hence if we modify this code in future we don't
> have a landmine to trip on. It also needs a comment to explain why
> it needs to be cleared....
> 

Yeah, that sounds a bit nicer. I'll send a new version. Thanks for the
review/insight. :)

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
