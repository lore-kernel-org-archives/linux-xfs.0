Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B83C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 08:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiEWI3S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 04:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiEWI3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 04:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6522FE51
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 01:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A8B61259
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 08:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9359EC3411A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 08:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653294555;
        bh=oH5Gw58Rrb84VDEhsMTkCWn+ToDkAwAsgt5okoqGr5o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DIFPHfFckfyJ3CdEHZ8RaYtLGEUigyzpKKtnq62IXNSxgqGgpmkJvY9P6O3aE2KCk
         xLY6K8V/5T3jZFj2T/FPn+RNaeg7MrpPTvynH7Fg5vUIxm+2bsjFxWvMYZC5GRAl4e
         BNInVxypCppn7XcqNwNhdmTkd3BRVXAHun2t2cg9QNHnIszB4IJb5RXkLMGhhHsgYY
         XSJ0k0V5JG3h8zB/W/dpCfnTtAnsqtSetFJNmvb/XZ7AwmUuusEEIRRiz0EeuYjd+5
         Bf18KZiv0JjQtI2GHZW1Zy7L+NFAKBxt6eUfjyinLJJlBHhZLj4XFhhiY+6y3Wi67g
         4HkWCFV9Le63g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 80AD4C05FD2; Mon, 23 May 2022 08:29:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Mon, 23 May 2022 08:29:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-bROEL8eFC5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #6 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
(In reply to Chris Murphy from comment #2)
> Please see
> https://xfs.org/index.php/XFS_FAQ#Q:
> _What_information_should_I_include_when_reporting_a_problem.3F and
> supplement the bug report with the missing information. Thanks.

certainly!

> kernel version (uname -a)

5.15.32-gentoo-r1

> xfsprogs version (xfs_repair -V)

xfs_repair version 5.14.2

> number of CPUs

1 CPU, 2 cores (Intel Celeron G1610T @ 2.30GHz)

> contents of /proc/meminfo

(at the time of iowait hangup)

MemTotal:        3995528 kB
MemFree:           29096 kB
MemAvailable:    3749216 kB
Buffers:           19984 kB
Cached:          3556248 kB
SwapCached:            0 kB
Active:            62888 kB
Inactive:        3560968 kB
Active(anon):        272 kB
Inactive(anon):    47772 kB
Active(file):      62616 kB
Inactive(file):  3513196 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2097084 kB
SwapFree:        2097084 kB
Dirty:                28 kB
Writeback:             0 kB
AnonPages:         47628 kB
Mapped:            19540 kB
Shmem:               416 kB
KReclaimable:     199964 kB
Slab:             286472 kB
SReclaimable:     199964 kB
SUnreclaim:        86508 kB
KernelStack:        1984 kB
PageTables:         1648 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4094848 kB
Committed_AS:     117448 kB
VmallocTotal:   34359738367 kB
VmallocUsed:        2764 kB
VmallocChunk:          0 kB
Percpu:              832 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:       20364 kB
DirectMap2M:     4139008 kB

> contents of /proc/mounts

/dev/root / ext4 rw,noatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,relatime,size=3D10240k,nr_inodes=3D498934,=
mode=3D755
0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /run tmpfs rw,nosuid,nodev,size=3D799220k,nr_inodes=3D819200,mode=3D7=
55 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
cgroup_root /sys/fs/cgroup tmpfs
rw,nosuid,nodev,noexec,relatime,size=3D10240k,mode=3D755 0 0
openrc /sys/fs/cgroup/openrc cgroup
rw,nosuid,nodev,noexec,relatime,release_agent=3D/lib/rc/sh/cgroup-release-a=
gent.sh,name=3Dopenrc
0 0
none /sys/fs/cgroup/unified cgroup2 rw,nosuid,nodev,noexec,relatime,nsdeleg=
ate
0 0
mqueue /dev/mqueue mqueue rw,nosuid,nodev,noexec,relatime 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000 0
0
shm /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc
rw,nosuid,nodev,noexec,relatime 0 0
/dev/sdc1 /mnt/test xfs
rw,relatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,noquota 0 0

> contents of /proc/partitions

major minor  #blocks  name

   1        0      16384 ram0
   1        1      16384 ram1
   1        2      16384 ram2
   1        3      16384 ram3
   1        4      16384 ram4
   1        5      16384 ram5
   1        6      16384 ram6
   1        7      16384 ram7
   1        8      16384 ram8
   1        9      16384 ram9
   1       10      16384 ram10
   1       11      16384 ram11
   1       12      16384 ram12
   1       13      16384 ram13
   1       14      16384 ram14
   1       15      16384 ram15
   8        0 1953514584 sda
   8        1     131072 sda1
   8        2    2097152 sda2
   8        3 1951285336 sda3
   8       16 1953514584 sdb
   8       17     131072 sdb1
   8       18    2097152 sdb2
   8       19 1951285336 sdb3
   8       32  976762584 sdc
   8       33  976761560 sdc1
  11        0    1048575 sr0
   9        3 1951285248 md3
   9        2    2097088 md2
   9        1     131008 md1

> RAID layout (hardware and/or software)

software RAID1 on system disks (/dev/sda + /dev/sdb, ext4)
no RAID on xfs disk (/dev/sdc, xfs)

> LVM configuration

no LVM

> type of disks you are using

CMR 3.5" SATA disks

/dev/sda and /dev/sdb: WD Red 2TB (WDC WD20EFRX-68EUZN0)
/dev/sdc: Seagate Constellation ES 1TB (MB1000GCEEK)

> write cache status of drives

not sure - how do I find out?

> size of BBWC and mode it is running in

no HW RAID (the drive controller is set to AHCI mode)
no battery backup

> xfs_info output on the filesystem in question

meta-data=3D/dev/sdc1              isize=3D512    agcount=3D4, agsize=3D610=
47598 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1    bigtime=3D0 inobtcount=3D0
data     =3D                       bsize=3D4096   blocks=3D244190390, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D119233, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

> dmesg output showing all error messages and stack traces

already an attachment to this ticket

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
