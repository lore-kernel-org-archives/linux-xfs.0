Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E665C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 11:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6EE20855
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 11:22:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZyOpTMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgHTLWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:22:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730413AbgHTLVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 07:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597922490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PWEeo5kHocG15wCFsx0YqvaNv6ZN4K2dk9uYSUt2wQA=;
        b=JZyOpTMZh1yal+oXwSJwwelQPOCFFdIlANm6afRGaqqnQBpaC24QKY4zxtImHET309y9m6
        lsJaaQQkCP0oG7IqVlJigrNuYy0Kw5IbOncIplkzdVnxS8tB2mUqMRnwRtm0SGxsAe2wrC
        CQUK9YtHoIgWvID4wiQLXjK3H6R6QU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-cW_Vme6QN1S7njM_m80eSg-1; Thu, 20 Aug 2020 07:21:26 -0400
X-MC-Unique: cW_Vme6QN1S7njM_m80eSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B89D610052ED;
        Thu, 20 Aug 2020 11:21:25 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E17E7A40D;
        Thu, 20 Aug 2020 11:21:25 +0000 (UTC)
Date:   Thu, 20 Aug 2020 07:21:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: occasional failures in generic/455 and generic/457
Message-ID: <20200820112123.GA179505@bfoster>
References: <20200819164254.GG17456@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819164254.GG17456@casper.infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 05:42:54PM +0100, Matthew Wilcox wrote:
> This is with 5.8.0-rc1 plus the series of seven patches to modify how
> pagevec_lookup_entries + find_get_entries() work [1].  I think it's unlikely
> those patches caused this, but it's sporadic so I can't be sure.
> 
> This one is from generic/457 but I've seen something similar from
> generic/455.  I'm using the following:
> +    echo 'MKFS_OPTIONS="-m reflink=1,rmapbt=1 -i sparse=1 -b size=1024"' >> /ktest/tests/xfstests/local.config
> +    mkfs.$FSTYP -q $TEST_DEV -m reflink=1,rmapbt=1 -i sparse=1 -b size=1024
> 
> [1] https://lore.kernel.org/linux-mm/20200819150555.31669-1-willy@infradead.org/T/
> 
> 6946 XFS (sdc): Internal error ltrec.rm_startblock > bno || ltrec.rm_startblock + ltrec.rm_blockcount < bno + len at line 575 of file fs/xfs/libxfs/xfs_rmap.c.  Caller xfs_rmap_unmap+0x5fc/0x900
> 6946 CPU: 2 PID: 13591 Comm: mount Kdump: loaded Tainted: G        W         5.9.0-rc1-00007-g96650d19d84b #452
> 6946 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014

This looks similar to rmapbt related failures I saw with generic/455 and
addressed with the following patch:

  https://lore.kernel.org/linux-xfs/20200713202151.64750-1-bfoster@redhat.com/

Care to give that a whirl?

Brian

> 6946 Call Trace:
> 6946  dump_stack+0x5e/0x7a
> 6946  xfs_corruption_error+0x7c/0x80
> 6946  ? xfs_rmap_unmap+0x5fc/0x900
> 6946  xfs_rmap_unmap+0x626/0x900
> 6946  ? xfs_rmap_unmap+0x5fc/0x900
> 6946  ? xfs_free_extent_fix_freelist+0x81/0xc0
> 6946  ? xfs_rmapbt_init_cursor+0x31/0x90
> 6946  xfs_rmap_finish_one+0x1dd/0x330
> 6946  xfs_rmap_update_finish_item+0x3f/0x70
> 6946  xfs_defer_finish_noroll+0x153/0x400
> 6946  ? kmem_alloc+0x74/0x120
> 6946  ? xfs_trans_commit+0xb/0x10
> 6946  __xfs_trans_commit+0x138/0x340
> 6946  xfs_trans_commit+0xb/0x10
> 6946  xfs_refcount_recover_cow_leftovers+0x1b9/0x300
> 6946  xfs_reflink_recover_cow+0x36/0x50
> 6946  xfs_mountfs+0x5a4/0x910
> 6946  xfs_fc_fill_super+0x34c/0x560
> 6946  get_tree_bdev+0x169/0x260
> 6946  ? xfs_setup_devices+0x80/0x80
> 6946  xfs_fc_get_tree+0x10/0x20
> 6946  vfs_get_tree+0x19/0x80
> 6946  path_mount+0x6ba/0x9f0
> 6946  __x64_sys_mount+0xe5/0x120
> 6946  do_syscall_64+0x32/0x50
> 6946  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 6946 RIP: 0033:0x7fa229f96fea
> 6946 Code: 48 8b 0d a9 0e 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 76 0e 0c 00 f7 d8 64 89 01 48
> 6946 RSP: 002b:00007ffcb19cf128 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> 6946 RAX: ffffffffffffffda RBX: 000055eb7a037970 RCX: 00007fa229f96fea
> 6946 RDX: 000055eb7a037b80 RSI: 000055eb7a037bc0 RDI: 000055eb7a037ba0
> 6946 RBP: 00007fa22a2e41c4 R08: 0000000000000000 R09: 000055eb7a03a890
> 6946 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> 6946 R13: 0000000000000000 R14: 000055eb7a037ba0 R15: 000055eb7a037b80
> 6946 XFS (sdc): Corruption detected. Unmount and run xfs_repair
> 6946 XFS (sdc): xfs_do_force_shutdown(0x8) called from line 450 of file fs/xfs/libxfs/xfs_defer.c. Return address = ffffffff812ee23b
> 6946 XFS (sdc): Corruption of in-memory data detected.  Shutting down filesystem
> 6946 XFS (sdc): Please unmount the filesystem and rectify the problem(s)
> 6946 XFS (sdc): Error -117 recovering leftover CoW allocations.
> 6946 [failed, exit status 1]XFS (sdb): Unmounting Filesystem
> 
> 

