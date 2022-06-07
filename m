Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA73AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 03:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiFGDUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 23:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiFGDUT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 23:20:19 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C251C56227
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 20:20:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654572015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/t46xjI0MIGrHW2L7sqHryo03TWnUDRmRVcno8yc4+4=;
        b=pX94oVU2nwyy7ok5dVnSrsM0gCnzVGiBGuTERiCyctZ17bOGqAAlIgu5qB8nF7rKleW222
        widsUponxNCnJOtXKhagvlOqkaSE25jHtQZl6EHHdD3Y2MuuyaklLNZT/Ip5xFISQ9jESW
        Z1mLBE5OeHwJdpLk/+CE3pPKjrWbZHU=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: xfs/148 fails with 5.19-rc1 kernel
To:     linux-xfs@vger.kernel.org
Message-ID: <f7de0b18-f10b-6b2e-65a2-3c7e1593b096@linux.dev>
Date:   Tue, 7 Jun 2022 11:20:12 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

The latest 5.19-rc1 kernel failed with xfs/148 test as follows, is it a 
known issue?

[root@localhost fstest]# ./check xfs/148
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 localhost 5.19.0-rc1-default #19 SMP 
PREEMPT_DYNAMIC Mon Jun 6 17:32:05 CST 2022
MKFS_OPTIONS  -- -f /dev/vde
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vde 
/mnt/scratch

xfs/148 - output mismatch (see /root/fstest/results//xfs/148.out.bad)
     --- tests/xfs/148.out       2021-06-07 17:24:30.000000000 +0800
     +++ /root/fstest/results//xfs/148.out.bad   2022-06-07 
11:05:34.016737438 +0800
     @@ -46,5 +46,5 @@
      attr_get: No data available
      Could not get "a_too_many" for TEST_DIR/mount-148/testfile
      ls: cannot access 'TEST_DIR/mount-148/testdir/f_are_bad/for_you': 
No such file or directory
     -Attribute "a_are_bad/for_you" had a 3 byte value for 
TEST_DIR/mount-148/testfile:
     -heh
     +attr_get: No data available
     +Could not get "a_are_bad/for_you" for TEST_DIR/mount-148/testfile
     ...
     (Run 'diff -u /root/fstest/tests/xfs/148.out 
/root/fstest/results//xfs/148.out.bad'  to see the entire diff)
Ran: xfs/148
Failures: xfs/148
Failed 1 of 1 tests

Also some calltraces appeared in dmesg.

[  356.595147] XFS (loop0): Corruption detected. Unmount and run xfs_repair
[  356.595150] XFS (loop0): Internal error 
!xfs_dir2_namecheck(sfep->name, sfep->namelen) at line 122 of file 
fs/xfs/xfs_dir2_readdir.c.  Caller 
xfs_dir2_sf_getdents.isra.8+0x1f1/0x280 [xfs]
[  356.595171] CPU: 3 PID: 6619 Comm: ls Kdump: loaded Tainted: 
G            E     5.19.0-rc1-default #19
[  356.595172] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[  356.595173] Call Trace:
[  356.595173]  <TASK>
[  356.595174]  dump_stack_lvl+0x44/0x57
[  356.595176]  xfs_corruption_error+0x92/0xa0 [xfs]
[  356.595196]  ? xfs_dir2_sf_getdents.isra.8+0x1f1/0x280 [xfs]
[  356.595224]  xfs_dir2_sf_getdents.isra.8+0x21c/0x280 [xfs]
[  356.595245]  ? xfs_dir2_sf_getdents.isra.8+0x1f1/0x280 [xfs]
[  356.595268]  xfs_readdir+0x1e3/0x250 [xfs]
[  356.595296]  iterate_dir+0x88/0x1b0
[  356.595301]  __x64_sys_getdents64+0x89/0x130
[  356.595302]  ? filldir+0x190/0x190
[  356.595307]  ? do_syscall_64+0x3a/0x80
[  356.595308]  ? __x64_sys_getdents+0x130/0x130
[  356.595309]  do_syscall_64+0x3a/0x80
[  356.595310]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  356.595311] RIP: 0033:0x7f7f286d4a2b
[  356.595312] Code: 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 
1e fa 48 81 fa ff ff ff 7f b8 ff ff ff 7f 48 0f 47 d0 b8 d9 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 4
8 8b 15 b9 c3 11 00 f7 d8
[  356.595313] RSP: 002b:00007ffea3c48da8 EFLAGS: 00000293 ORIG_RAX: 
00000000000000d9
[  356.595314] RAX: ffffffffffffffda RBX: 0000556710442650 RCX: 
00007f7f286d4a2b
[  356.595314] RDX: 0000000000008000 RSI: 0000556710442650 RDI: 
0000000000000003
[  356.595314] RBP: 0000556710442624 R08: 0000000000000003 R09: 
0000000000000078
[  356.595315] R10: 0000000000000000 R11: 0000000000000293 R12: 
fffffffffffffe98
[  356.595315] R13: 0000000000000000 R14: 0000556710442620 R15: 
0000556710442693
[  356.595323]  </TASK>
[  356.595324] XFS (loop0): Corruption detected. Unmount and run xfs_repair
[  356.600830] XFS (loop0): Internal error !xfs_attr_namecheck(name, 
namelen) at line 469 of file fs/xfs/xfs_attr_list.c.  Caller 
xfs_attr3_leaf_list_int+0x341/0x4d0 [xfs]
[  356.600871] CPU: 0 PID: 6620 Comm: attr Kdump: loaded Tainted: 
G            E     5.19.0-rc1-default #19
[  356.600873] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[  356.600874] Call Trace:
[  356.600874]  <TASK>
[  356.600875]  dump_stack_lvl+0x44/0x57
[  356.600879]  xfs_corruption_error+0x92/0xa0 [xfs]
[  356.600908]  ? xfs_attr3_leaf_list_int+0x341/0x4d0 [xfs]
[  356.600936]  xfs_attr3_leaf_list_int+0x36f/0x4d0 [xfs]
[  356.600960]  ? xfs_attr3_leaf_list_int+0x341/0x4d0 [xfs]
[  356.600990]  xfs_attr_leaf_list+0x61/0x140 [xfs]
[  356.601015]  xfs_attr_list+0x74/0x90 [xfs]
[  356.601040]  xfs_vn_listxattr+0x64/0xa0 [xfs]
[  356.601080]  ? __xfs_xattr_put_listent+0xb0/0xb0 [xfs]
[  356.601108]  listxattr+0x5b/0xf0
[  356.601113]  path_listxattr+0x5f/0xb0
[  356.601118]  do_syscall_64+0x3a/0x80
[  356.601120]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  356.601121] RIP: 0033:0x7f5fc790970b
[  356.601123] Code: f0 ff ff 73 01 c3 48 8b 0d 0a 77 0e 00 f7 d8 64 89 
01 48 83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 c3 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 76 0e 00 f7 d8 64 89 01 48
[  356.601124] RSP: 002b:00007ffe09e59368 EFLAGS: 00000202 ORIG_RAX: 
00000000000000c3
[  356.601125] RAX: ffffffffffffffda RBX: 00007ffe09e594c0 RCX: 
00007f5fc790970b
[  356.601126] RDX: 0000000000010000 RSI: 00007ffe09e594c0 RDI: 
00007ffe09e6bdd0
[  356.601127] RBP: 000000000000f000 R08: 00007ffe09e69540 R09: 
0000000000000078
[  356.601127] R10: 000000000000007d R11: 0000000000000202 R12: 
0000000000000001
[  356.601128] R13: 0000000000000001 R14: 00007ffe09e6bdd0 R15: 
0000000000000000
[  356.601138]  </TASK>


Thanks,
Guoqing
