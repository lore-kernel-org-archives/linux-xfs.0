Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E7A17CA0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 15:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE0B3AC003
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 13:13:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id n37b4ocevn7Gpemd for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2016 13:13:27 -0700 (PDT)
Received: from Liberator.local (unknown [74.203.127.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BB11B9E
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 15:13:26 -0500 (CDT)
Subject: Re: [PATCH 1/4] xfs: Don't wrap growfs AGFL indexes
References: <1459836310-12619-1-git-send-email-david@fromorbit.com>
	<1459836310-12619-2-git-send-email-david@fromorbit.com>
	<20160407235043.GB1439@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57169165.8020005@sandeen.net>
Date: Tue, 19 Apr 2016 16:13:25 -0400
MIME-Version: 1.0
In-Reply-To: <20160407235043.GB1439@infradead.org>
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
To: xfs@oss.sgi.com



On 4/7/16 7:50 PM, Christoph Hellwig wrote:
> On Tue, Apr 05, 2016 at 04:05:07PM +1000, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Commit 96f859d ("libxfs: pack the agfl header structure so
>> XFS_AGFL_SIZE is correct") allowed the freelist to use the empty
>> slot at the end of the freelist on 64 bit systems that was not
>> being used due to sizeof() rounding up the structure size.
>>
>> This has caused versions of xfs_repair prior to 4.5.0 (which also
>> has the fix) to report this as a corruption once the filesystem has
>> been grown. Older kernels can also have problems (seen from a whacky
>> container/vm management environment) mounting filesystems grown on a
>> system with a newer kernel than the vm/container it is deployed on.
>>
>> To avoid this problem, change the initial free list indexes not to
>> wrap across the end of the AGFL, hence avoiding the initialisation
>> of agf_fllast to the last index in the AGFL.
> 
> I have to admit that it's been a while that I looked at the AGFL
> code, but I simply don't understand what's happening in this patch.
> Diff slightly reorder:
> 
>> -		agf->agf_flfirst = 0;
>> +		agf->agf_flfirst = cpu_to_be32(1);
> 
> So flfirst moves from 0 to 1.
> 
>> -		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
>> +		agf->agf_fllast = 0;
> 
> And last from size - 1 to 0.  In my naive reading this introduces
> wrapping and doesn't remove it.  What do I miss?

I'm confused by this too.  I think this fixes it because regardless
of XFS_AGFL_SIZE under any kernel, when we follow the circular list
we'll wrap around at the "right" limit, if we start out wrapped
as above, rather than potentially filling in a number for last which
doesn't match the running code?

Anyway, it does fix the testcase of "mkfs with
old xfsprogs; grow under new kernel; repair with old progs" which
used to complain about i.e. "fllast 118 in agf 94 too large (max = 118)"
A growfs under a new kernel, and a mount under an old kernel
showed the same problems; this should fix that as well.

We seem to have a few problems introduced
by the AGFL header packing; we have checks (in xfs_agf_verify(), for example,
and xfs_repair's verify_set_agf()) which depend on the size of this structure.
If the size moves in the "wrong" way the checks fire off as corruption.

It seems to me that now, mismatches between userspace/kernelspace versions
will cause these size checks to fail; that seems much more common (and worse)
than the original problem of migrating a filesystem between 32 and 64 bit
machines.

I'm trying to convince myself that we don't have a lot more of these lurking
with all the combinations of old/new kernels & old/new userspace, or filesystems
migrated between old/new kernels, etc.  This patch is ok for initialization but
isn't it still quite possible to end up with an fllast set at runtime
which is outside the valid range for older userspace or kernel code?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
