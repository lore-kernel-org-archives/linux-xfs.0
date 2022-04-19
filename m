Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EFAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 15:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354020AbiDSPul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 11:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238617AbiDSPue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 11:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F21DA53
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 08:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85B5B61515
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 15:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C19C385A7;
        Tue, 19 Apr 2022 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650383270;
        bh=aBTWC6I1qqcpbYNsTKgQ8WpSSqpRfWlXucrVBJlUJig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GJZNQmO5s/BtJ25+GCxMP7QFy8ZxCPtMyHsemr+3W2UDB8VaZg5Cs/Q3i/XSrlVTs
         LL0tlqG8++KN2R0Ai2zyIRK3lkJAZgy9Xt3jLsTq/BktVwjL78TkCugF/sTUF3GYPK
         zFqj//BO4ZIbBaCRmh0MteMJus0aK3jnEIytRuFMrguEE27KVB0L8OZZN+r+YCKU4k
         kNisKThNzxAgKyr51e558OKQlqpFmkLFgm1xzMAc2SyBvRKLQqGMhg5+TpIItE/iU9
         rykOEISukKKiTwNlGcEAwgBtNU1Bhd9b6xeaRK47UCA3Bh6uWtWDXZpWBHNrVk7P7A
         vFKOD2pCMxufg==
Date:   Tue, 19 Apr 2022 08:47:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: take BB cluster offset into account when using
 'type' cmd
Message-ID: <20220419154750.GI17025@magnolia>
References: <20220419121951.50412-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419121951.50412-1-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 02:19:51PM +0200, Andrey Albershteyn wrote:
> Changing the interpretation type of data under the cursor moves the
> cursor to the beginning of BB cluster. When cursor is set to an
> inode the cursor is offset in BB buffer. However, this offset is not
> considered when type of the data is changed - the cursor points to
> the beginning of BB buffer. For example:
> 
> $ xfs_db -c "inode 131" -c "daddr" -c "type text" \
> 	-c "daddr" /dev/sdb1
> current daddr is 131
> current daddr is 128
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  db/io.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/db/io.c b/db/io.c
> index df97ed91..107f2e11 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -589,6 +589,7 @@ set_iocur_type(
>  	const typ_t	*type)
>  {
>  	int		bb_count = 1;	/* type's size in basic blocks */
> +	int boff = iocur_top->boff;

Nit: Please line up the variable names.

>  
>  	/*
>  	 * Inodes are special; verifier checks all inodes in the chunk, the
> @@ -613,6 +614,9 @@ set_iocur_type(
>  		bb_count = BTOBB(byteize(fsize(type->fields,
>  				       iocur_top->data, 0, 0)));
>  	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> +	iocur_top->boff = boff;
> +	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + boff;
> +	iocur_top->data = (void *)((char *)iocur_top->buf + boff);

It seems reasonable to me to preserve the io cursor's boff when we're
setting /only/ the buffer type, but this function and off_cur() could
share these three lines of code that (re)set boff/off/data.

Alternately, I guess you could just call off_cur(boff, BBTOB(bb_count))
here.

--D

>  }
>  
>  static void
> -- 
> 2.27.0
> 
