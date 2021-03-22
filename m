Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEA1C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 18:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A832E619AA
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 18:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhCVSyk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhCVSyO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 14:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A764B61992;
        Mon, 22 Mar 2021 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616439253;
        bh=PQ4fnTT9Xwwd/fEE28w2aF8qxLJCzqFxd9Adms//rFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nsG0+SeG5kL9llfk8AxHwKhxlWMqM9ceT0yHXkNrk88jny6BJkr937Zf7msZOXkDy
         xo0ZHCdvjoVHtt6ruthBzrDQdMKAqLrXWtSXcc69FRcTx8Zno81/mYwAoxdsGH81ka
         BRvOJOwPYczykNDMjHqBg1O8wHvMl/GzmS/dU7N01YFF8G1LIW12M3dM5ahqUF92Qr
         eJKcFj/ccvsiPEf9+T1HDI2TcyrLBTMweBKqH8nSImlHp8sj7stvl7RmTvXuvsBR8f
         iNZJoQ+PJ6gMZmEJ8Rq02pc6cXlscpXWD7DvP5ZfXA3mFqnDxanWnu4YbnGxJxGWhH
         77H3zWO7iHiGw==
Date:   Mon, 22 Mar 2021 11:54:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent
 error tag enabled
Message-ID: <20210322185413.GH1670408@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-14-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309050124.23797-14-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:31:24AM +0530, Chandan Babu R wrote:
> This commit adds a stress test that executes fsstress with
> bmap_alloc_minlen_extent error tag enabled.

Continuing along the theme of watching the magic smoke come out when dir
block size > fs block size, I also observed the following assertion when
running this test:

 XFS: Assertion failed: done, file: fs/xfs/libxfs/xfs_dir2.c, line: 687
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 3892 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
 Modules linked in: xfs(O) libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
 CPU: 0 PID: 3892 Comm: fsstress Tainted: G           O      5.12.0-rc4-xfsx #rc4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 RIP: 0010:assfail+0x3c/0x40 [xfs]
 Code: d0 d5 41 a0 e8 81 f9 ff ff 8a 1d 5b 44 0e 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 b0 d5 4d a0 e8 93 dc fc e0 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
 RSP: 0018:ffffc900035bba38 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff88804f204100 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa040c157
 RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
 R10: 000000000000000a R11: f000000000000000 R12: ffff88805920b880
 R13: ffff888003778bb0 R14: 0000000000000000 R15: ffff88800f0f63c0
 FS:  00007fe7b5e2f740(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fe7b6055000 CR3: 0000000053094005 CR4: 00000000001706b0
 Call Trace:
  xfs_dir2_shrink_inode+0x22f/0x270 [xfs]
  xfs_dir2_block_to_sf+0x29a/0x420 [xfs]
  xfs_dir2_block_removename+0x221/0x290 [xfs]
  xfs_dir_removename+0x1a0/0x220 [xfs]
  xfs_dir_rename+0x343/0x3b0 [xfs]
  xfs_rename+0x79e/0xae0 [xfs]
  xfs_vn_rename+0xdb/0x150 [xfs]
  vfs_rename+0x4e2/0x8e0
  do_renameat2+0x393/0x550
  __x64_sys_rename+0x40/0x50
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fe7b5e9800b
 Code: e8 aa ce 0a 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5d c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5d c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 51 4e 18 00 f7 d8
 RSP: 002b:00007ffeb526c698 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
 RAX: ffffffffffffffda RBX: 00007ffeb526c970 RCX: 00007fe7b5e9800b
 RDX: 0000000000000000 RSI: 000055d6ccdb9250 RDI: 000055d6ccdb9270
 RBP: 00007ffeb526c980 R08: 0000000000000001 R09: 0000000000000003
 R10: 000055d6cc3b20dc R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000040 R14: 00007ffeb526c970 R15: 00007ffeb526c980
 ---[ end trace 98f99784621d65fe ]---

It looks to me as though we return from xfs_bunmapi having not completed
all the unmapping work, though I can't tell if that's because bunmapi
returned early because it thought it would overflow the extent count; or
some other reason.

OH CRAP, I just realized that xfs_dir2_shrink_inode only calls
xfs_bunmapi once, which means that if the directory block it's removing
is a multi-fsb block, it will remove the last extent map.  It then trips
the assertion, having left the rest of the directory block still mapped.

This is also what's going on when xfs_inactive_symlink_rmt trips the
same ASSERT(done), because the symlink remote block can span multiple
(two?) fs blocks but we only ever call xfs_bunmapi once.

So, no, there's nothing wrong with this test, but it _did_ shake loose
a couple of XFS bugs.  Congratulations!

So... who wants to tackle this one?  This isn't trivial to clean up
because you'll have to clean up all callers of xfs_dir2_shrink_inode to
handle rolling of the transaction, and I bet the only way to fix this is
to use deferred bunmap items to make sure the unmap always completes.

--D

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/537     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/537.out |  7 ++++
>  tests/xfs/group   |  1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/537
>  create mode 100644 tests/xfs/537.out
> 
> diff --git a/tests/xfs/537 b/tests/xfs/537
> new file mode 100755
> index 00000000..77fa60d9
> --- /dev/null
> +++ b/tests/xfs/537
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 537
> +#
> +# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/inject
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
> +
> +echo "Create fragmented filesystem"
> +for dentry in $(ls -1 $fillerdir/); do
> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +done
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Scale fsstress args"
> +args=$(_scale_fsstress_args -p $((LOAD_FACTOR * 75)) -n $((TIME_FACTOR * 1000)))
> +
> +echo "Execute fsstress in background"
> +$FSSTRESS_PROG -d $SCRATCH_MNT $args \
> +		 -f bulkstat=0 \
> +		 -f bulkstat1=0 \
> +		 -f fiemap=0 \
> +		 -f getattr=0 \
> +		 -f getdents=0 \
> +		 -f getfattr=0 \
> +		 -f listfattr=0 \
> +		 -f mread=0 \
> +		 -f read=0 \
> +		 -f readlink=0 \
> +		 -f readv=0 \
> +		 -f stat=0 \
> +		 -f aread=0 \
> +		 -f dread=0 > /dev/null 2>&1
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/537.out b/tests/xfs/537.out
> new file mode 100644
> index 00000000..19633a07
> --- /dev/null
> +++ b/tests/xfs/537.out
> @@ -0,0 +1,7 @@
> +QA output created by 537
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Scale fsstress args
> +Execute fsstress in background
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ba674a58..5c827727 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -534,3 +534,4 @@
>  534 auto quick reflink
>  535 auto quick reflink
>  536 auto quick
> +537 auto stress
> -- 
> 2.29.2
> 
