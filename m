Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B75C2BB54
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 13:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CB7320731
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 13:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SsGvHmsh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgDGNS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 09:18:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50869 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728555AbgDGNS3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 09:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586265508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+RMSI9kPqFya8/cfaNshKhcO7okNF4uFUANz+MtU//I=;
        b=SsGvHmshZtc1Mxnq7mPoxL2TgGyt+CBv5wNiVCQWDy7xpMx1DBlSV0V0Cp3FSQjGF8yybu
        pIZHeazdifHngeL2MApXF+A9/DeErgxKqFMoHIwl2Xu6Rw6aoGbxAyMeh1aarhdXkT396G
        wWdVIYKaW6hJAFVWvnfojQDhKXodHmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-kabcZO-eNjOILBndzq2cOw-1; Tue, 07 Apr 2020 09:18:16 -0400
X-MC-Unique: kabcZO-eNjOILBndzq2cOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 237181005513;
        Tue,  7 Apr 2020 13:18:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8F655C1BB;
        Tue,  7 Apr 2020 13:18:14 +0000 (UTC)
Date:   Tue, 7 Apr 2020 09:18:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Message-ID: <20200407131812.GB27866@bfoster>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
 <bug-207053-201763-xyUAU29Yyq@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-207053-201763-xyUAU29Yyq@https.bugzilla.kernel.org/>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 06:41:31AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207053
> 
> --- Comment #2 from Paul Furtado (paulfurtado91@gmail.com) ---
> Hi Dave,
> 
> Just had another case of this crop up and I was able to get the blocked tasks
> output before automation killed the server. Because the log was too large to
> attach, I've pasted the output into a github gist here:
> https://gist.githubusercontent.com/PaulFurtado/c9bade038b8a5c7ddb53a6e10def058f/raw/ee43926c96c0d6a9ec81a648754c1af599ef0bdd/sysrq_w.log
> 

Hm, so it looks like this is stuck between freeze:

[377279.630957] fsfreeze        D    0 46819  46337 0x00004084
[377279.634910] Call Trace:
[377279.637594]  ? __schedule+0x292/0x6f0
[377279.640833]  ? xfs_xattr_get+0x51/0x80 [xfs]
[377279.644287]  schedule+0x2f/0xa0
[377279.647286]  schedule_timeout+0x1dd/0x300
[377279.650661]  wait_for_completion+0x126/0x190
[377279.654154]  ? wake_up_q+0x80/0x80
[377279.657277]  ? work_busy+0x80/0x80
[377279.660375]  __flush_work+0x177/0x1b0
[377279.663604]  ? worker_attach_to_pool+0x90/0x90
[377279.667121]  __cancel_work_timer+0x12b/0x1b0
[377279.670571]  ? rcu_sync_enter+0x8b/0xd0
[377279.673864]  xfs_stop_block_reaping+0x15/0x30 [xfs]
[377279.677585]  xfs_fs_freeze+0x15/0x40 [xfs]
[377279.680950]  freeze_super+0xc8/0x190
[377279.684086]  do_vfs_ioctl+0x510/0x630
...

... and the eofblocks scanner:

[377279.422496] Workqueue: xfs-eofblocks/nvme13n1 xfs_eofblocks_worker [xfs]
[377279.426971] Call Trace:
[377279.429662]  ? __schedule+0x292/0x6f0
[377279.432839]  schedule+0x2f/0xa0
[377279.435794]  rwsem_down_read_slowpath+0x196/0x530
[377279.439435]  ? kmem_cache_alloc+0x152/0x1f0
[377279.442834]  ? __percpu_down_read+0x49/0x60
[377279.446242]  __percpu_down_read+0x49/0x60
[377279.449586]  __sb_start_write+0x5b/0x60
[377279.452869]  xfs_trans_alloc+0x152/0x160 [xfs]
[377279.456372]  xfs_free_eofblocks+0x12d/0x1f0 [xfs]
[377279.460014]  xfs_inode_free_eofblocks+0x128/0x1a0 [xfs]
[377279.463903]  ? xfs_inode_ag_walk_grab+0x5f/0x90 [xfs]
[377279.467680]  xfs_inode_ag_walk.isra.17+0x1a7/0x410 [xfs]
[377279.471567]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
[377279.475620]  ? kvm_sched_clock_read+0xd/0x20
[377279.479059]  ? sched_clock+0x5/0x10
[377279.482184]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
[377279.486234]  ? radix_tree_gang_lookup_tag+0xa8/0x100
[377279.489974]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
[377279.494041]  xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
[377279.497859]  xfs_eofblocks_worker+0x29/0x40 [xfs]
[377279.501484]  process_one_work+0x195/0x380
...

The immediate issue is likely that the eofblocks transaction is not
NOWRITECOUNT (same for the cowblocks scanner, btw), but the problem with
doing that is these helpers are called from other contexts outside of
the background scanners.

Perhaps what we need to do here is let these background scanners acquire
a superblock write reference, similar to what Darrick recently added to
scrub..? We'd have to do that from the scanner workqueue task, so it
would probably need to be a trylock so we don't end up in a similar
situation as above. I.e., we'd either get the reference and cause freeze
to wait until it's dropped or bail out if freeze has already stopped the
transaction subsystem. Thoughts?

Brian

> 
> Thanks,
> Paul
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

