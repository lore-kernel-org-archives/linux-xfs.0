Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0D6B7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 18:13:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A66D48F8037
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 16:12:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MCUuBs0n2KmxrnJo for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 16:12:53 -0700 (PDT)
Date: Thu, 4 Jul 2013 09:12:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs should provide hook script for initramfs-tools
Message-ID: <20130703231246.GQ14996@dastard>
References: <CADyPfthesmv4ae0uDevzYQ+7srX26auSJWaB-72=qKrHbTLN4w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADyPfthesmv4ae0uDevzYQ+7srX26auSJWaB-72=qKrHbTLN4w@mail.gmail.com>
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
To: Lubomir Host <lubomir.host@gmail.com>
Cc: XFS Development Team <xfs@oss.sgi.com>

On Wed, Jul 03, 2013 at 10:40:16PM +0200, Lubomir Host wrote:
> Package: xfsprogs
> Version: 3.1.9
> Severity: minor
> Tags: patch
> 
> Dear Maintainer,
> 
> If your rootfs is XFS (I hope it is :) ), you should include some XFS tools
> into initrd.
> It would be handy in emergency situation. E.g. will help you to boot your
> domU.

Debian doesn't include any filesystem utilities in the initramfs,
not even the fsck binary.

> Log from the Xen console:
> 
> Begin: Running /scripts/local-bottom ... done.
> done.
> Begin: Running /scripts/init-bottom ... done.
> INIT: version 2.88 booting
> [info] Using makefile-style concurrent boot in runlevel S.
> [ ok ] Starting the hotplug events dispatcher: udevd.
> [ ok ] Synthesizing the initial hotplug events...done.
> [ ok ] Waiting for /dev to be fully populated...done.
> [ ok ] Activating swap...done.
> [....] Checking root file system...fsck from util-linux 2.20.1
> fsck: fsck.xfs: not found
> fsck: error 2 while executing fsck.xfs for /dev/xvda2
> fsck died with exit status 8
> failed (code 8).

I don't see how this is initramfs problem - the root filesystem
should be mounted read only at this point, and so all the fsck
binaries should be available to the rcS.d scripts. Indeed, where did
it find the fsck binary from?

> . /usr/share/initramfs-tools/hook-functions
> 
> for x in xfs_copy xfs_db xfs_admin xfs_check xfs_ncheck xfs_metadump xfs_estimate xfs_fsr xfs_growfs xfs_info xfs_io xfs_bmap xfs_freeze xfs_mkfile xfs_logprint xfs_quota xfs_mdrestore xfs_rtcp; do
> 	copy_exec /usr/sbin/$x
> done
> copy_exec /sbin/xfs_repair
> copy_exec /sbin/mkfs.xfs

I don't think that's advisable:

$ ldd /usr/sbin/xfs_db
        linux-vdso.so.1 (0x00007fff607fe000)
        libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1 (0x00007f98702fb000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f98700f3000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f986fed6000)
        libreadline.so.5 => /lib/x86_64-linux-gnu/libreadline.so.5 (0x00007f986fc95000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f986f8e8000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f9870511000)
        libtinfo.so.5 => /lib/x86_64-linux-gnu/libtinfo.so.5 (0x00007f986f6be000)

Those are not static binaries, and so cannot be used in a initramfs
environment. They'd rely on the root filesystem being mounted read
only and having all these libraries in the search path.  And if
you've got that, then you should also have the binaries themselves
on the read-only root filesystem, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
