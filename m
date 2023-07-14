Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FF0EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbjGNOwD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbjGNOwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:52:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFBF1BD4;
        Fri, 14 Jul 2023 07:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A0A61D27;
        Fri, 14 Jul 2023 14:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFE3C433C8;
        Fri, 14 Jul 2023 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689346320;
        bh=/g/NMXp+YPAKah31qVILgYNkG0Beab0BgAjKSTvzmeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UN5+pcWqYbQxqUq61PJs0lI0KCKcuTAADVNR2sTRG/GvrRruM9H+TxP7hIpH2AXxi
         ORDoHzdE3oHcOzJP4tt+6hfIf79Sf8KkhuGE7/mhKaUyrkesalXe+L/YnPGHj5dXTP
         svwE5p7IK7l3NpaRacLu1i9Hf4oDPltDKWqjLnGufF4QcK/z9yGHZCV8lQx9TbKivC
         osNwKV35ExIVPSpgobbE4L6oei+7L6FE3Rd5vsqVczMPnDQeLQG8UyHJYT2H1oCn9q
         MuTxBfXSDnQmMfAkQm4i0IffaZOB7nIGYBvXsIscdV3W1ttg236Ie9BcRR/Wz8BQk6
         oEPH0WIhMNEkw==
Date:   Fri, 14 Jul 2023 07:52:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: micro optimize the ki_pos assignment in
 iomap_file_buffered_write
Message-ID: <20230714145200.GX108251@frogsfrogsfrogs>
References: <20230714085124.548920-1-hch@lst.de>
 <20230714085124.548920-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714085124.548920-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 10:51:24AM +0200, Christoph Hellwig wrote:
> We have the new value for ki_pos right at hand in iter.pos, so assign
> that instead of recalculating it from ret.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 7cc9f7274883a5..aa8967cca1a31b 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -875,7 +875,7 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>  	if (unlikely(iter.pos == iocb->ki_pos))
>  		return ret;
>  	ret = iter.pos - iocb->ki_pos;
> -	iocb->ki_pos += ret;
> +	iocb->ki_pos = iter.pos;
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
> -- 
> 2.39.2
> 
