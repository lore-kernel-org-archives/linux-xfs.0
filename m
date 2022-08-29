Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D958FECAAD2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 14:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiH2Orc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 10:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiH2Orc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 10:47:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F83F24096
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 07:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5F1EB810A0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 14:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EB0C433D6;
        Mon, 29 Aug 2022 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661784448;
        bh=TgoWD/8El0oINbR3H9Mui86GP647OVzDYiFMYPiLQpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENP368fyvtg1K3QFUFpdqsCUc3he3RdfgwGuC2GLYUn037Rp+oYrqrKuKu6IaPqE2
         +p4xVUTuleEOGZeugNc5A64UPOfgQJKJjEGbsfNUqsQZ/ZMI0z/AlUuv73OUghYz0j
         79+ZCmnyN2x6KAHMK/IfD6oXqPFZrOEaDGohK2CZn5cOww27QxvuNW+hU+30LKN90E
         Sr2MREAUtNEM05CQeheNS5yI/Bi+f3mEw0df+bCqN2Oo93GT2ofY9ZYa6+b4J26oPW
         /ctxYhHPO8NRSkQnNWQIBkL1mi1LqkcqnoOGz8gT2GGyAU9SbaPUvcRBUvZf/3FWDU
         IemssD1dKWM1A==
Date:   Mon, 29 Aug 2022 07:47:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH] xfs: fix uaf when leaf dir bestcount not match with dir
 data blocks
Message-ID: <YwzRfzv7O67GeIwJ@magnolia>
References: <20220829070212.2540615-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829070212.2540615-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 29, 2022 at 03:02:12PM +0800, Guo Xuenan wrote:
> For leaf dir, there should be as many bestfree slots as there are dir data
> blocks that can fit under i_size. Othrewise, which may cause UAF or
> slab-out-of bound etc.
> 
> Root cause is we don't examin the number bestfree slots, when the slots
> number less than dir data blocks, if we need to allocate new dir data block
> and update the bestfree array, we will use the dir block number as index to
> assign bestfree array, which may cause UAF or other memory access problem.
> This issue can also triggered with test cases xfs/473 from fstests.
> 
> Simplify the testcase xfs/473 with commands below:
> DEV=/dev/sdb
> MP=/mnt/sdb
> WORKDIR=/mnt/sdb/341 #1. mkfs create new xfs image
> mkfs.xfs -f ${DEV}
> mount ${DEV} ${MP}
> mkdir -p ${WORKDIR}
> for i in `seq 1 341` #2. create leaf dir with 341 entries file name len 8
> do
>     touch ${WORKDIR}/$(printf "%08d" ${i})
> done
> inode=$(ls -i ${MP} | cut -d' ' -f1)
> umount ${MP}         #3. xfs_db set bestcount to 0
> xfs_db -x ${DEV} -c "inode ${inode}" -c "dblock 8388608" \
> -c "write ltail.bestcount 0"
> mount ${DEV} ${MP}
> touch ${WORKDIR}/{1..100}.txt #4. touch new file, reproduce
> 
> The error log is shown as follows:
> ==================================================================
> BUG: KASAN: use-after-free in xfs_dir2_leaf_addname+0x1995/0x1ac0
> Write of size 2 at addr ffff88810168b000 by task touch/1552
> CPU: 5 PID: 1552 Comm: touch Not tainted 6.0.0-rc3+ #101
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4d/0x66
>  print_report.cold+0xf6/0x691
>  kasan_report+0xa8/0x120
>  xfs_dir2_leaf_addname+0x1995/0x1ac0
>  xfs_dir_createname+0x58c/0x7f0
>  xfs_create+0x7af/0x1010
>  xfs_generic_create+0x270/0x5e0
>  path_openat+0x270b/0x3450
>  do_filp_open+0x1cf/0x2b0
>  do_sys_openat2+0x46b/0x7a0
>  do_sys_open+0xb7/0x130
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fe4d9e9312b
> Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
> 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
> f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
> RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
> RDX: 0000000000000941 RSI: 00007ffda4c17f33 RDI: 00000000ffffff9c
> RBP: 00007ffda4c17f33 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
> R13: 00007fe4d9f631a4 R14: 00007ffda4c17f33 R15: 0000000000000000
>  </TASK>
> 
> The buggy address belongs to the physical page:
> page:ffffea000405a2c0 refcount:0 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x10168b
> flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
> raw: 002fffff80000000 ffffea0004057788 ffffea000402dbc8 0000000000000000
> raw: 0000000000000000 0000000000170000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88810168af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88810168af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88810168b000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                    ^
>  ffff88810168b080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff88810168b100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
> Disabling lock debugging due to kernel taint
> 00000000: 58 44 44 33 5b 53 35 c2 00 00 00 00 00 00 00 78
> XDD3[S5........x
> XFS (sdb): Internal error xfs_dir2_data_use_free at line 1200 of file
> fs/xfs/libxfs/xfs_dir2_data.c.  Caller
> xfs_dir2_data_use_free+0x28a/0xeb0
> CPU: 5 PID: 1552 Comm: touch Tainted: G    B              6.0.0-rc3+
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4d/0x66
>  xfs_corruption_error+0x132/0x150
>  xfs_dir2_data_use_free+0x198/0xeb0
>  xfs_dir2_leaf_addname+0xa59/0x1ac0
>  xfs_dir_createname+0x58c/0x7f0
>  xfs_create+0x7af/0x1010
>  xfs_generic_create+0x270/0x5e0
>  path_openat+0x270b/0x3450
>  do_filp_open+0x1cf/0x2b0
>  do_sys_openat2+0x46b/0x7a0
>  do_sys_open+0xb7/0x130
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fe4d9e9312b
> Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
> 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
> f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
> RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
> RDX: 0000000000000941 RSI: 00007ffda4c17f46 RDI: 00000000ffffff9c
> RBP: 00007ffda4c17f46 R08: 0000000000000000 R09: 0000000000000001
> R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
> R13: 00007fe4d9f631a4 R14: 00007ffda4c17f46 R15: 0000000000000000
>  </TASK>
> XFS (sdb): Corruption detected. Unmount and run xfs_repair
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d9b66306a9a7..09414651ac48 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -659,6 +659,20 @@ xfs_dir2_leaf_addname(
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
>  	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
>  
> +	/*
> +	 * There should be as many bestfree slots as there are dir data
> +	 * blocks that can fit under i_size. Othrewise, which may cause

Typo: "Otherwise..."

> +	 * serious problems eg. UAF or slab-out-of bound etc.

What about commit e5d1802c70f5 ("xfs: fix a bug in the online fsck
directory leaf1 bestcount check")?  Online fsck used to have this check
in it, until I discovered that the kernel actually /can/ remove blocks
from the end of the data section of a directory and forget to decrease
i_disk_size.  xfs_repair hasn't ever complained about that, which means
it's part of the disk format.

> +	 */
> +	if (be32_to_cpu(ltp->bestcount) !=
> +			xfs_dir2_byte_to_db(args->geo, dp->i_d.di_size)) {

What is i_d.di_size?  We changed that to i_disk_size ages ago...

--D

> +		xfs_buf_ioerror_alert(lbp, __return_address);
> +		if (tp->t_flags & XFS_TRANS_DIRTY)
> +			xfs_force_shutdown(tp->t_mountp,
> +				SHUTDOWN_CORRUPT_INCORE);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/*
>  	 * See if there are any entries with the same hash value
>  	 * and space in their block for the new entry.
> -- 
> 2.25.1
> 
