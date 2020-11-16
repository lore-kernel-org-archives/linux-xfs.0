Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354C9C4742C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 08:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0D22071E
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 08:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQisaZk+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKPIOP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:14:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgKPIOP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 03:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605514453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CUm1dZhs2RLNTVqlzpV60EdvwMB0WpQWZEB8XMwwdsU=;
        b=dQisaZk+tsxXvi9UwAr5dm9RAHoLNkLB6LrkjTrX4I1+dM4kb056cHbyrWU6IvM1V6fLYl
        WJ1kpXqf3RYNzUFxC4eWVdF6bPO71UfKW94yMnlUXO61Z3CH5sdb5Yx2bCEjxInYNdsjH8
        0HQz550xgGsTJ+lXlaeGFRT17bENqog=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-O6dURqisN3C-CwPCU3KT-g-1; Mon, 16 Nov 2020 03:14:11 -0500
X-MC-Unique: O6dURqisN3C-CwPCU3KT-g-1
Received: by mail-pl1-f200.google.com with SMTP id h2so1377626pll.22
        for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2020 00:14:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CUm1dZhs2RLNTVqlzpV60EdvwMB0WpQWZEB8XMwwdsU=;
        b=bY1c/kmCPji/rH++shC1dmI+DH5nj36CenenLFSGYEJ6v+CGjMZZ+UM3HMYoahQdkm
         Tc9hfRc2upiL/rZPUX8R5ilPN77B3Ynv1JJabXeYsfsLsX6NW42ZqX6p2hKDDKtv0HoY
         uYu+9IwL525JGhQsL+9tWWkQqXFaQvbW9xDxvxaxwdKj/WMC+LU2gdkpwXu/pUMcyIIr
         8fATz/+pH17b0aEA3GqCNLDlsZrp86iuNpbHPWitbZVxlkCnCfs3x96emFs4cd5/GVfI
         pRgXuuRyvRDGyXcmTj2BGA22ETVR1mprwEaVodF2bi3H0SPE5hj49PXHNHaPYYA9ZMd2
         p9ig==
X-Gm-Message-State: AOAM531VA1tkKX10N456QOSAYYHQciVEHFH41es0Sp+x/ZN5xanKAg9d
        Ne/KBbEkRdUETMR4Q+0aHg0mnLvkaC2S9BeXqtDwG4B2n59HWXxwNiMpLBERZIBTTB6zNkeIB7t
        O1Oz9hhxceR5fojQR2aaBU51K2GjDFaeKV8EURXiPRpHz7onXA0zcWiTnKR15Fl0/0skIch014A
        ==
X-Received: by 2002:aa7:9e88:0:b029:18b:c1b7:a8cd with SMTP id p8-20020aa79e880000b029018bc1b7a8cdmr13374907pfq.21.1605514450319;
        Mon, 16 Nov 2020 00:14:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqyxzVATBCWyVqtJFGRhrVCK6WgeqwC0KbzqNZGBmRNtIdBWd96rbcYk7LxHC4ZVcGJscW+g==
X-Received: by 2002:aa7:9e88:0:b029:18b:c1b7:a8cd with SMTP id p8-20020aa79e880000b029018bc1b7a8cdmr13374889pfq.21.1605514449943;
        Mon, 16 Nov 2020 00:14:09 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12sm15229823pjs.27.2020.11.16.00.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 00:14:09 -0800 (PST)
Date:   Mon, 16 Nov 2020 16:13:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [RFC PATCH v2] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <20201116081359.GA1486562@xiangao.remote.csb>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <20201116080723.1486270-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116080723.1486270-1-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 16, 2020 at 04:07:23PM +0800, Gao Xiang wrote:
> If rootino is wrong and misspecified to a subdir inode #,
> the following assertion could be triggered:
>   assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> 
> This patch adds a '-x' option (another awkward thing is that
> the codebase doesn't support long options) to address
> problamatic images by searching for the real dir, the reason
> that I don't enable it by default is that I'm not very confident
> with the xfsrestore codebase and xfsdump bulkstat issue will
> also be fixed immediately as well, so this function might be
> optional and only useful for pre-exist corrupted dumps.
> 
> In details, my understanding of the original logic is
>  1) xfsrestore will create a rootdir node_t (p_rooth);
>  2) it will build the tree hierarchy from inomap and adopt
>     the parent if needed (so inodes whose parent ino hasn't
>     detected will be in the orphan dir, p_orphh);
>  3) during this period, if ino == rootino and
>     hardh != persp->p_rooth (IOWs, another node_t with
>     the same ino # is created), that'd be definitely wrong.
> 
> So the proposal fix is that
>  - considering the xfsdump root ino # is a subdir inode, it'll
>    trigger ino == rootino && hardh != persp->p_rooth condition;
>  - so we log this node_t as persp->p_rooth rather than the
>    initial rootdir node_t created in 1);
>  - we also know that this node is actually a subdir, and after
>    the whole inomap is scanned (IOWs, the tree is built),
>    the real root dir will have the orphan dir parent p_orphh;
>  - therefore, we walk up by the parent until some node_t has
>    the p_orphh, so that's it.
> 
> Cc: Donald Douwsma <ddouwsma@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since RFC v1:
>  - fix non-dir fake rootino cases since tree_begindir()
>    won't be triggered for these non-dir, and we could do
>    that in tree_addent() instead (fault injection verified);
> 
>  - fix fake rootino case with gen = 0 as well, for more
>    details, see the inlined comment in link_hardh()
>    (fault injection verified as well).
> 
> Anyway, all of this behaves like a workaround and I have
> no idea how to deal it more gracefully.
>

My manual fault injection patch:
 - inject a non-dir fake rootino;
 - inject all inode gen = 0 (to check the fake rootino case with gen = 0);
 - disable the fake rootino case with gen = 0 workaround, and see
    xfsrestore: tree.c:1003: tree_addent: Assertion `hardp->n_nrh != NRH_NULL' failed.
   could happen.


diff --git a/dump/content.c b/dump/content.c
index c11d9b4..2d27d24 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1509,6 +1509,7 @@ baseuuidbypass:
 	}
 
 	scwhdrtemplatep->cih_rootino = sc_rootxfsstatp->bs_ino;
+	scwhdrtemplatep->cih_rootino = 25166002;	/* inject some real non-dir ino # */
 	inomap_writehdr(scwhdrtemplatep);
 
 	/* log the dump size. just a rough approx.
diff --git a/restore/content.c b/restore/content.c
index e807a83..f493fdb 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8143,7 +8143,7 @@ read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs)
 			return RV_CORRUPT;
 		}
 	}
-
+	bstatp->bs_gen = 0;
 	return RV_OK;
 }
 
@@ -8277,6 +8277,8 @@ read_dirent(drive_t *drivep,
 		}
 	}
 
+	dhdrp->dh_gen = 0;
+
 	mlog(MLOG_NITTY,
 	      "read dirent hdr ino %llu gen %u size %u\n",
 	      dhdrp->dh_ino,
diff --git a/restore/tree.c b/restore/tree.c
index 918fa01..2d8dec5 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -3886,6 +3886,7 @@ link_hardh(xfs_ino_t ino, gen_t gen)
 {
 	nh_t tmp = hash_find(ino, gen);
 
+#if 0
 	/*
 	 * XXX (another workaround): the simply way is that don't reuse node_t
 	 * with gen = 0 created in tree_init(). Otherwise, it could cause
@@ -3903,6 +3904,7 @@ _("link out fake rootino %llu with gen=0 created in tree_init()\n"), ino);
 		orig_rooth = tmp;
 		return NH_NULL;
 	}
+#endif
 	return tmp;
 }
 
-- 
2.18.4


