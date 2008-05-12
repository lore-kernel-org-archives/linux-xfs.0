Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 00:26:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4C7PdN3012993
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 00:25:41 -0700
Date: Mon, 12 May 2008 17:26:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: xfsprogs 2.9.8 gives unaligned access warnings on ia64
Message-ID: <20080512072621.GG155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Barry,

I just upgraded to xfsprogs 2.9.8 and now every time xfs_check
or xfs_repair runs I get a bunch of unaligned access warnings.
I can't remember what the proevious version was on this machine;
might have been 2.9.4.

$ sudo ./check 018
[sudo] password for dgc:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ia64 budgie 2.6.25-rc3-dgc-xfs
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- /dev/sdb6 /mnt/scratch

xfs_db(23565): unaligned access to 0x6000000000041264, ip=0x4000000000062a71
xfs_db(23565): unaligned access to 0x600000000004126c, ip=0x4000000000062a80
xfs_repair(23566): unaligned access to 0x2000000004000e64, ip=0x4000000000080c81
xfs_repair(23566): unaligned access to 0x2000000004000e6c, ip=0x4000000000080c90
xfs_repair(23566): unaligned access to 0x2000000004001664, ip=0x4000000000080c81
018
xfs_db(24234): unaligned access to 0x6000000000041264, ip=0x4000000000062a71
xfs_db(24234): unaligned access to 0x600000000004126c, ip=0x4000000000062a80
xfs_repair(24235): unaligned access to 0x6000000000020264, ip=0x4000000000080c81
xfs_repair(24235): unaligned access to 0x600000000002026c, ip=0x4000000000080c90
xfs_repair(24235): unaligned access to 0x6000000000020a64, ip=0x4000000000080c81
Passed all 1 tests
$ sudo xfs_repair -V
xfs_repair version 2.9.8

I'm going to turn this warning off manually (systune), but this really
needs fixing ASAP.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
