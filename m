Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E1DC47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D9AA2075E
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKn4Da27"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgEKQcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 12:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728556AbgEKQct (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 12:32:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC134C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 09:32:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x77so4981864pfc.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 09:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D/DUqh27mcxwMWIzwR6aHlHZ8zaqGs4vo9oFIGkTZ3U=;
        b=lKn4Da27KCLDKRk3+Mlsx3bU3Nsz6ZdUoxEKaC9YONsowdnTdRB37cxuc4KGMeyNBa
         21UzjwYhWpoGeJOgjFel4XBPoPbd6nwQvtmBDKuoYWmC/wEIANk9Mc2NBJXZgMisEPzL
         EJ8KvWyzbXcChqDJC8accVfUt0fCjMFBtpX7PPy4s6wyKGZ0tz0PzbbHJxxLEkPFJsd3
         mKhhUHRUpSNtBY2/W9U1ePiOhQ/bFVzcDtreMjypLj8Ue9vX3P9GAfj+vkqWoZXkNZo1
         D3jAKOqd++KvC4C0iJ2c4behCmAgzRd1IoNmNd9cSKhzGa2rOSESFZkzZvEIa+me/OMJ
         gPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/DUqh27mcxwMWIzwR6aHlHZ8zaqGs4vo9oFIGkTZ3U=;
        b=eeXFFKhi0Q7P7CmcjPJFrUeQiXxVRVl/Mf6hz5HD0+sQBDOg2KEBRKWufajyN/KNqu
         ufNJusSNfW+KLxCtXg9Id97xTzOEsVAGbVcnkPjSXHBFp1RBBWOb7UOr0y5j/tOOLLwJ
         A8gSC4yhZ05to7gbRPpH47gAEHu9RIKgQBiUoOWZJuA9eGX7qVUcPi4OlYT63Pqi2rIZ
         JXriKtpJL/3ejmIpxQkSvbUX1S2qSbO2fzkIWMWcplspQtdC6sT+qSRJU0ACHys6CRqp
         9Gdec5fMz6OydxyBSg2yfGMHCoq6+XwgeB+qMrid64w2V1IhKPSP2Fwwjwcpz0zwIyly
         cn0A==
X-Gm-Message-State: AGi0PuYgLHcCV1vp9TLTnscjGaFsSKXYI5dg2q+GzqvQClTl63BZrvEL
        R8MT0DMkhxadJpo7aryc3e0=
X-Google-Smtp-Source: APiQypJM2M3d5jPR6yHTDdB5Z9thgvuOIoyIxfRnxYJdW1mZk0TDGkEzl5Qyg9r2QyvkmvBszgv0RQ==
X-Received: by 2002:a63:dc09:: with SMTP id s9mr14175801pgg.95.1589214768462;
        Mon, 11 May 2020 09:32:48 -0700 (PDT)
Received: from garuda.localnet ([122.171.220.131])
        by smtp.gmail.com with ESMTPSA id y6sm10400336pjw.15.2020.05.11.09.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 09:32:48 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: remove xfs_ifree_local_data
Date:   Mon, 11 May 2020 22:02:45 +0530
Message-ID: <4581909.4UAE70Nold@garuda>
In-Reply-To: <20200510072404.986627-4-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-4-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 10 May 2020 12:54:01 PM IST Christoph Hellwig wrote:
> xfs_ifree only need to free inline data in the data fork, as we've
> already taken care of the attr fork before (and in fact freed the
> fork structure).  Just open code the freeing of the inline data.
>

xfs_inactive() => xfs_attr_inactive() would have freed the attr fork. Hence
the changes made in this patch are correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_inode.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 549ff468b7b60..7d3144dc99b72 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2711,24 +2711,6 @@ xfs_ifree_cluster(
>  	return 0;
>  }
>  
> -/*
> - * Free any local-format buffers sitting around before we reset to
> - * extents format.
> - */
> -static inline void
> -xfs_ifree_local_data(
> -	struct xfs_inode	*ip,
> -	int			whichfork)
> -{
> -	struct xfs_ifork	*ifp;
> -
> -	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> -		return;
> -
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
> -}
> -
>  /*
>   * This is called to return an inode to the inode free list.
>   * The inode should already be truncated to 0 length and have
> @@ -2765,8 +2747,16 @@ xfs_ifree(
>  	if (error)
>  		return error;
>  
> -	xfs_ifree_local_data(ip, XFS_DATA_FORK);
> -	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
> +	/*
> +	 * Free any local-format data sitting around before we reset the
> +	 * data fork to extents format.  Note that the attr fork data has
> +	 * already been freed by xfs_attr_inactive.
> +	 */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		kmem_free(ip->i_df.if_u1.if_data);
> +		ip->i_df.if_u1.if_data = NULL;
> +		ip->i_df.if_bytes = 0;
> +	}
>  
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
> 


-- 
chandan



