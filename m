Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7902CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 07:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5237922DD6
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 07:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWgfosdA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbgFVHLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgFVHLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 03:11:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ED2C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 00:11:05 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j12so5785464pfn.10
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 00:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chKEpPGjsRcDexCWJCOFD3bTXALnD2xpp9l+1Mh8W30=;
        b=MWgfosdAoeyc9SJKvvGlLE8b7rOzG4EMowG7ggb+Lqg2+Ojanj0F/pXpVt8lMwQOsn
         9WkFu3XIb2EN14S8nOklXIjZ7ZE6zqOropDIw1J96b8EAgDDMv3qe7YLx5g2AOLJdgB7
         QuVx8HGHDrYeUXuAwcL9rH1IoDbCQCO+/neGTXIU0K6vk46umg2Z+uI/RsU6JnYAJvwZ
         9c6361EZwON+YQlPWbV75eZoZCFqGAxoP7OMla7HUaBZvn7M6OUOIQSbMlfBtor0G60T
         gnByQ5EEGc9EmI4wSqI7DynaVjKfpSd97PFQt3YB4RaMoIcTRsAa0pQXmYVK6PEj6fhE
         Rj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=chKEpPGjsRcDexCWJCOFD3bTXALnD2xpp9l+1Mh8W30=;
        b=T773An2hPT0GPbgyaj/L8eg8KxMFMxm5LlwKCNWsdYDB7vI3yZv2T9E+z0V8kW3sj8
         GKTfx2cGEt22oaQ/srFnSk0hlMfVR49k7VlxlrZRIOuRdOqSpgyqYwAujn3G7xTSC76J
         Vl3bJBnDEyK3ezT3ykYfW43Zg+Eov/QK+diIV3vIXscL5BRtBfIxVXqFdoONkAmap6X4
         PznEX0dB/j/Oq48MkF1p+6YWHkoSxT0ZvQGBVj+H1aaAHrpS9rfAJhWsg38xywII6/d0
         rGWKtpbaPzF25aUy7KtB7BiPfzsG9zUzlV86yYqPZI0/B5xGvWZlbsY4dgKAGPAGyHIo
         VbrA==
X-Gm-Message-State: AOAM530v4D4b/vVVZ9Qdnek7bMzU/5JXjw9I/uaHwE9zN6dnvZZMZ43O
        ZvPTJKRBcqgIv8sA+Q5caqgwDXgZ
X-Google-Smtp-Source: ABdhPJw5DyJMZF8N2yjKHevh6G2VUuU70FAB13TFz+GJXKgLs0gHXWAW9VPoCa6WLXhzhSARIzJIKw==
X-Received: by 2002:a63:b915:: with SMTP id z21mr12329045pge.145.1592809864787;
        Mon, 22 Jun 2020 00:11:04 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id z140sm13280919pfc.135.2020.06.22.00.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:11:04 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: don't clear the "dinode core" in xfs_inode_alloc
Date:   Mon, 22 Jun 2020 12:41:01 +0530
Message-ID: <2303717.DuxTXh6FzM@garuda>
In-Reply-To: <20200620071102.462554-2-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-2-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:48 PM IST Christoph Hellwig wrote:
> The xfs_icdinode structure just contains a random mix of inode field,
> which are all read from the on-disk inode and mostly not looked at
> before reading the inode or initializing a new inode cluster.  The
> only exceptions are the forkoff and blocks field, which are used
> in sanity checks for freshly allocated inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0a5ac6f9a58349..660e7abd4e8b76 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -66,7 +66,8 @@ xfs_inode_alloc(
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
> -	memset(&ip->i_d, 0, sizeof(ip->i_d));
> +	ip->i_d.di_nblocks = 0;
> +	ip->i_d.di_forkoff = 0;
>  	ip->i_sick = 0;
>  	ip->i_checked = 0;
>  	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
> 

i_d.di_nblocks is accessed by xfs_iget_check_free_state() and
i_d.di_forkoff is being accessed by xfs_setup_inode(). Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan



