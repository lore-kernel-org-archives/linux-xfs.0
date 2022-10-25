Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D25C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiJYVTh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJYVTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:19:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0872DF7
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:19:31 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id io19so7144701plb.8
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3hrsq8ux24YOMvQI/N3uNaK4e6Srnr3G4ObEwjIIDTQ=;
        b=Chmg17NEljnQjs97o5LGHIqhPSmJVLgvQ6DPmvC3n66Zb+Z+1p8p/JZFWBx0w8laE5
         qXdb5cCmBoVgTZqpttDYkgnqqaPjmx1f9NeS0fJWgy4FvyQV5n4yYNFZSh6rtJ8udK9r
         TtFrwQAGNPnniLr7IbDiyhmcr+FueVjFmmVQBeJphx9SicltQt6LLaiuWCWl9mEtLHuh
         2/EK+hCVmxMcwdDtTsrLkHQRJjm7CbX+JhNr6Yi80Ui7bqmwaItWsFS6m3yJAnFslnT1
         8PUSFpqyj5FKUWuzsm773wIESpZLwqk8wlpaDCEJycajP0KHahYXMDXSgKb+FFuVv2Jy
         GF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3hrsq8ux24YOMvQI/N3uNaK4e6Srnr3G4ObEwjIIDTQ=;
        b=rI9Z1H2pEpBvwNRlHKD5dBfOjsjJ3sqje8volZiJI1cHUT7dSHrrABtzwK6A3wCSog
         6HVwI7wMsKUoVfbDqMBEPyfjnXuI6H8J93EcH6ULwNcI0kVqhtiChiaZdDAznMEqzI/G
         /olqv4RQBpwS48r8uajG3ilWZdMeI/XvETZQMOmC4ZLlC+HDNcV32F8J3XT813oycJez
         MXMKGduD7hE6lbAF4nsgBkUv1xS8TIsghbUw0fSjvJBlb+boniISedWQ8NZmJt/Ke+99
         mFhljutTRKy2iJCG4OgjIamXc8XBec4a7ysb1CcbY+h1OGOZ0+WpOcDlO6fKYWTNeYSM
         4FSQ==
X-Gm-Message-State: ACrzQf2xgzoJ6z8IkCxrYx9LhdvpAGab4buhfC2gjvqNiAMEKF/i870q
        L8r/9uv8Yvo1Bw/1cMA90Wzt+4byZ1yt2g==
X-Google-Smtp-Source: AMsMyM7ABSCOgbWnq9EcoTF+VL1tHsrpRrRC5v1oDAuNzuv7XYM8lw2avVaXhT1OvgPHVV3C8gFmiQ==
X-Received: by 2002:a17:902:724c:b0:177:5080:cbeb with SMTP id c12-20020a170902724c00b001775080cbebmr40432806pll.67.1666732770658;
        Tue, 25 Oct 2022 14:19:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id m8-20020a1709026bc800b00179c9219195sm1623760plt.16.2022.10.25.14.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:19:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onRKZ-006Mkq-GE; Wed, 26 Oct 2022 08:19:27 +1100
Date:   Wed, 26 Oct 2022 08:19:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix validation in attr log item recovery
Message-ID: <20221025211927.GB3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664715731.2688790.9836328662603103847.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664715731.2688790.9836328662603103847.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Before we start fixing all the complaints about memcpy'ing log items
> around, let's fix some inadequate validation in the xattr log item
> recovery code and get rid of the (now trivial) copy_format function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_attr_item.c |   54 ++++++++++++++++++++----------------------------
>  1 file changed, 23 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index cf5ce607dc05..ee8f678a10a1 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -245,28 +245,6 @@ xfs_attri_init(
>  	return attrip;
>  }
>  
> -/*
> - * Copy an attr format buffer from the given buf, and into the destination attr
> - * format structure.
> - */
> -STATIC int
> -xfs_attri_copy_format(
> -	struct xfs_log_iovec		*buf,
> -	struct xfs_attri_log_format	*dst_attr_fmt)
> -{
> -	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
> -	size_t				len;
> -
> -	len = sizeof(struct xfs_attri_log_format);
> -	if (buf->i_len != len) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
> -	return 0;
> -}
> -
>  static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
>  {
>  	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
> @@ -731,24 +709,44 @@ xlog_recover_attri_commit_pass2(
>  	struct xfs_attri_log_nameval	*nv;
>  	const void			*attr_value = NULL;
>  	const void			*attr_name;
> -	int                             error;
> +	size_t				len;
>  
>  	attri_formatp = item->ri_buf[0].i_addr;
>  	attr_name = item->ri_buf[1].i_addr;
>  
>  	/* Validate xfs_attri_log_format before the large memory allocation */
> +	len = sizeof(struct xfs_attri_log_format);
> +	if (item->ri_buf[0].i_len != len) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}

I can't help but think these should use XFS_CORRPUPTION_ERROR() so
that we get a dump of the corrupt log format structure along with
error message.

Regardless, the change looks good - validating the name/value region
sizes before we allocate and copy them is a good idea. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
