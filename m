Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jun 2008 22:08:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5658Bmr019276
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2008 22:08:13 -0700
Subject: TAKE 982930 - fix dir2 shortform structures on ARM old ABI
Message-Id: <20080606050858.56FB758C4C3F@chook.melbourne.sgi.com>
Date: Fri,  6 Jun 2008 15:08:58 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Pack some shortform dir2 structures for the ARM old ABI architecture.

Finally put this in for Eric and the users of this arch.

>From Eric initially...

This should fix the longstanding issues with xfs and old ABI
arm boxes, which lead to various asserts and xfs shutdowns,
and for which an (incorrect) patch has been floating around
for years.

I've verified this patch by comparing the on-disk structure
layouts using pahole from the dwarves package, as well as
running through a bit of xfsqa under qemu-arm, modified so
that the check/repair phase after each test actually executes
check/repair from the x86 host, on the filesystem populated
by the arm emulator.  Thus far it all looks good.

There are 2 other structures with extra padding at the end,
but they don't seem to cause trouble.  I suppose they could
be packed as well: xfs_dir2_data_unused_t and xfs_dir2_sf_t.

Note that userspace needs a similar treatment, and any
filesystems which were running with the previous rogue
"fix" will now see corruption (either in the kernel, or
during xfs_repair) with this fix properly in place; it
may be worth teaching xfs_repair to identify and fix that
specific issue.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Jun  6 15:07:06 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31280a
fs/xfs/xfs_dir2_sf.h - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.h.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Fix up some dir2 shortform structures for ARM using packing

fs/xfs/linux-2.6/xfs_linux.h - 1.167 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.167&r2=text&tr2=1.166&f=h
	- setup __arch_pack for packing for ARM old ABI
