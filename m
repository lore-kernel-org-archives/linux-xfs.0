Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E3757CA0
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 19:43:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0ADA7AC003
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 17:43:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	USsJ7B9f9npdpkN7 for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2016 17:43:21 -0700 (PDT)
Date: Sat, 27 Aug 2016 10:43:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: new -FF option help to continue the command
	without verify
Message-ID: <20160827004318.GH19025@dastard>
References: <1472209496-2401-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472209496-2401-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 07:04:56PM +0800, Zorro Lang wrote:
> When I try to do below steps(a V5 xfs on $fsile):
> 
>   # xfs_db -x -c "sb 0" -c "write features_ro_compat 4096" $fsfile
>   # xfs_db -x -c "sb 0" -c "write features_ro_compat 0" $fsfile
>   # xfs_db -c "sb 0" -c p $fsfile
> 
> The step#2 and #3 all failed, as:
> 
>   Superblock has unknown read-only compatible features (0x1000) enable

As it should. xfs_db *in expert mode* allows you to shoot yourself
in the foot. However, it doesn't guarantee you'll have the expertise
to be able to fix the hole you just shot in your foot.

You have much to learn, grasshopper. :P

> If we break the superblock, at least xfs_db should help to print the
> superblock info.

It should. You tried to write to it in expert mode, though. Try just
printing the field in read-only mode (-r)....

> And as a xfs debugger, xfs_db should can ignore
> unexpected errors to continue the "expert" command which an expert
> want to do.

You're making the assumption that "-x" makes the user an expert.
That is far from the truth - it just means someone read a man page,
not that they have any specific XFS knowledge. The talk I
gave at LCA 2015 is relevant here:

https://www.youtube.com/watch?v=VpuVDfSXs-g

I go into a bit of depth about how cognitive biases affect how
people learn and assess their levels of expertise. This should
explain why "expert" mode still needs /some/ safeguards.

Remember: feature flags are the most critical part of the on-disk
format because they tell everything that parses the on-disk format
what format exists on disk. If it is changed to something the tools
don't recognise, the tools should /absolutely refuse/ to run in
anything other than the mode indicated by the feature flags (i.e.
read-only or not at all).

This, however, only turns off part of xfs_db's "make it
easy-for-non-experts" automatic type detection functionality. If you
know what you are doing and how xfs_db works (i.e. the user is an
expert), this is trivial to get around.

So, let me demonstrate:

$ sudo xfs_db -x -c "sb 0" -c "write features_ro_compat 4096" /dev/vdc
features_ro_compat = 0x1000
$ sudo xfs_db -x -c "sb 0" -c "write features_ro_compat 0" /dev/vdc
Superblock has unknown read-only compatible features (0x1000) enabled.
Attempted to mount read-only compatible filesystem read-write.
Filesystem can only be safely mounted read only.
no current type
$

Ok, there's an error there that tells me I can't decode the buffer
that was loaded because automatic type detection was not run. So,
lets load it as a raw buffer and set the type manually:

$ sudo xfs_db -r -c "daddr 0" -c "type sb" -c "p features_ro_compat" /dev/vdc
Superblock has unknown read-only compatible features (0x1000) enabled.
Attempted to mount read-only compatible filesystem read-write.
Filesystem can only be safely mounted read only.
features_ro_compat = 0x1000

Yup, there we go, access to the superblock type parsing is
re-enabled by starting with a raw data buffer, then setting the type
manually. We probably should fix userspace to then remount in
read-only mode so this works correctly without needing this step.
(It's probably just a libxfs init flag that is wrong.)

So:

$ sudo xfs_db -x -c "daddr 0" -c "type sb" -c "write features_ro_compat 0" /dev/vdc
Superblock has unknown read-only compatible features (0x1000) enabled.
Attempted to mount read-only compatible filesystem read-write.
Filesystem can only be safely mounted read only.
features_ro_compat = 0
$ sudo xfs_db -r -c "sb 0" -c "p features_ro_compat" /dev/vdc
features_ro_compat = 0
$

Yup, I just reset it to zero with expert mode, simply by knowing how
xfs_db works and avoiding the error that occurred with automatic type
detection. But even if I can't set the type manually, I can still
fix this by going back to first principles.

$ sudo xfs_db -x -c "sb 0" -c "write features_ro_compat 4096" /dev/vdc
features_ro_compat = 0x1000
$

First - manually find the on-disk format structure offset:

$ pahole fs/xfs/libxfs/xfs_sb.o |grep sb_features_ro_compat
	__uint32_t                 sb_features_ro_compat; /*   212     4 */
	__be32                     sb_features_ro_compat; /*   212     4 */
$

Now we can just write zeros directly to the raw buffer, then check
it by re-reading the superblock using the automatic type detection:

$ sudo xfs_db -x -c "daddr 0" -c "write fill 0 212 4" -c "sb 0" -c "p features_ro_compat" /dev/vdc
features_ro_compat = 0

Yup, problem solved.  But:

$ sudo xfs_db -r -c "sb 0" -c "p features_ro_compat" /dev/vdc
Metadata CRC error detected at xfs_sb block 0x0/0x200
features_ro_compat = 0

It's not a clean solution for v5 filesystems - I have to recalc the
CRC. Previous I would have simply run xfs_repair to fix this, but
now I can do this:

$ sudo xfs_db -x -c "sb 0" -c "crc" -c "crc -r" /dev/vdc
Verifying CRC:
crc = 0xdea3392d (bad)
Recalculating CRC:
crc = 0x3a7763c8 (correct)
$ sudo xfs_db -r -c "sb 0" -c "p features_ro_compat" /dev/vdc
features_ro_compat = 0
$

And now it's all good.

So, as you can see we have /multiple ways/ we can fix bad feature
fields with xfs_db. None of them require magic force flags, but it
does require the ability to solve problems from first principles.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
