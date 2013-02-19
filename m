Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48E627F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 16:31:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF7058F8033
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 14:31:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5zEBXIEP29vX3eOI for
	<xfs@oss.sgi.com>; Tue, 19 Feb 2013 14:31:35 -0800 (PST)
Message-ID: <5123FCB7.9050309@redhat.com>
Date: Tue, 19 Feb 2013 17:29:11 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/7] xfs: cap prealloc size to free space before shift
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
	<1361291851-24714-4-git-send-email-bfoster@redhat.com>
	<20130219214842.GG10731@dastard>
In-Reply-To: <20130219214842.GG10731@dastard>
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

On 02/19/2013 04:48 PM, Dave Chinner wrote:
> On Tue, Feb 19, 2013 at 11:37:27AM -0500, Brian Foster wrote:
>> With the addition of quota preallocation throttling, we want to
>> support a general algorithm that considers the maximum allowable
>> prealloc size and recommended shift modifier from various sources
>> (i.e., global fs state and all applicable quotas for an inode).
>>
>> Update the current global free space throttle algorithm to cap the
>> preallocation size to the free space available in the filesystem.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_iomap.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>> index daa08f6..3b41c18 100644
>> --- a/fs/xfs/xfs_iomap.c
>> +++ b/fs/xfs/xfs_iomap.c
>> @@ -412,6 +412,9 @@ xfs_iomap_prealloc_size(
>>  		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
>>  			shift++;
>>  	}
>> +	if (alloc_blocks > freesp)
>> +		alloc_blocks = freesp;
>> +
>>  	if (shift)
>>  		alloc_blocks >>= shift;
> 
> This is redundant with the previous additions of the trailing
> 
> 	while (alloc_blocks >= freesp)
> 		alloc_blocks >>= 4;
> 
> code. Effectively adding the check will result in preventing the
> existing loop from working as alloc_blocks will be brought down to
> just under freespc by things like power of 2 rounding, rather than
> being thottled to a small fraction of the remaining free space...
> 

Ah, yes. For starters, this set was more of a logical add-on to make the
throttling consistent between global free space and quota limits (e.g.,
start with free space available and throttle down) as opposed to a
functional dependency, so it should be safe to just drop this patch from
the set.

Tracking back to that discussion...

http://oss.sgi.com/archives/xfs/2013-01/msg00392.html

... my understanding is that at the moment, the condition addressed by
the previous change is not relevant to quota since we have no
flush/retry cycle (e.g., we just fail early). The intended follow up set
to this (eofblocks scan, retry) would introduce such a cycle. What I'm
wondering is if we'll need something similar longer term within the
quota throttling code.

In particular, is the "metadata overhead" referred to in your original
explanation accounted against an associated quota, such that it still
isn't enough to simply start the prealloc capped at the quota free space
limit? If so, perhaps as part of that set I'll need to modify this code
to carry a minimum 'qfreesp' through each of the quotas and add that to
the squashing loop...

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
