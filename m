Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 954B37CBF
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 16:26:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 167AFAC00A
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 14:26:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gGWlSCg9pLsbl2Lz for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 14:26:05 -0700 (PDT)
Message-ID: <51D496EA.7030008@sandeen.net>
Date: Wed, 03 Jul 2013 17:26:02 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs should provide hook script for initramfs-tools
References: <CADyPfthesmv4ae0uDevzYQ+7srX26auSJWaB-72=qKrHbTLN4w@mail.gmail.com>
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

On 7/3/13 4:40 PM, Lubomir Host wrote:
> Package: xfsprogs
> Version: 3.1.9
> Severity: minor
> Tags: patch
> 
> Dear Maintainer,
> 
> If your rootfs is XFS (I hope it is :) ), you should include some XFS tools into initrd.
> It would be handy in emergency situation. E.g. will help you to boot your domU.
> 
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

Quite honestly, this should not be a hard failure.

I'd call this a bug in whatever infrastructure has decided to
fail boot for lack of a no-op binary (i.e. fsck.xfs).

> fsck: error 2 while executing fsck.xfs for /dev/xvda2
> fsck died with exit status 8
> failed (code 8).
> [....] An automatic file system check (fsck) of the root filesystem
> failed. A manual fsck must be performed, then the system restarted.
> The fsck should be performed in maintenance mo[FAILth the root
> filesystem mounted in read-only mode. ... failed!

Failed all right, but there's no reason to fail boot for this.

Anyway -

I had looked into including the $FOO.d/$BAR.conf files required
to include xfs bits, but at least in Fedora, it already pulled
in the right bits.

So yes, indicating xfs_repair, xfs_db, xfs_metadump for initramfs
would probably be a fine idea for distros that don't do it by default,
but failing boot for lack of fsck.xfs is awfully harsh.

This might be a per-distro-package thing, if Debian needs different
hints than Fedora, etc, to get a working boot-time environment?

-Eric

> [....] The root filesystem is currently mounted in read-only mode. A
> maintenance shell will now be started. After performing system
> maintenance, press CONTROL-D to terminate the main[warnce shell and
> restart the system. ... (warning).> Give root password for maintenance
> (or type Control-D to continue):
> 
> 
> -- System Information:
> Debian Release: jessie/sid
>   APT prefers unstable
>   APT policy: (500, 'unstable')
> Architecture: amd64 (x86_64)
> 
> Kernel: Linux 3.9-1-amd64 (SMP w/2 CPU cores)
> Locale: LANG=sk_SK, LC_CTYPE=sk_SK.UTF-8 (charmap=ANSI_X3.4-1968) (ignored: LC_ALL set to C)
> Shell: /bin/sh linked to /bin/dash
> 
> Versions of packages xfsprogs depends on:
> ii  libblkid1     2.20.1-5.4
> ii  libc6         2.17-7
> ii  libreadline5  5.2+dfsg-2
> ii  libuuid1      2.20.1-5.4
> 
> xfsprogs recommends no packages.
> 
> Versions of packages xfsprogs suggests:
> ii  acl      2.2.52-1
> pn  attr     <none>
> pn  quota    <none>
> pn  xfsdump  <none>
> 
> -- no debconf information
> 
> 
> -- 
> http://blog.hostname.sk/ <http://blog.hostname.sk/gmail>debianbug
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
