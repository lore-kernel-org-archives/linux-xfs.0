Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B558ECAAD2
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Aug 2022 04:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiH0Eue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 Aug 2022 00:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiH0Eud (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Aug 2022 00:50:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D37C7BB4
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 21:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B558CB83372
        for <linux-xfs@vger.kernel.org>; Sat, 27 Aug 2022 04:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60D39C43142
        for <linux-xfs@vger.kernel.org>; Sat, 27 Aug 2022 04:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661575828;
        bh=OftjCy+JlR1+GKJCdzXbsOSxdeg1bIBwDpvLQP4YXMs=;
        h=From:To:Subject:Date:From;
        b=tMNYdYuEdn25nQ++JgkZzWDnj7aTsK/AoBnhvSAPW7gw5VQ5KSXiN2xIVT/hTSlQS
         6daHGXPjplJv9RsXR4P5o9jS2N3Q5+I4AOGzrCuJAFp+vzNLpQ9xIGyWfxGqDy8Cj9
         NACZnVNptk1kC11rB4F3paOV8oUTDUWDWcJENuq/NOqydGVhuhv65OFkl1GJvqtubW
         6V+Zfg+qaphRPjtOQiQlMSrk8nbeBw6WhsFQAMLk/qw3+CfjbsVeDY9fNDEJ36QO/1
         uMIsxYqeO7jkQyq9d/oLdpg4ZWDV0Mt2Op0hrkZqvg4ZENE+AAk33zEOOzUd9njF9E
         CegmPBJons3oA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 516B8C433E9; Sat, 27 Aug 2022 04:50:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216419] New: Internal error XFS_WANT_CORRUPTED_RETURN at line
 442 of file fs/xfs/libxfs/xfs_alloc.c
Date:   Sat, 27 Aug 2022 04:50:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sunjunchao2870@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216419-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216419

            Bug ID: 216419
           Summary: Internal error XFS_WANT_CORRUPTED_RETURN at line 442
                    of file fs/xfs/libxfs/xfs_alloc.c
           Product: File System
           Version: 2.5
    Kernel Version: 5.3.18
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: sunjunchao2870@gmail.com
        Regression: No

Created attachment 301678
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301678&action=3Dedit
messages about corrupted xfs

Recently I ran pressure test on xfs(almost 1.5GB/s bandwidth on write) and I
discovered a lot of error logs about xfs, just like:
Aug 21 20:31:20 rg21-oss005 kernel: XFS (bcache4): metadata I/O error in
"xfs_trans_read_buf_map" at daddr 0x8804a66e8 len 8 error 74
Aug 21 20:31:20 rg21-oss005 kernel: XFS (bcache4): Metadata CRC error detec=
ted
at xfs_dir3_block_read_verify+0xbf/0xe0 [xfs], xfs_dir3_block block 0x8804a=
66e8=20
Aug 21 20:31:20 rg21-oss005 kernel: XFS (bcache4): Unmount and run xfs_repa=
ir
Aug 21 20:31:20 rg21-oss005 kernel: XFS (bcache4): First 128 bytes of corru=
pted
metadata buffer:
Aug 21 20:31:20 rg21-oss005 kernel: 00000000: 38 30 30 2e 30 2c 20 38 30 30=
 2e
30 2c 20 38 30  800.0, 800.0, 80
Aug 21 20:31:20 rg21-oss005 kernel: 00000010: 30 2e 30 2c 20 31 34 34 30 2e=
 30
2c 20 31 34 34  0.0, 1440.0, 144
Aug 21 20:31:20 rg21-oss005 kernel: 00000020: 30 2e 30 2c 20 32 30 32 39 2e=
 39
33 37 35 2c 20  0.0, 2029.9375,=20
Aug 21 20:31:20 rg21-oss005 kernel: 00000030: 32 30 32 39 2e 39 33 37 35 2c=
 20
32 30 32 39 2e  2029.9375, 2029.
Aug 21 20:31:20 rg21-oss005 kernel: 00000040: 39 33 37 35 2c 20 32 30 32 39=
 2e
39 33 37 35 5d  9375, 2029.9375]
Aug 21 20:31:20 rg21-oss005 kernel: 00000050: 2c 20 22 65 6c 61 70 73 65 64=
 22
3a 20 5b 31 34  , "elapsed": [14
Aug 21 20:31:20 rg21-oss005 kernel: 00000060: 36 35 2e 31 30 35 31 30 34 34=
 34
36 34 31 31 31  65.1051044464111
Aug 21 20:31:20 rg21-oss005 kernel: 00000070: 2c 20 31 34 36 37 2e 34 37 33=
 33
31 36 31 39 32  , 1467.473316192
Aug 21 20:31:20 rg21-oss005 kernel: XFS (bcache4): metadata I/O error in
"xfs_trans_read_buf_map" at daddr 0x8804a66e8 len 8 error 74

and=20

Aug 21 22:41:37 rg21-oss005 kernel: XFS (bcache4): Internal error
XFS_WANT_CORRUPTED_RETURN at line 442 of file fs/xfs/libxfs/xfs_alloc.c.=20
Caller xfs_alloc_ag_vextent_near+0x7f6/0xb60 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: CPU: 23 PID: 10127 Comm: w16-5 Kdump:
loaded Tainted: G           OE     N 5.3.18.20211010 #4 SLE15-SP2 (unreleas=
ed)
Aug 21 22:41:37 rg21-oss005 kernel: Hardware name: New H3C Technologies Co.,
Ltd. UniServer R4300 G3/RS01M2C7S, BIOS 2.00.56 12/17/2021
Aug 21 22:41:37 rg21-oss005 kernel: Call Trace:
Aug 21 22:41:37 rg21-oss005 kernel: dump_stack+0x64/0x83
Aug 21 22:41:37 rg21-oss005 kernel: xfs_alloc_fixup_trees+0x211/0x350 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_alloc_ag_vextent_near+0x7f6/0xb60 [=
xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_alloc_ag_vextent+0x13c/0x150 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_alloc_vextent+0x41f/0x5a0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_bmap_btalloc+0x23c/0x8e0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_bmapi_allocate+0x10c/0x2e0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_bmapi_convert_delalloc+0x267/0x4a0
[xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_map_blocks+0x195/0x3f0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_do_writepage+0x127/0x3c0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: write_cache_pages+0x1d3/0x410
Aug 21 22:41:37 rg21-oss005 kernel: ? xfs_vm_writepages+0xa0/0xa0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: ? pagevec_lookup_entries+0x1a/0x30
Aug 21 22:41:37 rg21-oss005 kernel: xfs_vm_writepages+0x64/0xa0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: do_writepages+0x1a/0x70
Aug 21 22:41:37 rg21-oss005 kernel: __filemap_fdatawrite_range+0xcf/0x100
Aug 21 22:41:37 rg21-oss005 kernel: filemap_write_and_wait_range+0x41/0xa0
Aug 21 22:41:37 rg21-oss005 kernel: xfs_setattr_size+0x10d/0x390 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: xfs_vn_setattr+0x6e/0xc0 [xfs]
Aug 21 22:41:37 rg21-oss005 kernel: notify_change+0x26c/0x450
Aug 21 22:41:37 rg21-oss005 kernel: do_truncate+0x72/0xc0
Aug 21 22:41:37 rg21-oss005 kernel: do_sys_ftruncate+0x10c/0x120
Aug 21 22:41:37 rg21-oss005 kernel: do_syscall_64+0x5b/0x1f0
Aug 21 22:41:37 rg21-oss005 kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
Aug 21 22:41:37 rg21-oss005 kernel: RIP: 0033:0x7fb5168a86e7
Aug 21 22:41:37 rg21-oss005 kernel: Code: 73 01 c3 48 8b 0d 89 f7 2c 00 f7 =
d8
64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 4d =
00
00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 59 f7 2c 00 f7 d8 64 89 0=
1 48
Aug 21 22:41:37 rg21-oss005 kernel: RSP: 002b:00007fb237bfb498 EFLAGS: 0000=
0206
ORIG_RAX: 000000000000004d
Aug 21 22:41:37 rg21-oss005 kernel: RAX: ffffffffffffffda RBX: 00007fb22000=
38c0
RCX: 00007fb5168a86e7
Aug 21 22:41:37 rg21-oss005 kernel: RDX: 00000000000000e0 RSI: 000000000230=
0000
RDI: 0000000000000074
Aug 21 22:41:37 rg21-oss005 kernel: RBP: 00007fb237bfc6b0 R08: 00007fb2360f=
6050
R09: 0000000000004000
Aug 21 22:41:37 rg21-oss005 kernel: R10: 00000000022e4000 R11: 000000000000=
0206
R12: 0000000000100000
Aug 21 22:41:37 rg21-oss005 kernel: R13: 0000000000001000 R14: 000000000000=
0074
R15: 00007fb237bfb680
Aug 21 22:41:37 rg21-oss005 kernel: XFS (bcache4): page discard on page
00000000d976f7c9, inode 0x400079d77, offset 28315648.
Aug 21 22:41:37 rg21-oss005 kernel: XFS (bcache4): writeback error on sector
42005378320



It seems xfs corrupted, and I repaired that by xfs_repair. But after one da=
y, I
got some similar questions and xfs corrupted again and again. Is this a kno=
wn
issue? Or am I wrong in something? Please let me known if any information is
missed. Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
