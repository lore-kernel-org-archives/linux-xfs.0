Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0FCC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 04:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFC4208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 04:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jhQe6Hta"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgJPE1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgJPE1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Oct 2020 00:27:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C090CC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 21:27:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so649605pgf.9
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 21:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FTv58tJjCm7apsqGQzPjARbBgb/dFrtgJpL8hc2WO7Y=;
        b=jhQe6Htam2dSSWY37IcTLvl0eXxSzkx574p7jccEF9mgaro3yefS29RlfTnLcRyxv3
         cXRRUTtDWDKSQZVTvssxgk3UnS0NK4iH4QCQncVJ+wXd/itVod08nLitMkBMVMGpsP/M
         BkimaFFQLbCin4DIUT7xxSKGb9FlUggpqR44A1vF1dBaFun7ssC7AEXhmQ+ia6ZlGxGw
         74D2VIhLYzMh95sDMmXTYZyWoLlXEar/wyq4epJ0TZc6mSOzsdwVpCRTH+vHVi0cd5CE
         7xjtKInibTw/wnEedRy7hBotmEkFS8BoE8Zl1DgiA0kX0nVp7BQENbtAaGd8FeG428v6
         puFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTv58tJjCm7apsqGQzPjARbBgb/dFrtgJpL8hc2WO7Y=;
        b=X28raSMrKfM7oWZBwlnl6mScWSFxQZ346j5Ct/HuviY6PpLicyIYNTNfTD7gxWX+tD
         fGt6HhXGDJbOtJxw0E81+NRnySPys4UotBxYgrbnoEv66rmy9CvzXVn4L9+60pQhjDK+
         gOI+D9krcMzZr0w/kWhDlAiCBA4ueweDb8iP5EUA7PMhl+Nui0hrFday8iFu/neRFGaR
         9gCn943KTZdU6aAE5uk7jkmnqikxt6UlG2FuVviZ+lNMtoDK25hMt68kLoF9pg9c1SBe
         IMPWCx5TM/eJ2ZVOfvHfxkKiOeW7yWjxThEoRVWQ1ND//BV3iiD0ONc8tJkCR4Z9FLE/
         Qkzg==
X-Gm-Message-State: AOAM531KswaU6WB4FnG6tG4SJqsKgcpyByRcTBszqhuuTgdgPwOd8s86
        nUUWSpjF4tl4k61eWu62FUefU8Y41nI=
X-Google-Smtp-Source: ABdhPJwLEoeVmO1kR14Eah1iIE3sxErvh8/ucwMqniESXFWkYWyDdHei59Lc/bdeatCv2ULb55JXGg==
X-Received: by 2002:aa7:9823:0:b029:158:ee6b:e939 with SMTP id q3-20020aa798230000b0290158ee6be939mr2024103pfl.37.1602822443242;
        Thu, 15 Oct 2020 21:27:23 -0700 (PDT)
Received: from garuda.localnet ([122.167.154.211])
        by smtp.gmail.com with ESMTPSA id 84sm920125pfx.120.2020.10.15.21.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 21:27:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping an extent
Date:   Fri, 16 Oct 2020 09:57:19 +0530
Message-ID: <66787089.qbDNxTZFml@garuda>
In-Reply-To: <20201015184545.GC9832@magnolia>
References: <20201012092938.50946-1-chandanrlinux@gmail.com> <1680655.hsWa3aTUJI@garuda> <20201015184545.GC9832@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 16 October 2020 12:15:45 AM IST Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 03:31:26PM +0530, Chandan Babu R wrote:
> > On Thursday 15 October 2020 2:09:45 PM IST Christoph Hellwig wrote:
> > > This patch demonstrates very well why I think having these magic
> > > defines and the comments in a header makes no sense.
> > > 
> > > > +/*
> > > > + * Remapping an extent involves unmapping the existing extent and mapping in the
> > > > + * new extent.
> > > > + *
> > > > + * When unmapping, an extent containing the entire unmap range can be split into
> > > > + * two extents,
> > > > + * i.e. | Old extent | hole | Old extent |
> > > > + * Hence extent count increases by 1.
> > > > + *
> > > > + * Mapping in the new extent into the destination file can increase the extent
> > > > + * count by 1.
> > > > + */
> > > > +#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> > > > +	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> > > > +
> > > >  /*
> > > >   * Fork handling.
> > > >   */
> > > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > > index 4f0198f636ad..c9f9ff68b5bb 100644
> > > > --- a/fs/xfs/xfs_reflink.c
> > > > +++ b/fs/xfs/xfs_reflink.c
> > > > @@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
> > > >  			goto out_cancel;
> > > >  	}
> > > >  
> > > > +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > > > +			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
> > > > +	if (error)
> > > > +		goto out_cancel;
> > > > +
> > > 
> > > This is a completely mess.
> > > 
> > > If OTOH xfs_reflink_remap_extent had a local variable for the potential
> > > max number of extents, which is incremented near the initialization
> > > of smap_real and dmap_written, with a nice comment near to each
> > > increment it would make complete sense to the reader.
> > >
> > 
> > How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
> > to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
> > from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
> > worst case value of 2? A write spanning the entirety of an unwritten extent
> > does not change the extent count. Similarly, If there are no extents in the
> > data fork spanning the file range mapped by an extent in the cow
> > fork, moving the extent from cow fork to data fork increases the extent count
> > by just 1 and not by the worst case count of 2.
> 
> Probably not a huge deal, since at worst we bail out of reflink early
> and userspace can just decide to fall back to a pagecache copy or
> whatever.  It'd be harder to deal with if this was the cow path where we
> long ago returned from write() and even writeback...
> 
> ...though now that I think about it, what /does/ happens if
> _reflink_end_cow trips over this?  I wonder if inodes need to be able to
> reserve extent count for later, but ... hgnghghg that seems hard to
> reason about.

I am not sure if I am following you. Looks like you are asking about what
happens if xfs_reflink_end_cow_extent() trips over
XFS_IEXT_REFLINK_END_COW_CNT limit. If that occurs, then the end_io path would
set AS_EIO on mapping->flags which would in turn cause the upper layers of the
kernel to return -EIO to the corresponding fsync() call made by a userspace
program.

-- 
chandan



