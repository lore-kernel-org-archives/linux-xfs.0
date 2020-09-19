Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242F6C43464
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 09:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D028D21582
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 09:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qqbnp76F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISJmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 05:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgISJmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 05:42:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129D3C0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 02:42:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so4296421plk.3
        for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2020 02:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=waiJ7FV3PCA0UkImNmrIs6NV9G1ZqtaeLIziSLsi5Dc=;
        b=Qqbnp76FD36f90MRTdd57GGe3Ki041TsBlwpRA4mPU7tpQazXoG4MWjUvIpvpFyBCD
         kobbKuUMfHTZ4zu3kQNskcOy3GKSf1Z0F+CAPRS4hQ4r6mSO1CF4bMimXBOU8hDli6pW
         ppj4AlVR/+TF1hY/ux4cJHoUjtDF/0VA/CU+mOTnY+qUz/7NrAw/3PLqTQuiNPxuTkCO
         2NJbAu5q6GzC/n2D5LXs00EW2JhauiN4zLqugD0bbKSiaIHprRZRH6tEk+yEhwtCWLr4
         /OWE8Xk5thmyh5JBKhABFXO6qPDSnF2HVNRANSULjWm2qchQXPvEW6ffVnM25uckgX5E
         zCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=waiJ7FV3PCA0UkImNmrIs6NV9G1ZqtaeLIziSLsi5Dc=;
        b=Y/RBT6BPMwILEzcoT6vqFOwQ+adiuHvPcDlDmNdUoCGYiBN1UPh48G5yFn2ivVNvDV
         KmqbPjrDd6jsNFzDIhZKDIFp2/jn3gBo6ZtDNO+z1HUvhk6B6kT+i4uY9vw9SApuhaIa
         yKj1clpUl7SPXHPuA6v6MOvwVkUCL1LPwvCQOLEcMrNRUkuwqK8VUsQOifJgBs/LEioY
         YXxsHB0GHduXTfBK5VE1wT+q3T+cXQtoRquRsvrh3zLEwUojlMkSL/QO4QiiRL/gHHKb
         V6T7iFbEDo3Whk2oDRNX5KQQ2XGmwllk/qyJqHnZAmTaPIsRsZdUQFgkxOG6hP4vNAuo
         BaPQ==
X-Gm-Message-State: AOAM532tk3FTuOSMBOSf4eTiQ9MJu1krGhRzKP9tLxUAI8CR5SUUItiF
        JEB6hrZ3/iUO2z4m7YL5OUX9rDZMnwk=
X-Google-Smtp-Source: ABdhPJw+RPc78w/jhr2dP05JVTlrbEkxk2195KpBwu+uTPPEiY5fG3tKuCREZ96EKmvCkjo5PjG87w==
X-Received: by 2002:a17:902:59d7:b029:d1:e5e7:bdf9 with SMTP id d23-20020a17090259d7b02900d1e5e7bdf9mr19062642plj.44.1600508554559;
        Sat, 19 Sep 2020 02:42:34 -0700 (PDT)
Received: from garuda.localnet ([122.171.63.16])
        by smtp.gmail.com with ESMTPSA id r15sm5794400pgg.17.2020.09.19.02.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 02:42:33 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 03/10] xfs: Check for extent overflow when punching a hole
Date:   Sat, 19 Sep 2020 15:12:30 +0530
Message-ID: <8943600.hOzF94syPF@garuda>
In-Reply-To: <20200918155452.GA7955@magnolia>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com> <20200918094759.2727564-4-chandanrlinux@gmail.com> <20200918155452.GA7955@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 18 September 2020 9:24:52 PM IST Darrick J. Wong wrote:
> On Fri, Sep 18, 2020 at 03:17:52PM +0530, Chandan Babu R wrote:
> > The extent mapping the file offset at which a hole has to be
> > inserted will be split into two extents causing extent count to
> > increase by 1.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
> >  fs/xfs/xfs_bmap_item.c         |  5 +++++
> >  fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
> >  3 files changed, 22 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 7fc2b129a2e7..bcac769a7df6 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -40,6 +40,13 @@ struct xfs_ifork {
> >   */
> >  #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
> >  
> > +/*
> > + * Punching out an extent from the middle of an existing extent can cause the
> > + * extent count to increase by 1.
> > + * i.e. | Old extent | Hole | Old extent |
> > + */
> > +#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> > +
> >  /*
> >   * Fork handling.
> >   */
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index ec3691372e7c..5c7d08da8ff1 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -519,6 +519,11 @@ xfs_bui_item_recover(
> >  	}
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	error = xfs_iext_count_may_overflow(ip, whichfork,
> > +			XFS_IEXT_PUNCH_HOLE_CNT);
> 
> I think this ought to be XFS_IEXT_ADD_NOSPLIT_CNT if bui_type is
> XFS_BMAP_MAP and XFS_IEXT_PUNCH_HOLE_CNT if XFS_BMAP_UNMAP.

You are right. I will include this change in the next version.

> 
> Whoever created the BUI should have called xfs_iext_count_may_overflow
> before logging the BUI (and hence this should never occur) but it does
> pay to be careful. :)
> 
> The rest of the logic in the patch looks ok.
> 
> --D
> 
> > +	if (error)
> > +		goto err_inode;
> > +
> >  	count = bmap->me_len;
> >  	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
> >  			bmap->me_startoff, bmap->me_startblock, &count, state);
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index dcd6e61df711..0776abd0103c 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -891,6 +891,11 @@ xfs_unmap_extent(
> >  
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > +			XFS_IEXT_PUNCH_HOLE_CNT);
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
> >  	if (error)
> >  		goto out_trans_cancel;
> > @@ -1176,6 +1181,11 @@ xfs_insert_file_space(
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > +			XFS_IEXT_PUNCH_HOLE_CNT);
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	/*
> >  	 * The extent shifting code works on extent granularity. So, if stop_fsb
> >  	 * is not the starting block of extent, we need to split the extent at
> 

-- 
chandan



