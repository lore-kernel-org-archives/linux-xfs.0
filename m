Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FE4C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBAFE214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NpVRPUDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgIAJqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgIAJpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:45:53 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAF6C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:45:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t11so273203plr.5
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hKJZkyLkuTmeih1zIGurNYxDzachovKYI4EXhJ+lx4k=;
        b=NpVRPUDGfVYsxQ2AaWN1WZwrL3fRO6ciVkzwI/dFMdPVsngn2hJSsmjTlwhS5i2J2x
         BsURemcK2DeCkpmDkwz5XVilxpfhRrX7a4eon70tkJhZWDM9SsOkMILoCbG2Btl8BTYn
         QSZPcAtOW/4srVBjZvxcNJcTAistw79Sv4vb8VsmxCn7jEsoDiEj2or+VVewmQfi6WXO
         sExr23grhufsfnaoWXQQM+g60JUpaN2son9YPI+Iks7siaY1sxaKr6Ijr/d55BtKwkNz
         ccZX4yA2cQdIBior0/T+hfrlIkq3s1/8G+Zsqp+8BdUqdCXSro/WirqGs6E6lf3bmYz9
         WkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hKJZkyLkuTmeih1zIGurNYxDzachovKYI4EXhJ+lx4k=;
        b=IkWHyF9ineVKemRWUhCJg2ZUA8p1M8Utjgr3jL0j/0ZS7S6FfNuUPCceSq8UNnB4L/
         SIYhifNW5dDi/kitRxQ683n8hE+ZjDzAR2DY2g5glnQWAIuDubVqSstCmeUDO+5PU/Nq
         HfP1Sm735QRkjre9oT7s3f4cAS8EjJySBdxgoOmUTwcXY36rIMtMParRF/sHP1FY6h9O
         m97x/PQ5NMz6rVWxURHsFhXoahb7SJCrRKxL32R9g5ky1/BJdM/5OaLhEeQRIxiBqwlF
         9hpmGtAPQO6mZ5FcpLU1kv9BlGF8V3YFkwAc41gVawh8IxBHwPgaOliIdNCGYDIeMG8T
         ubUg==
X-Gm-Message-State: AOAM532piaX8rGWdteRz03I2U3lOpH3e450ERIFv2axhSsVsrQaaJ4eM
        VBkoQQ12ZzjYbdMG0ccxS5g=
X-Google-Smtp-Source: ABdhPJwoZkCN6+7UQiWz4P1uBxaVjApEIbWkrWEalCbBVdUUeAZxIvUt2X3wCiE9TnEKDFMnJC7Jqg==
X-Received: by 2002:a17:902:6a8b:: with SMTP id n11mr667431plk.75.1598953552270;
        Tue, 01 Sep 2020 02:45:52 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id j81sm1205354pfd.213.2020.09.01.02.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:45:51 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 07/10] xfs: Check for extent overflow when inserting a hole
Date:   Tue, 01 Sep 2020 15:14:52 +0530
Message-ID: <1622223.9oNHTMeo2i@garuda>
In-Reply-To: <20200831164635.GQ6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200820054349.5525-8-chandanrlinux@gmail.com> <20200831164635.GQ6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 10:16:35 PM IST Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:46AM +0530, Chandan Babu R wrote:
> > The extent mapping the file offset at which a hole has to be
> > inserted will be split into two extents causing extent count to
> > increase by 1.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
> >  fs/xfs/xfs_bmap_util.c         | 9 +++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 83ff90e2a5fe..d0e49b015b62 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -73,6 +73,12 @@ struct xfs_ifork {
> >   * Hence extent count can increase by 2.
> >   */
> >  #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
> > +/*
> > + * The extent mapping the file offset at which a hole has to be inserted will be
> > + * split into two extents causing extent count to increase by 1.
> > + */
> > +#define XFS_IEXT_INSERT_HOLE_CNT	(1)
> 
> Given my earlier comments about how patch 3 is really only testing the
> hole punching case, maybe it should be folded into this one?  They're
> both inserting holes in the extent map.
>
I agree. I will make the required changes.

-- 
chandan



