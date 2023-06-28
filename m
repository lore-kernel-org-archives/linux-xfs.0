Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EB5EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 17:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjF1Rza (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjF1RzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 13:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DBA26B7;
        Wed, 28 Jun 2023 10:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 036B96139D;
        Wed, 28 Jun 2023 17:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620EDC433C0;
        Wed, 28 Jun 2023 17:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974906;
        bh=GhanquvDO+riqKc8sFuOmdtpeFul1ulOTTxEHmiDq0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KtFMmuNEzDUvGZ66TscohlGW7RVNym3TeWzVPylaCN1xS5rGcaDNB2u40BfPjpri5
         9vifUxITwS/dzS4crt+hvgTXnqrGTJQWAb4WMlpI3bjxrwOgQMTYxaEOC6XDyNAzV8
         CW7h7seRzAiBbJ5uGQrkchhUM3t1lX1CCIU1K1RXSEUl7PpXFf8wVGdRckl+KLbYfe
         ACoQ3lhwzcfRGC6UYPQvWv5qBsmkecMgOLFqNKT1paK6xsTKFcTonYnH7W3XGv9TU6
         Hr6ln9mSUdcC2UI41nHqEKiqB8o4fxINXu6WavySdnmG1J6ZNCZvScnlcGrZWMyygZ
         QOIoFqADQCgNQ==
Date:   Wed, 28 Jun 2023 10:55:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Lu Hongfei <luhongfei@vivo.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource.kernel@vivo.com
Subject: Re: [PATCH v2] fs: iomap: Change the type of blocksize from 'int' to
 'unsigned int' in iomap_file_buffered_write_punch_delalloc
Message-ID: <20230628175505.GA11441@frogsfrogsfrogs>
References: <20230628015803.58517-1-luhongfei@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628015803.58517-1-luhongfei@vivo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 09:58:03AM +0800, Lu Hongfei wrote:
> The return value type of i_blocksize() is 'unsigned int', so the
> type of blocksize has been modified from 'int' to 'unsigned int'
> to ensure data type consistency.
> 
> Signed-off-by: Lu Hongfei <luhongfei@vivo.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> The modifications made compared to the previous version are as follows:
> 1. Keep the alignment of the variable names.
> 
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index a4fa81af60d9..37e3daeffc0a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1076,7 +1076,7 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
>  {
>  	loff_t			start_byte;
>  	loff_t			end_byte;
> -	int			blocksize = i_blocksize(inode);
> +	unsigned int		blocksize = i_blocksize(inode);
>  
>  	if (iomap->type != IOMAP_DELALLOC)
>  		return 0;
> -- 
> 2.39.0
> 
