Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfEFSzo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 May 2019 14:55:44 -0400
Subject: Re: [v5.0.0] Assertion in xfs_repair: dir2.c:1445: process_dir2:
 Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino ==
 mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
From: Eric Sandeen <sandeen@sandeen.net>
References: <CAE5jQCfP95cvjkKTmawpbfFLmBVwYZ3t89WED=U3uk4z+7U+CQ@mail.gmail.com>
 <d057c6f1-cbce-c986-ccbf-b0ca266484e5@sandeen.net>
Message-ID: <fff02ae6-583e-9afd-4409-8dd266a43047@sandeen.net>
Date: Mon, 6 May 2019 13:55:42 -0500
MIME-Version: 1.0
In-Reply-To: <d057c6f1-cbce-c986-ccbf-b0ca266484e5@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>, linux-xfs@vger.kernel.org

On 5/6/19 1:41 PM, Eric Sandeen wrote:
> On 5/4/19 7:08 AM, Anatoly Trosinenko wrote:
>> By fuzzing the xfsprogs 5.0.0 (commit 65dcd3bc), I have found a
>> modification to the image, that triggers an assertion in xfs_repair.
>> An assertion like this was already fixed almost a year ago (see commit
>> 77b3425 @ Jun 21 2018), but this reproducer works for the v5.0.0
>> xfsprogs release.
> 
> FWIW, back at commit 77b3425 this image still fails w/ the same assert.
> So, this doesn't seem like a regression.  I'll take a look.
> 
> Thanks,
> -Eric
> 
>> ## How to reproduce:
>> Clone xfsprogs (commit 65dcd3bc30) and run `make`, then run
>>
>> $ ./repair/xfs_repair -Pnf /tmp/xfs.img
>> Cannot get host filesystem geometry.
>> Repair may fail if there is a sector size mismatch between
>> the image and the host filesystem.
>> Phase 1 - find and verify superblock...
>> Cannot get host filesystem geometry.
>> Repair may fail if there is a sector size mismatch between
>> the image and the host filesystem.
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>> Metadata CRC error detected at 0x55836064d5a4, xfs_agfl block 0x10003/0x200
>> agfl has bad CRC for ag 1
>> Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20018/0x1000
>> btree block 2/3 is suspect, error -74
>> Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20020/0x1000
>> btree block 2/4 is suspect, error -74
>> Metadata CRC error detected at 0x55836065120d, xfs_allocbt block 0x8/0x1000
>> btree block 0/1 is suspect, error -74
>> Metadata CRC error detected at 0x558360680abd, xfs_inobt block 0x20/0x1000
>> btree block 0/4 is suspect, error -74
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>> bad CRC for inode 96
>> bad CRC for inode 117
>> bad CRC for inode 133
>> bad CRC for inode 137
>> bad CRC for inode 96, would rewrite
>> would have corrected root directory 96 .. entry from 9056 to 96
>> xfs_repair: dir2.c:1445: process_dir2: Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))' failed.

So, if you look at the assertion and the line above it, it's telling you

1) it /would/ have corrected the root inode ".." entry to point to itself

but we're in -n no-modify mode, so it didn't fix it, and then

2) the ASSERT trips on that unfixed ".." entry.

So the ASSERT should probably not fire in "-n" mode, since it's expected
to find this inconsistency.  Would you care to send a patch?

(h/t Darrick for looking at this, thanks.)

Thanks,
-Eric

>> ## Stack trace:
>>
>> (gdb) bt
>> #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
>> #1  0x00007ffff7d36535 in __GI_abort () at abort.c:79
>> #2  0x00007ffff7d3640f in __assert_fail_base (fmt=0x7ffff7ec4588
>> "%s%s%s:%u: %s%sAssertion `%s' failed.\n%n", assertion=0x5555555dc7c0
>> "(ino != mp->m_sb.sb_rootino && ino != *parent) || (ino ==
>> mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))",
>>     file=0x5555555dc8b2 "dir2.c", line=1445, function=<optimized out>)
>> at assert.c:92
>> #3  0x00007ffff7d46012 in __GI___assert_fail
>> (assertion=assertion@entry=0x5555555dc7c0 "(ino != mp->m_sb.sb_rootino
>> && ino != *parent) || (ino == mp->m_sb.sb_rootino && (ino == *parent
>> || need_root_dotdot == 1))", file=file@entry=0x5555555dc8b2 "dir2.c",
>>     line=line@entry=1445, function=function@entry=0x5555555dca90
>> <__PRETTY_FUNCTION__.12672> "process_dir2") at assert.c:101
>> #4  0x000055555556ae15 in process_dir2 (mp=mp@entry=0x7fffffffd930,
>> ino=ino@entry=96, dip=dip@entry=0x55555565b200,
>> ino_discovery=ino_discovery@entry=1,
>> dino_dirty=dino_dirty@entry=0x7fffffffd438,
>> dirname=dirname@entry=0x5555555dfc7f "", parent=0x7fffffffd440,
>>     blkmap=0x0) at dir2.c:1443
>> #5  0x00005555555687d1 in process_dinode_int
>> (mp=mp@entry=0x7fffffffd930, dino=dino@entry=0x55555565b200,
>> agno=agno@entry=0, ino=ino@entry=96, was_free=<optimized out>,
>> dirty=dirty@entry=0x7fffffffd438, used=0x7fffffffd434, verify_mode=0,
>> uncertain=0, ino_discovery=1,
>>     check_dups=0, extra_attr_check=1, isa_dir=0x7fffffffd43c,
>> parent=0x7fffffffd440) at dinode.c:2819
>> #6  0x0000555555569378 in process_dinode (mp=mp@entry=0x7fffffffd930,
>> dino=dino@entry=0x55555565b200, agno=agno@entry=0, ino=ino@entry=96,
>> was_free=<optimized out>, dirty=dirty@entry=0x7fffffffd438,
>> used=0x7fffffffd434, ino_discovery=1, check_dups=0,
>>     extra_attr_check=1, isa_dir=0x7fffffffd43c, parent=0x7fffffffd440)
>> at dinode.c:2936
>> #7  0x00005555555625cb in process_inode_chunk
>> (mp=mp@entry=0x7fffffffd930, agno=agno@entry=0,
>> first_irec=first_irec@entry=0x7fffe0005720,
>> ino_discovery=ino_discovery@entry=1, check_dups=check_dups@entry=0,
>> extra_attr_check=extra_attr_check@entry=1,
>>     bogus=0x7fffffffd4d4, num_inos=64) at incore.h:472
>> #8  0x000055555556394a in process_aginodes (mp=0x7fffffffd930,
>> pf_args=pf_args@entry=0x0, agno=agno@entry=0,
>> ino_discovery=ino_discovery@entry=1, check_dups=check_dups@entry=0,
>> extra_attr_check=extra_attr_check@entry=1) at dino_chunks.c:1031
>> #9  0x000055555556f62f in process_ag_func (wq=0x7fffffffd5d0, agno=0,
>> arg=0x0) at phase3.c:67
>> #10 0x000055555557cc0b in prefetch_ag_range (work=0x7fffffffd5d0,
>> start_ag=<optimized out>, end_ag=4, dirs_only=false,
>> func=0x55555556f5e0 <process_ag_func>) at prefetch.c:968
>> #11 0x000055555557e675 in do_inode_prefetch
>> (mp=mp@entry=0x7fffffffd930, stride=0, func=func@entry=0x55555556f5e0
>> <process_ag_func>, check_cache=check_cache@entry=false,
>> dirs_only=dirs_only@entry=false) at prefetch.c:1031
>> #12 0x000055555556f79b in process_ags (mp=0x7fffffffd930) at phase3.c:135
>> #13 phase3 (mp=0x7fffffffd930, scan_threads=32) at phase3.c:135
>> #14 0x000055555555a440 in main (argc=<optimized out>, argv=<optimized
>> out>) at xfs_repair.c:940
>>
>> Best regards
>> Anatoly
>>
> 
