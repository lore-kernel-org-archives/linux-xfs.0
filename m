Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FB6C7EE25
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 05:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjFLF6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 01:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjFLF6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 01:58:16 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D67BE6E
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:58:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b3c0c47675so8763035ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686549495; x=1689141495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YTZupZ5fuhwe5oWEGLyxLiTDe0qwZiw6zObdUvKMWxA=;
        b=unTk3gf+RHm0marizDCUsFWxc7BV5ePJiIWZkm3+JXVdt9MIB1H1m3qgHBz68buLKD
         vK2S7D3sz0maBl3WDwoC1AoUrwtPYxcbk5Pm30TCF4XQl0VUiV6C2KOSLVN7YlANDrwQ
         AsdhA9A95bfPs5H10MeR2FQx1UxGt8ZcBCmmJ8pH+8psaYXA2nmN0f+rOnuxy901iadd
         vvRjU0AZA1zCuRYMGHePL8V57/OpyjFSUGZi5ZMjMNy8pkJfubxnpN+g9v6+vcMrDFSr
         vZK+Mh7gkBhMPKf6uN2jjORpnhCuf5dDA7BiMYSZ5S6WOKEd3HhsN97VQya9XkJ6V7cj
         a0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686549495; x=1689141495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTZupZ5fuhwe5oWEGLyxLiTDe0qwZiw6zObdUvKMWxA=;
        b=Px7h0hKX6X2BbYwfHYopPy19Bd1tiM7mqJzJDhB9Hjyj9FN5uqc49kmPCu6yvRCF5o
         4PiYK10mAHabfqGAQwlNOPGbANnktYoM1YogPOpEiK0HZsaZ0N8MePHcspeR71obE7kB
         ASPI8eqi6rQqPeIDeB9uth53YT/IVlDEVZGuOMSXFioY8tZMg81rNtec0j2vhfgx9u/v
         4b3Pw5PywZwmqj11BV9VsSebLxwiJSK4MGMZNZ3OuyvFhaZkRq67Azt52MjgUUDTdXS2
         ofcl0tt1eYtXcYraiysUiigVZtnHL+DqE8381yusS1RMENghdNo65frl9Hv5+Fa20T5s
         FiQw==
X-Gm-Message-State: AC+VfDyxFFKj8HM9kkx9N52kqCEvWZPC1E0IixconcfP/GeXfNH4flQv
        Ih1vaZ9qJ/qWkAfBdOt4cZU0nA==
X-Google-Smtp-Source: ACHHUZ6K5wqzkjb5ehUQp7Le/opC0wosRy+ULL4l1alQB16ZRvzjHidwNNsHwx9C9dKJgzQKK4kwWw==
X-Received: by 2002:a17:902:c40a:b0:1a9:b8c3:c2c2 with SMTP id k10-20020a170902c40a00b001a9b8c3c2c2mr7074994plk.37.1686549495123;
        Sun, 11 Jun 2023 22:58:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902654d00b001b3c7e5ed8csm1598943pln.74.2023.06.11.22.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 22:58:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8aZA-00Aldh-0o;
        Mon, 12 Jun 2023 15:58:12 +1000
Date:   Mon, 12 Jun 2023 15:58:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set FMODE_CAN_ODIRECT instead of a dummy direct_IO
 method
Message-ID: <ZIaz9Jhfn+dT+unD@dread.disaster.area>
References: <20230612053446.585328-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612053446.585328-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 07:34:46AM +0200, Christoph Hellwig wrote:
> Since commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") file
> systems can just set the FMODE_CAN_ODIRECT flag at open time instead of
> wiring up a dummy direct_IO method to indicate support for direct I/O.
> Do that for xfs so that noop_direct_IO can eventually be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 2 --
>  fs/xfs/xfs_file.c | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 2ef78aa1d3f608..451942fb38ec21 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -582,7 +582,6 @@ const struct address_space_operations xfs_address_space_operations = {
>  	.release_folio		= iomap_release_folio,
>  	.invalidate_folio	= iomap_invalidate_folio,
>  	.bmap			= xfs_vm_bmap,
> -	.direct_IO		= noop_direct_IO,
>  	.migrate_folio		= filemap_migrate_folio,
>  	.is_partially_uptodate  = iomap_is_partially_uptodate,
>  	.error_remove_page	= generic_error_remove_page,
> @@ -591,7 +590,6 @@ const struct address_space_operations xfs_address_space_operations = {
>  
>  const struct address_space_operations xfs_dax_aops = {
>  	.writepages		= xfs_dax_writepages,
> -	.direct_IO		= noop_direct_IO,
>  	.dirty_folio		= noop_dirty_folio,
>  	.swap_activate		= xfs_iomap_swapfile_activate,
>  };
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index aede746541f8ae..605587fefbd3c5 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1172,7 +1172,7 @@ xfs_file_open(
>  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
>  		return -EIO;
>  	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> -			FMODE_DIO_PARALLEL_WRITE;
> +			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
>  	return generic_file_open(inode, file);
>  }

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
