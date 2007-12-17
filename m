Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 17:07:12 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH178nh006437
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:07:09 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58A0511689B2
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:07:14 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id XCivC1yNmRqWACji for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:07:14 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id A0B20182DD1D9
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 19:07:12 -0600 (CST)
Message-ID: <4765CBBF.1020207@sandeen.net>
Date: Sun, 16 Dec 2007 19:07:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Installing grub onto a system with XFS root fs
References: <20071217004945.GA13335@jdc.jasonjgw.net>
In-Reply-To: <20071217004945.GA13335@jdc.jasonjgw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Jason White wrote:
> I am trying to install Grub onto a system with a single XFS partition serving
> as both / and /boot.
> 
> Distribution: Debian Unstable (Sid).
> Architecture: x86_64
> 
> When I run grub-install I get:
> Searching for GRUB installation directory ... found: /boot/grub
> Due to a bug in xfs_freeze, the following command might produce a segmentation
> fault when /boot/grub is not in an XFS filesystem. This error is harmless and
> can be ignored.

Hrm, that's funky.

> At this point the install script hangs and the only way to recover is to
> reboot the machine (with a hard reset). Needless to say, Grub isn't installed.
> 
> Any suggestions?
> 
> Note that the installation of grub failed during the Debian installation
> process for a reason that wasn't specified (no helpful error message).
> 

Hard to say - in a nutshell, grub just sucks w.r.t. how it (ab)uses the
filesystem it's trying to install on.

In some invocations, it actually writes directly to the block device
*while it is mounted* - this leads to data corruption and/or filesystem
corruption.

In other cases, in a "verification" phase, it tries to directly read
filesystem structures off the disk *while it is mounted* after a couple
of wishful sync; sync;'s - this often can lead to a grub hang when it
goes off in the weeds on inconsistent disk data that it finds.

I think various distros have tried to hack around these problems in
different ways; the freeze above is probably an effort to coalesce the
filesystem before grub goes groveling around the disk to verify what it
just wrote(!).

If you:

a) don't write to the bdev while mounted

and b) don't try to read the mounted filesystem via the bdev (skip
verification steps)

it should all work ok.

(for fedora grub, a) means passing the path to the stage2 files on the
commandline to grub-install, ymmv):

install --stage2=/boot/grub/stage2 (hd0,7)/grub/stage1 d (hd0)
/grub/stage2 p
(hd0,7)/grub/grub.conf

for some reason this stops grub from writing to the mounted block device.

Otherwise, I'd bug debian - honestly, this isn't an xfs bug.

-Eric
