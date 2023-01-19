Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99078C678D6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 01:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjASBbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjASBaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 20:30:39 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E915753571
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 17:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674091721; x=1705627721;
  h=message-id:date:mime-version:to:from:subject:
   content-transfer-encoding;
  bh=4N4pHc6VDV6nhGR+T4NviBi9axSwfnSkruwNG5dHjoo=;
  b=WPjSdGwN+pxgM+ucrXAcsyEgp5g2RD8l/lAMt2jQuxzexHmQt0bd97BO
   zSx5v76L50QupTpsbaOGwtllXeC/JFsuvKgk+Y0YX4WOhyHsvmixt4Ia6
   ynLhGKP+ZNi6XCR5naaG0k4tfCEJH13O6qMZAlxc6yoY8tlyMqBHWmGg6
   zMNTOnhqhVPrGGrCtPHwTZUxDYhq6qPAExe302zMXRhjtR/7cL5gXdYwe
   Me2CKVZmW27oo3bEeY5fPEGhN1sOlpfzw83UBgSJvRPFveMU9eRRxmW1H
   +SEW5IbfvUHjphJ9EFMXbWgPIAP6cj9+8fDER9edgc/DDn0Dkmnd6mZSY
   g==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669046400"; 
   d="scan'208";a="221012488"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2023 09:28:41 +0800
IronPort-SDR: Z9OuwwRse+GnKcyLWUg1Jq9t2hrtLXp2YM9111Q0jIePc+leHrX9m19V+urufrWT7Oz3oMphE8
 ZWYKe8GyO7dm4cd8M50wia98cZGafybp54at6+YaX37/a3/PJVq4Z5JdsfwWi9+923P502H0RS
 TQR9ceueOfY9fFwNPFYRLQ3PRLlOVR+2Gcz+wcY944d2thhibv4iNuLfTHshWdOlxQDQHf8BO2
 Of+RpIoovb1v3fwvt2UjatK25LRE25w33vfrm2hWZ0+6HI6Eq7zbCs2PsT4pJHkNorJFkqxrTM
 9/k=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jan 2023 16:46:20 -0800
IronPort-SDR: krF1yZ4HhBW+BkvIJbEPn8Psxbcre2WvMh+iitFqOPUzKYUnxcnAPNt9O+SE6lC7n/wMd1QA8O
 CTPIIsVexfbHs3nvYW8fLfbZhOVMmIFXNlM9J0rsyhb5Jy4HvVeh8zEwqOcJRE1TJToZzkADBt
 NvanHgju8XCvhtKIQxA2Sc4clQR6rnQIxE9VyKYZhpcUx1OvrZm+Jru/UxDYG0bLLyB/wQiMOf
 ZVLervygFJq/kMGXfTqAEFXrtLkfVb93lEd9UKwXCfmFign7jMOiretk97e8T0lj9UFfKPtX54
 ME4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jan 2023 17:28:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Ny4lY18WDz1RvTp
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 17:28:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :organization:subject:from:to:content-language:user-agent
        :mime-version:date:message-id; s=dkim; t=1674091720; x=
        1676683721; bh=4N4pHc6VDV6nhGR+T4NviBi9axSwfnSkruwNG5dHjoo=; b=U
        EVY+sHYn3QpSGfUW+5Mp8TJjgDuRaI45IEZ841lgakt3C1HPm5OU8jnVI34HGLFU
        avEPvLcHeDVvLbL8PSMutOJcSWRdXxuYmQCCS0AmX16QvqAyxnxM95ADo9HXBoJs
        pUhe+DxXIZh+MG0GQ6oBpaQgt5/816rTOFN9emoDQV41onOV1ylxwJB9I4IlMFB+
        HnQ7ifL3irkCU52cDYo4fo474Dn+msDd/UsqmtJJpFHdFmsoDC7gato8P6AZdmja
        DGiddjgUbV30dcKUCjnhynaT8/x0jZqNkn68ei2qbpwP9uGJ5eyYKhAADtRH0xG5
        b09wChwwaPpZutnxBo7lA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3cLOPlDkcMJe for <linux-xfs@vger.kernel.org>;
        Wed, 18 Jan 2023 17:28:40 -0800 (PST)
Received: from [10.89.84.31] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.84.31])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Ny4lX1h0mz1RvLy;
        Wed, 18 Jan 2023 17:28:40 -0800 (PST)
Message-ID: <f9ff999a-e170-b66b-7caf-293f2b147ac2@opensource.wdc.com>
Date:   Thu, 19 Jan 2023 10:28:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Content-Language: en-US
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Lockdep splat with xfs
Organization: Western Digital Research
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I got the below kasan splat running on 6.2-rc3.

The machine is currently running some SMR & CMR drives benchmarks and xfs is
used only for the rootfs (on an m.2 ssd) to log test results. So nothing special
really exercising xfs.

My tests are still running (they take several days so I do not want to interrupt
them) so I have not tried the latest Linus tree. Have you got reports of
something similar ? Is that fixed already ? I did not dig into the issue :)


======================================================
WARNING: possible circular locking dependency detected
6.2.0-rc3+ #1637 Not tainted
------------------------------------------------------
kswapd0/177 is trying to acquire lock:
ffff8881fe452118 (&xfs_dir_ilock_class){++++}-{3:3}, at:
xfs_icwalk_ag+0x9d8/0x11f0 [xfs]

but task is already holding lock:
ffffffff83b5d280 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x760/0xf90

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       fs_reclaim_acquire+0x122/0x170
       __alloc_pages+0x1b3/0x690
       __stack_depot_save+0x3b4/0x4b0
       kasan_save_stack+0x32/0x40
       kasan_set_track+0x25/0x30
       __kasan_kmalloc+0x88/0x90
       __kmalloc_node+0x5a/0xc0
       xfs_attr_copy_value+0xf2/0x170 [xfs]
       xfs_attr_get+0x36a/0x4b0 [xfs]
       xfs_get_acl+0x1a5/0x3f0 [xfs]
       __get_acl.part.0+0x1d5/0x2e0
       vfs_get_acl+0x11b/0x1a0
       do_get_acl+0x39/0x520
       do_getxattr+0xcb/0x330
       getxattr+0xde/0x140
       path_getxattr+0xc1/0x140
       do_syscall_64+0x38/0x80
       entry_SYSCALL_64_after_hwframe+0x46/0xb0

-> #0 (&xfs_dir_ilock_class){++++}-{3:3}:
       __lock_acquire+0x2b91/0x69e0
       lock_acquire+0x1a3/0x520
       down_write_nested+0x9c/0x240
       xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
       xfs_icwalk+0x4c/0xd0 [xfs]
       xfs_reclaim_inodes_nr+0x148/0x1f0 [xfs]
       super_cache_scan+0x3a5/0x500
       do_shrink_slab+0x324/0x900
       shrink_slab+0x376/0x4f0
       shrink_node+0x80f/0x1ae0
       balance_pgdat+0x6e2/0xf90
       kswapd+0x312/0x9b0
       kthread+0x29f/0x340
       ret_from_fork+0x1f/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_dir_ilock_class);
                               lock(fs_reclaim);
  lock(&xfs_dir_ilock_class);

 *** DEADLOCK ***

3 locks held by kswapd0/177:
 #0: ffffffff83b5d280 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x760/0xf90
 #1: ffffffff83b2b8b0 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x237/0x4f0
 #2: ffff8881a73cc0e0 (&type->s_umount_key#36){++++}-{3:3}, at:
super_cache_scan+0x58/0x500

stack backtrace:
CPU: 16 PID: 177 Comm: kswapd0 Not tainted 6.2.0-rc3+ #1637
Hardware name: Supermicro AS -2014CS-TR/H12SSW-AN6, BIOS 2.4 02/23/2022
Call Trace:
 <TASK>
 dump_stack_lvl+0x50/0x63
 check_noncircular+0x268/0x310
 ? print_circular_bug+0x440/0x440
 ? check_path.constprop.0+0x24/0x50
 ? save_trace+0x46/0xd00
 ? add_lock_to_list+0x188/0x5a0
 __lock_acquire+0x2b91/0x69e0
 ? lockdep_hardirqs_on_prepare+0x410/0x410
 lock_acquire+0x1a3/0x520
 ? xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
 ? lock_downgrade+0x6d0/0x6d0
 ? lock_is_held_type+0xdc/0x130
 down_write_nested+0x9c/0x240
 ? xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
 ? up_read+0x30/0x30
 ? xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
 ? rcu_read_lock_sched_held+0x3f/0x70
 ? xfs_ilock+0x252/0x2f0 [xfs]
 xfs_icwalk_ag+0x9d8/0x11f0 [xfs]
 ? xfs_inode_free_cowblocks+0x1f0/0x1f0 [xfs]
 ? lock_is_held_type+0xdc/0x130
 ? find_held_lock+0x2d/0x110
 ? xfs_perag_get+0x2c0/0x2c0 [xfs]
 ? rwlock_bug.part.0+0x90/0x90
 xfs_icwalk+0x4c/0xd0 [xfs]
 xfs_reclaim_inodes_nr+0x148/0x1f0 [xfs]
 ? xfs_reclaim_inodes+0x1f0/0x1f0 [xfs]
 super_cache_scan+0x3a5/0x500
 do_shrink_slab+0x324/0x900
 shrink_slab+0x376/0x4f0
 ? set_shrinker_bit+0x230/0x230
 ? mem_cgroup_calculate_protection+0x4a/0x4e0
 shrink_node+0x80f/0x1ae0
 balance_pgdat+0x6e2/0xf90
 ? finish_task_switch.isra.0+0x218/0x920
 ? shrink_node+0x1ae0/0x1ae0
 ? lock_is_held_type+0xdc/0x130
 kswapd+0x312/0x9b0
 ? balance_pgdat+0xf90/0xf90
 ? prepare_to_swait_exclusive+0x250/0x250
 ? __kthread_parkme+0xc1/0x1f0
 ? schedule+0x151/0x230
 ? balance_pgdat+0xf90/0xf90
 kthread+0x29f/0x340
 ? kthread_complete_and_exit+0x30/0x30
 ret_from_fork+0x1f/0x30
 </TASK>


-- 
Damien Le Moal
Western Digital Research
