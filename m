Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q560w1at143361 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 19:58:01 -0500
Subject: Re: [PATCH] xfstest 285: userspace vs. fragmented multiblock dir2
References: <4FBABC41.5040001@redhat.com> <20120605224600.GN4721@sgi.com>
	<20120605234803.GE22848@dastard>
From: Eric Sandeen <esandeen@redhat.com>
In-Reply-To: <20120605234803.GE22848@dastard>
Message-Id: <B8030978-6C3F-4531-8002-651F05C5D600@redhat.com>
Date: Tue, 05 Jun 2012 20:57:58 -0400 (EDT)
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Jun 5, 2012, at 6:48 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jun 05, 2012 at 05:46:00PM -0500, Ben Myers wrote:
>> Hey Eric,
>> 
>> On Mon, May 21, 2012 at 05:05:53PM -0500, Eric Sandeen wrote:
>>> Current xfs_repair is unhappy with fragmented multiblock
>>> v2 directories.  This test shows it ... patches to fix
>>> it soon to follow.
>>> 
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> 
>> This failed on my system... looks like it's just PEBKAC.  My partitions
>> are too small?
>> 
>> # ./check 287
>> No patches applied
>> KERNEL_TOPDIR -- /root/xfs
>> BRANCH        -- refs/heads/master2
>> DESC          -- v3.4-10158-gf8f5701
>> PATCHES:
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/x86_64 nfs10 3.5.0-rc1-0.7-default+
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
>> MOUNT_OPTIONS -- /dev/sdb4 /mnt/scratch
>> 
>> 287      - no qualified output
> 
> It failed because there is not 287.out file in the patch. Every test
> has to have a golden image to compare the result against...
> 
Argh.....

Sorry.


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
