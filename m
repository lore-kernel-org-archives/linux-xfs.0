Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855F6C433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 654AB2083B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQG0Rb/C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgIAJqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgIAJp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:45:59 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630F3C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:45:59 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c15so274284plq.4
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0NBu/KCdQiAvqSWdkSp0/s7elU+n7yQW7m78C57NUGw=;
        b=jQG0Rb/Cv4MvqC1GQ2IeeWSjXIg8ijzcFijgbcJ18PztIzAeAwuaVomAs6cnL24EQC
         vdwzDdbUi71hHXC15wX/uuxFEYsAhbGwHFfFFb9cGV48xdI0UpYDJcVySDeF+ybXD6oa
         so0VwrytMUgJOMJ0pRR31TvxDrlmzGG1tPdr0h7wBv0ll7l3Ky0t45hzkKOnYb7P1RW0
         7vmvYkZs0TUmmo7YSJZ7voy1KA9LcuNDNdE6qi8FpX/JZpBIq8nY3xIMyazhVv87OQrI
         xKQ3O5iuxaOZ8z6HLeNGU70++bcCAGDN6dEL++WLTwj6wvOI0zgkCB8wdWbat1Wv5n7g
         MYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NBu/KCdQiAvqSWdkSp0/s7elU+n7yQW7m78C57NUGw=;
        b=Qs0HrtAlbo6HTUFsQhlfts8lGp8ZV6E/ouzB1EzPFf+u+6MjMuNAjaINH+igX+bGWT
         M6DAnp1oESjpWDSDdPdBYDbNS1HFzSY5GEVRmQCvHLFK5rne4kh/ZPMAsHCienYDRj+u
         aQjACyPOV0Ff5utaF2HReTBNnjZvLaH7sUhSZux/3SIvTbln7v1dBYEKP2KYKbhreUDu
         oltXMqp0jM6EFjTjJ8AXJWbFk/dXptbaTBddLFM6LGaoaw4KNpYGVWbxja946qzYZA/1
         Br0eW8buz6kPFgQCRVaQwfzeXNiDYZdWa8ur1uqCaZXaOmyMRk3hjQbFngtHvGz7jJ7f
         V4wQ==
X-Gm-Message-State: AOAM533YdiW8QITsMqGYcRHmV515fFs7tUb2mT/sYO+lUzIGBWD6rYhV
        vBGjxOafVgVPTuCqsy9isIw=
X-Google-Smtp-Source: ABdhPJxASenvw9gjNLuWNBG5ngO0fscF8gkBZqvGFDtvFZ4CNSujWmPaMTSFxJ6cK+3C1GcWk4r29A==
X-Received: by 2002:a17:90a:d904:: with SMTP id c4mr745541pjv.145.1598953558912;
        Tue, 01 Sep 2020 02:45:58 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id c130sm1216855pfb.115.2020.09.01.02.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:45:58 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 03/10] xfs: Check for extent overflow when deleting an extent
Date:   Tue, 01 Sep 2020 15:14:30 +0530
Message-ID: <3694943.Jq2CTAKDPb@garuda>
In-Reply-To: <20200831163451.GL6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200820054349.5525-4-chandanrlinux@gmail.com> <20200831163451.GL6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 10:04:51 PM IST Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:42AM +0530, Chandan Babu R wrote:
> > Deleting a file range from the middle of an existing extent can cause
> > the per-inode extent count to increase by 1. This commit checks for
> > extent count overflow in such cases.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
> >  fs/xfs/xfs_bmap_item.c         | 4 ++++
> >  fs/xfs/xfs_bmap_util.c         | 5 +++++
> >  3 files changed, 15 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 7fc2b129a2e7..2642e4847ee0 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -39,6 +39,12 @@ struct xfs_ifork {
> >   * extent to a fork and there's no possibility of splitting an existing mapping.
> >   */
> >  #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
> > +/*
> > + * Removing an extent from the middle of an existing extent can cause the extent
> > + * count to increase by 1.
> > + * i.e. | Old extent | Hole | Old extent |
> > + */
> > +#define XFS_IEXT_REMOVE_CNT		(1)
> 
> The first thought that popped into my head after reading the subject
> line was "UH-oh, is this going to result in undeletable files when the
> extent counts hit max and the user tries to rm?"
> 
> Then I realized that "when deleting an extent" actually refers to
> punching holes in the middle of files, not truncating them.
> 
> So I think at the very least the subject line should be changed to
> say that we're talking about hole punching, not general file deletion;
> and the constant probably ought to be called XFS_IEXT_PUNCH_CNT to make
> that clearer.
>

Sure, I will change the commit message and the name of the constant.

> Aside from that the logic seems ok to me.
> 
> (Also PS I'm not reviewing these patches in order...)
> 
> --D
> 
> >  
> >  /*
> >   * Fork handling.
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index ec3691372e7c..b9c35fb10de4 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -519,6 +519,10 @@ xfs_bui_item_recover(
> >  	}
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	error = xfs_iext_count_may_overflow(ip, whichfork, XFS_IEXT_REMOVE_CNT);
> > +	if (error)
> > +		goto err_inode;
> > +
> >  	count = bmap->me_len;
> >  	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
> >  			bmap->me_startoff, bmap->me_startblock, &count, state);
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 7b76a48b0885..59d4da38aadf 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -891,6 +891,11 @@ xfs_unmap_extent(
> >  
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > +			XFS_IEXT_REMOVE_CNT);
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
> >  	if (error)
> >  		goto out_trans_cancel;
> 

-- 
chandan



