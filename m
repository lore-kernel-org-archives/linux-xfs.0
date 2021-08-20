Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C516C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 10:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F2360F4A
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 10:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbhHTKNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 06:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhHTKNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Aug 2021 06:13:12 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33539C061575
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 03:12:35 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 18so8171198pfh.9
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 03:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=PGiPK+BE2IhWPV4JtIdF5RjBVy+Hmm6oG3huqD6BSmc=;
        b=kyhVgrRuuhmyt4LXBQCP9FR+Lcsy26TVoxzAlMqO5ukSk3gVudReODBWMjLzGlSy7Z
         6alIRRjxUIZki5uWZuyBSttM+/gaRTG+tYDai0gsX3utxlUV8OFQ2bb323V57j0neRth
         29RmCdMF638JqZm9u0jD/cFBq5i0Lw0NA5X/rKY/r/sOfzo3FmOa607LB0o5Rdxk20ac
         O9wcs8rTvqO3yF3DzeUTn4bvEhNXLpfaTku6sdq/70YVuU4/CmRTer+m8Q4rhr+L1Efo
         MvxC0rFqKXKk87ae69T+Kkp2VjvPEFSDAsDMnr8tjTcCjX9GotlpGPJX3D9mm8BpZ7ca
         garQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=PGiPK+BE2IhWPV4JtIdF5RjBVy+Hmm6oG3huqD6BSmc=;
        b=qpo1LMsvh0ds1cAjmnEhw3N5n5eHeYRrOh1QUq/wXwhPB4Cgl5AXiNnp+mJVMdkKJz
         WF0mwihXarPVaHpKYktTb6mS415KTsOqHSmnU26qE25FupeO1LXwAYgukH/yo5DkgE5X
         qG9KLZWiTLkZJ1bQToK2taX5kk/g0fFRql/FWwpY1k+nG/0tj7so2EcDSlFKEbmOEu1g
         9yeHfaWzPDR8jk6N9OxV4LP6FgRQxu9qOTpN5SGd+8I4kgSaIrP/HMAZtJ3fsYr5Og3e
         MGQ9QC6it/VTYkkEOpxO20y+q2rq7SjFUpJKOrPVfF4lLHg1WO7qFZlsmzz3I53PZAI4
         5TpA==
X-Gm-Message-State: AOAM530i7JKe4U9hNJY/zj3uC7h57mSjlI+2V8SR0h0CieO4HF5M4rn7
        ZnhRjyfiZn2ShW2t+BWeT2g=
X-Google-Smtp-Source: ABdhPJyOpymMJx8itr85af10PhcuzXzeXy7OBiQ//P6F4+CdVVoYbO9y7t9POaOTboe8GhZsyH1VSA==
X-Received: by 2002:a05:6a00:1626:b029:3e0:99b6:b320 with SMTP id e6-20020a056a001626b02903e099b6b320mr18982169pfc.25.1629454354717;
        Fri, 20 Aug 2021 03:12:34 -0700 (PDT)
Received: from garuda ([122.179.118.216])
        by smtp.gmail.com with ESMTPSA id s188sm6388997pfb.4.2021.08.20.03.12.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Aug 2021 03:12:34 -0700 (PDT)
References: <20210820050647.GW12640@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, oliver.sang@intel.com
Subject: Re: [PATCH] xfs: fix perag structure refcounting error when scrub
 fails
In-reply-to: <20210820050647.GW12640@magnolia>
Message-ID: <87a6lcpgq8.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 20 Aug 2021 15:42:31 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Aug 2021 at 10:36, Darrick J. Wong wrote:
> The kernel test robot found the following bug when running xfs/355 to
> scrub a bmap btree:
>
> XFS: Assertion failed: !sa->pag, file: fs/xfs/scrub/common.c, line: 412
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:110!
> invalid opcode: 0000 [#1] SMP PTI
> CPU: 2 PID: 1415 Comm: xfs_scrub Not tainted 5.14.0-rc4-00021-g48c6615cc557 #1
> Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
> RIP: 0010:assfail+0x23/0x28 [xfs]
> RSP: 0018:ffffc9000aacb890 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffc9000aacbcc8 RCX: 0000000000000000
> RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc09e7dcd
> RBP: ffffc9000aacbc80 R08: ffff8881fdf17d50 R09: 0000000000000000
> R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
> R13: ffff88820c7ed000 R14: 0000000000000001 R15: ffffc9000aacb980
> FS:  00007f185b955700(0000) GS:ffff8881fdf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7f6ef43000 CR3: 000000020de38002 CR4: 00000000001706e0
> Call Trace:
>  xchk_ag_read_headers+0xda/0x100 [xfs]
>  xchk_ag_init+0x15/0x40 [xfs]
>  xchk_btree_check_block_owner+0x76/0x180 [xfs]
>  xchk_btree_get_block+0xd0/0x140 [xfs]
>  xchk_btree+0x32e/0x440 [xfs]
>  xchk_bmap_btree+0xd4/0x140 [xfs]
>  xchk_bmap+0x1eb/0x3c0 [xfs]
>  xfs_scrub_metadata+0x227/0x4c0 [xfs]
>  xfs_ioc_scrub_metadata+0x50/0xc0 [xfs]
>  xfs_file_ioctl+0x90c/0xc40 [xfs]
>  __x64_sys_ioctl+0x83/0xc0
>  do_syscall_64+0x3b/0xc0
>
> The unusual handling of errors while initializing struct xchk_ag is the
> root cause here.  Since the beginning of xfs_scrub, the goal of
> xchk_ag_read_headers has been to read all three AG header buffers and
> attach them both to the xchk_ag structure and the scrub transaction.
> Corruption errors on any of the three headers doesn't necessarily
> trigger an immediate return to userspace, because xfs_scrub can also
> tell us to /fix/ the problem.
>
> In other words, it's possible for the xchk_ag init functions to return
> an error code and a partially filled out structure so that scrub can use
> however much information it managed to pull.  Before 5.15, it was
> sufficient to cancel (or commit) the scrub transaction on the way out of
> the scrub code to release the buffers.
>
> Ccommit 48c6615cc557 added a reference to the perag structure to struct
> xchk_ag.  Since perag structures are not attached to transactions like
> buffers are, this adds the requirement that the perag ref be released
> explicitly.  The scrub teardown function xchk_teardown was amended to do
> this for the xchk_ag embedded in struct xfs_scrub.
>
> Unfortunately, I forgot that certain parts of the scrub code probe
> multiple AGs and therefore handle the initialization and cleanup on
> their own.  Specifically, the bmbt scrubber will initialize it long
> enough to cross-reference AG metadata for btree blocks and for the
> extent mappings in the bmbt.
>
> If one of the AG headers is corrupt, the init function returns with a
> live perag structure reference and some of the AG header buffers.  If an
> error occurs, the cross referencing will be noted as XCORRUPTion and
> skipped, but the main scrub process will move on to the next record.
> It is now necessary to release the perag reference before we try to
> analyze something from a different AG, or else we'll trip over the
> assertion noted above.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Fixes: 48c6615cc557 ("xfs: grab active perag ref when reading AG headers")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/bmap.c       |    3 ++-
>  fs/xfs/scrub/btree.c      |    3 ++-
>  fs/xfs/scrub/fscounters.c |    2 +-
>  fs/xfs/scrub/inode.c      |    3 ++-
>  4 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 2df5e5a51cbd..017da9ceaee9 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -263,7 +263,7 @@ xchk_bmap_iextent_xref(
>  	error = xchk_ag_init_existing(info->sc, agno, &info->sc->sa);
>  	if (!xchk_fblock_process_error(info->sc, info->whichfork,
>  			irec->br_startoff, &error))
> -		return;
> +		goto out_free;
>  
>  	xchk_xref_is_used_space(info->sc, agbno, len);
>  	xchk_xref_is_not_inode_chunk(info->sc, agbno, len);
> @@ -283,6 +283,7 @@ xchk_bmap_iextent_xref(
>  		break;
>  	}
>  
> +out_free:
>  	xchk_ag_free(info->sc, &info->sc->sa);
>  }
>  
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index fd832f103fa4..eccb855dc904 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -377,7 +377,7 @@ xchk_btree_check_block_owner(
>  		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
>  		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
>  				level, &error))
> -			return error;
> +			goto out_free;
>  	}
>  
>  	xchk_xref_is_used_space(bs->sc, agbno, 1);
> @@ -393,6 +393,7 @@ xchk_btree_check_block_owner(
>  	if (!bs->sc->sa.rmap_cur && btnum == XFS_BTNUM_RMAP)
>  		bs->cur = NULL;
>  
> +out_free:
>  	if (init_sa)
>  		xchk_ag_free(bs->sc, &bs->sc->sa);
>  
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 737aa5b39d5e..48a6cbdf95d0 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -150,7 +150,7 @@ xchk_fscount_btreeblks(
>  
>  	error = xchk_ag_init_existing(sc, agno, &sc->sa);
>  	if (error)
> -		return error;
> +		goto out_free;
>  
>  	error = xfs_btree_count_blocks(sc->sa.bno_cur, &blocks);
>  	if (error)
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index d6e0e3a11fbc..2405b09d03d0 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -533,7 +533,7 @@ xchk_inode_xref(
>  
>  	error = xchk_ag_init_existing(sc, agno, &sc->sa);
>  	if (!xchk_xref_process_error(sc, agno, agbno, &error))
> -		return;
> +		goto out_free;
>  
>  	xchk_xref_is_used_space(sc, agbno, 1);
>  	xchk_inode_xref_finobt(sc, ino);
> @@ -541,6 +541,7 @@ xchk_inode_xref(
>  	xchk_xref_is_not_shared(sc, agbno, 1);
>  	xchk_inode_xref_bmap(sc, dip);
>  
> +out_free:
>  	xchk_ag_free(sc, &sc->sa);
>  }
>  


-- 
chandan
