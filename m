Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94EDC4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiDSSiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357538AbiDSShi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:37:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2890D4E3B6
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C97CCB818CE
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 18:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8847AC385A7;
        Tue, 19 Apr 2022 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392955;
        bh=ZMUJ9pkMPgy8z7eHPEqgCuMf3kjN7jFNZC7zgFlk9yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJ7qfwWXCvJANdZeNzR94kHm56RYEgy0x3oBnZ+oNrmR++TGQrTeevNZdU+CMg9y1
         xUDnVmXKC34ymCpv5XFSgYCvQisaW8lewjgEuOhCNCmNXI2q63ldmyyFImCP3pLwsz
         ewTQFMJXgEyhZO1mrdUEOEKzZqJrWdcGKqPUUjQSizbqLS3N722Px0XYWxd0asFK+h
         ZivnaZaJf5tfDkuCd8gdxGVuGLPW1PDHwVq3gGJWp/QEaXQ3BqsZb+rbZ3g/iXHPe+
         TWQxytnFqVph5/TaIdeNOT0EiRNGdUXj9JFi57muGWge/q7fOnvhSxWQ4KA1EUU2GL
         JUEqIRGxQNNmQ==
Date:   Tue, 19 Apr 2022 11:29:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_db: take BB cluster offset into account when
 using 'type' cmd
Message-ID: <20220419182915.GN17025@magnolia>
References: <20220419180038.116805-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419180038.116805-1-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 08:00:39PM +0200, Andrey Albershteyn wrote:
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

LGTM, thanks for fixing this longstanding annoyance :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changes from V1:
> - Refactor set_cur_boff() into separate funciton
> ---
>  db/io.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index df97ed91..5aec31de 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -73,6 +73,13 @@ io_init(void)
>  	add_command(&ring_cmd);
>  }
>  
> +static inline void set_cur_boff(int off)
> +{
> +	iocur_top->boff = off;
> +	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + off;
> +	iocur_top->data = (void *)((char *)iocur_top->buf + off);
> +}
> +
>  void
>  off_cur(
>  	int	off,
> @@ -81,10 +88,8 @@ off_cur(
>  	if (iocur_top == NULL || off + len > BBTOB(iocur_top->blen))
>  		dbprintf(_("can't set block offset to %d\n"), off);
>  	else {
> -		iocur_top->boff = off;
> -		iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + off;
> +		set_cur_boff(off);
>  		iocur_top->len = len;
> -		iocur_top->data = (void *)((char *)iocur_top->buf + off);
>  	}
>  }
>  
> @@ -589,6 +594,7 @@ set_iocur_type(
>  	const typ_t	*type)
>  {
>  	int		bb_count = 1;	/* type's size in basic blocks */
> +	int		boff = iocur_top->boff;
>  
>  	/*
>  	 * Inodes are special; verifier checks all inodes in the chunk, the
> @@ -613,6 +619,7 @@ set_iocur_type(
>  		bb_count = BTOBB(byteize(fsize(type->fields,
>  				       iocur_top->data, 0, 0)));
>  	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> +	set_cur_boff(boff);
>  }
>  
>  static void
> -- 
> 2.27.0
> 
