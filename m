Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2BDC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A33720C56
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AC7IzgS9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIAJpw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgIAJps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:45:48 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FABC061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:45:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so280354plr.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mP2TnE6Ygi04Ko3I/BkhUK87N3XgdGtGuKoTYJ6519I=;
        b=AC7IzgS9Hx3FO2oMAGOBt4Ym6iaEyQdTuXPwZdNFcURBEzPmLUeYUi2LMvTWxvftpO
         FwGSWNxIr1WO7P4im0ExXzjmY35zD06OP3kzpOrD5EZkrM71ctMZnG6rzuE/fojo+/69
         1nDwqzlU4j/CgCIJoEM19RsMs/Mln4bBzq+mCv4vfcDGh6nkDQLp58s287cIAAXQ7Za0
         XbMy43B01RHYhk1HvIQC5IoWGsw5J22xqgF/x+62cKrKyzwSA6FNK/9pQ0WQ9mLOxtR8
         KSR+egI37p737j3Ztg5R1EBO3FYU+VECxpv9C4kT7Dn3WLDBxcyatfOG7Gj0MQzGv/Wo
         Unhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mP2TnE6Ygi04Ko3I/BkhUK87N3XgdGtGuKoTYJ6519I=;
        b=VRS0UtvIHLOJA8mFMw99frXUY8aaYmlRPI3Ny3otWVR2n/7U4Ozq5HUeDveBuveXVo
         Wka15kPHlJrEI4EM02itPf/EX+xCqFenLMnO2pWGmv3zSBQYywGRV+daZJ1/jZThBzFF
         PK/UGtKIMPFrUg9ep7GXh+4sxWgxfavq7/jb9sAU19rYjxv6h1beKnTguR6JXtAGsC14
         s5qsUjAmOj4zGHyu8lUtMPzH0vCEc2IkP8MoG/Bkra0PxPptEbioQV1u9kUPKGyon38J
         KYeEkTPZMcLFcp4nK350O/tvv24hivBEpscMyxlLmnqcVHSPccrQYFjPcUX8foFocNk6
         O3mQ==
X-Gm-Message-State: AOAM531ueeCcwoWz0liW1gLnbs0ViS5N5O3yikYg1DR/MRGh+EYxlWEn
        HnQI2XprNL3Gz/N0TpcJhKPciOSuLOQ=
X-Google-Smtp-Source: ABdhPJzrNJiMZyU0l0R+y+ZVAuFg5f/+/pnEX0DGXHKf3Ec+M0anhaj+n4YXaqprZ7Ycxa0e7gr6ow==
X-Received: by 2002:a17:902:6944:: with SMTP id k4mr657955plt.147.1598953547658;
        Tue, 01 Sep 2020 02:45:47 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id 29sm1088396pje.10.2020.09.01.02.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:45:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 08/10] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Tue, 01 Sep 2020 15:15:01 +0530
Message-ID: <1612435.tKS2nXQfWZ@garuda>
In-Reply-To: <20200831162908.GK6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200820054349.5525-9-chandanrlinux@gmail.com> <20200831162908.GK6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 9:59:08 PM IST Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:47AM +0530, Chandan Babu R wrote:
> > Moving an extent to data fork can cause a sub-interval of an existing
> > extent to be unmapped. This will increase extent count by 1. Mapping in
> > the new extent can increase the extent count by 1 again i.e.
> >  | Old extent | New extent | Old extent |
> > Hence number of extents increases by 2.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h | 9 ++++++++-
> >  fs/xfs/xfs_reflink.c           | 5 +++++
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index d0e49b015b62..850d53162545 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -78,7 +78,14 @@ struct xfs_ifork {
> >   * split into two extents causing extent count to increase by 1.
> >   */
> >  #define XFS_IEXT_INSERT_HOLE_CNT	(1)
> > -
> > +/*
> > + * Moving an extent to data fork can cause a sub-interval of an existing extent
> > + * to be unmapped. This will increase extent count by 1. Mapping in the new
> > + * extent can increase the extent count by 1 again i.e.
> > + * | Old extent | New extent | Old extent |
> > + * Hence number of extents increases by 2.
> > + */
> > +#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
> >  
> >  /*
> >   * Fork handling.
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index aac83f9d6107..c1d2a741e1af 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > +			XFS_IEXT_REFLINK_END_COW_CNT);
> > +	if (error)
> > +		goto out_cancel;
> 
> What happens if we fail here?  I think for buffered writes this means
> that writeback fails and we store an EIO in the address space for
> eventual return via fsync()?   And for a direct write this means that
> EIO gets sent back to the caller, right?
>

Yes, you are right about that.

> Assuming I understood that correctly, I think this is a reasonable
> enough place to check for overflows, and hence
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It would be nicer to check this kind of thing at write() time to put all
> the EFBIG errors up front, but I don't think you can do that without
> tracking extent count "reservations" incore.
> 
> --D
> 
> > +
> >  	/*
> >  	 * In case of racing, overlapping AIO writes no COW extents might be
> >  	 * left by the time I/O completes for the loser of the race.  In that
> 

-- 
chandan



