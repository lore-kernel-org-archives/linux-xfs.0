Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42483 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfEDMJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 May 2019 08:09:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id y10so846384lji.9
        for <linux-xfs@vger.kernel.org>; Sat, 04 May 2019 05:09:11 -0700 (PDT)
MIME-Version: 1.0
From: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Date: Sat, 4 May 2019 15:08:59 +0300
Message-ID: <CAE5jQCfP95cvjkKTmawpbfFLmBVwYZ3t89WED=U3uk4z+7U+CQ@mail.gmail.com>
Subject: [v5.0.0] Assertion in xfs_repair: dir2.c:1445: process_dir2:
 Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino ==
 mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
Content-Type: multipart/mixed; boundary="00000000000021256605880ebcba"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

--00000000000021256605880ebcba
Content-Type: text/plain; charset="UTF-8"

By fuzzing the xfsprogs 5.0.0 (commit 65dcd3bc), I have found a
modification to the image, that triggers an assertion in xfs_repair.
An assertion like this was already fixed almost a year ago (see commit
77b3425 @ Jun 21 2018), but this reproducer works for the v5.0.0
xfsprogs release.

## How to reproduce:
Clone xfsprogs (commit 65dcd3bc30) and run `make`, then run

$ ./repair/xfs_repair -Pnf /tmp/xfs.img
Cannot get host filesystem geometry.
Repair may fail if there is a sector size mismatch between
the image and the host filesystem.
Phase 1 - find and verify superblock...
Cannot get host filesystem geometry.
Repair may fail if there is a sector size mismatch between
the image and the host filesystem.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
Metadata CRC error detected at 0x55836064d5a4, xfs_agfl block 0x10003/0x200
agfl has bad CRC for ag 1
Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20018/0x1000
btree block 2/3 is suspect, error -74
Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20020/0x1000
btree block 2/4 is suspect, error -74
Metadata CRC error detected at 0x55836065120d, xfs_allocbt block 0x8/0x1000
btree block 0/1 is suspect, error -74
Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20/0x1000
btree block 0/4 is suspect, error -74
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad CRC for inode 96
bad CRC for inode 117
bad CRC for inode 133
bad CRC for inode 137
bad CRC for inode 96, would rewrite
would have corrected root directory 96 .. entry from 9056 to 96
xfs_repair: dir2.c:1445: process_dir2: Assertion `(ino !=
mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
&& (ino == *parent || need_root_dotdot == 1))' failed.

## Stack trace:

(gdb) bt
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007ffff7d36535 in __GI_abort () at abort.c:79
#2  0x00007ffff7d3640f in __assert_fail_base (fmt=0x7ffff7ec4588
"%s%s%s:%u: %s%sAssertion `%s' failed.\n%n", assertion=0x5555555dc7c0
"(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino ==
mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))",
    file=0x5555555dc8b2 "dir2.c", line=1445, function=<optimized out>)
at assert.c:92
#3  0x00007ffff7d46012 in __GI___assert_fail
(assertion=assertion@entry=0x5555555dc7c0 "(ino != mp->m_sb.sb_rootino
&& ino != *parent) || (ino == mp->m_sb.sb_rootino && (ino == *parent
|| need_root_dotdot == 1))", file=file@entry=0x5555555dc8b2 "dir2.c",
    line=line@entry=1445, function=function@entry=0x5555555dca90
<__PRETTY_FUNCTION__.12672> "process_dir2") at assert.c:101
#4  0x000055555556ae15 in process_dir2 (mp=mp@entry=0x7fffffffd930,
ino=ino@entry=96, dip=dip@entry=0x55555565b200,
ino_discovery=ino_discovery@entry=1,
dino_dirty=dino_dirty@entry=0x7fffffffd438,
dirname=dirname@entry=0x5555555dfc7f "", parent=0x7fffffffd440,
    blkmap=0x0) at dir2.c:1443
#5  0x00005555555687d1 in process_dinode_int
(mp=mp@entry=0x7fffffffd930, dino=dino@entry=0x55555565b200,
agno=agno@entry=0, ino=ino@entry=96, was_free=<optimized out>,
dirty=dirty@entry=0x7fffffffd438, used=0x7fffffffd434, verify_mode=0,
uncertain=0, ino_discovery=1,
    check_dups=0, extra_attr_check=1, isa_dir=0x7fffffffd43c,
parent=0x7fffffffd440) at dinode.c:2819
#6  0x0000555555569378 in process_dinode (mp=mp@entry=0x7fffffffd930,
dino=dino@entry=0x55555565b200, agno=agno@entry=0, ino=ino@entry=96,
was_free=<optimized out>, dirty=dirty@entry=0x7fffffffd438,
used=0x7fffffffd434, ino_discovery=1, check_dups=0,
    extra_attr_check=1, isa_dir=0x7fffffffd43c, parent=0x7fffffffd440)
at dinode.c:2936
#7  0x00005555555625cb in process_inode_chunk
(mp=mp@entry=0x7fffffffd930, agno=agno@entry=0,
first_irec=first_irec@entry=0x7fffe0005720,
ino_discovery=ino_discovery@entry=1, check_dups=check_dups@entry=0,
extra_attr_check=extra_attr_check@entry=1,
    bogus=0x7fffffffd4d4, num_inos=64) at incore.h:472
#8  0x000055555556394a in process_aginodes (mp=0x7fffffffd930,
pf_args=pf_args@entry=0x0, agno=agno@entry=0,
ino_discovery=ino_discovery@entry=1, check_dups=check_dups@entry=0,
extra_attr_check=extra_attr_check@entry=1) at dino_chunks.c:1031
#9  0x000055555556f62f in process_ag_func (wq=0x7fffffffd5d0, agno=0,
arg=0x0) at phase3.c:67
#10 0x000055555557cc0b in prefetch_ag_range (work=0x7fffffffd5d0,
start_ag=<optimized out>, end_ag=4, dirs_only=false,
func=0x55555556f5e0 <process_ag_func>) at prefetch.c:968
#11 0x000055555557e675 in do_inode_prefetch
(mp=mp@entry=0x7fffffffd930, stride=0, func=func@entry=0x55555556f5e0
<process_ag_func>, check_cache=check_cache@entry=false,
dirs_only=dirs_only@entry=false) at prefetch.c:1031
#12 0x000055555556f79b in process_ags (mp=0x7fffffffd930) at phase3.c:135
#13 phase3 (mp=0x7fffffffd930, scan_threads=32) at phase3.c:135
#14 0x000055555555a440 in main (argc=<optimized out>, argv=<optimized
out>) at xfs_repair.c:940

Best regards
Anatoly

--00000000000021256605880ebcba
Content-Type: application/octet-stream; name="xfs.img.bz2"
Content-Disposition: attachment; filename="xfs.img.bz2"
Content-Transfer-Encoding: base64
Content-ID: <f_jv9gbi0c0>
X-Attachment-Id: f_jv9gbi0c0

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
JX9+Iu5IpwoSEVIJB+A=
--00000000000021256605880ebcba--
