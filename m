Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 13:11:47 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6QKBfbm011179
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jul 2007 13:11:43 -0700
Received: from localhost (dslb-084-056-125-167.pools.arcor-ip.net [84.56.125.167])
	by mail.lichtvoll.de (Postfix) with ESMTP id 74C9D5ADEE
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jul 2007 22:12:33 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: xfstest 42 does not like to use my $SCRATCH_DEV setting
Date: Thu, 26 Jul 2007 22:11:40 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200707262211.40995.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi!

I tried patching xfstests so that test 42 can be used without scratchdev 
with the patch I got from Timothy.

martin@shambala:Quelltext/xfs-cmds/xfstests> patch -p2 
< ../../xfstests-notestdir.patch
patching file check
patching file common.config
patching file common.rc


Then I configured my scratch device:

martin@shambala:Quelltext/xfs-cmds/xfstests> vim local.config
martin@shambala:Quelltext/xfs-cmds/xfstests> cat local.config
SCRATCH_DEV=/dev/sda3
SCRATCH_MNT=/mnt/zeit


Then I tried running is:

martin@shambala:Quelltext/xfs-cmds/xfstests> su
Password:
shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
fsstress not found


Okay, so I installed that one and configured it:

shambala:Quelltext/xfs-cmds/xfstests> aptitude install ltp-kernel-test
[... went well ...]
shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
fsstress not found
shambala:Quelltext/xfs-cmds/xfstests#1> vim ./common.config
shambala:Quelltext/xfs-cmds/xfstests> grep "fsstress" common.config
[... three SOAK options ...]
#export FSSTRESS_PROG="`set_prog_path fsstress $PWD/ltp/fsstress`"
export 
FSSTRESS_PROG="/usr/lib/debian-test/tests/linux/testcases/bin/fsstress"
[ "$FSSTRESS_PROG" = "" ] && _fatal "fsstress not found"


Then I ran the test:

shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.21.6-tp42-cfs-v19-sws2-2.2.10
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- /dev/sda3 /mnt/zeit

042      [not run] this test requires a valid $SCRATCH_DEV
Not run: 042
Passed all 0 tests


I added debug output at the end of the common.config script and ran the 
test again:

shambala:Quelltext/xfs-cmds/xfstests> vim ./common.config
shambala:Quelltext/xfs-cmds/xfstests> tail -4 common.config
echo "Scratch device: $SCRATCH_DEV"
echo "Scratch mount point: $SCRATCH_MNT"
# make sure this script returns success
/bin/true
shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
Scratch device: /dev/sda3
Scratch mount point: /mnt/zeit
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.21.6-tp42-cfs-v19-sws2-2.2.10
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- /dev/sda3 /mnt/zeit

042      [not run] this test requires a valid $SCRATCH_DEV
Not run: 042
Passed all 0 tests


Then I tried the mkfs command from test 42 manually:

shambala:~#1> mkfs.xfs -f -dsize=48m,agcount=3 /dev/sda3
meta-data=/dev/sda3              isize=256    agcount=3, agsize=4096 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=12288, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=1200, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

It needs the -f cause there was already a filesystem on it.


So I nulled enough of it so that mkfs.xfs without -f won't complain and 
run the test again:

shambala:~> dd if=/dev/zero of=/dev/sda3 bs=1000k count=2
2+0 Datensätze ein
2+0 Datensätze aus
2048000 Bytes (2,0 MB) kopiert, 0,177404 Sekunden, 11,5 MB/s
shambala:~> LANG=EN dd if=/dev/zero of=/dev/sda3 bs=1000k count=2
2+0 records in
2+0 records out
2048000 bytes (2.0 MB) copied, 0.0940016 seconds, 21.8 MB/s
shambala:~> mkfs.xfs -dsize=48m,agcount=3 /dev/sda3
meta-data=/dev/sda3              isize=256    agcount=3, agsize=4096 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=12288, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=1200, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
shambala:~> LANG=EN dd if=/dev/zero of=/dev/sda3 bs=1000k count=2
2+0 records in
2+0 records out
2048000 bytes (2.0 MB) copied, 0.090204 seconds, 22.7 MB/s

shambala:Quelltext/xfs-cmds/xfstests> ./check -l 42
Scratch device: /dev/sda3
Scratch mount point: /mnt/zeit
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.21.6-tp42-cfs-v19-sws2-2.2.10
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda3
MOUNT_OPTIONS -- /dev/sda3 /mnt/zeit

042      [not run] this test requires a valid $SCRATCH_DEV
Not run: 042
Passed all 0 tests


The moint exists and is not used currently:

shambala:~> ls -ld /mnt/zeit
drwxr-xr-x 2 root root 6 2007-06-24 13:03 /mnt/zeit
shambala:~> mount | grep /mnt/zeit
shambala:~#1>


I also tried putting the exports for SCRATCH_DEV and SCRATCH_MNT directly 
in check and 042 scripts but this didn't help either.


Any hints how I can persuade test 42 to actually believe that it can use 
that scratch partition? 

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
