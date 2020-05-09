Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E59C47257
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DADC2071C
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aqsjiTfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgEIRIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:08:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416ADC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CNfaJAlkZ5+taG4+UUVfCfpz62h6NDsXWWDBkdrPqzs=; b=aqsjiTfpPasA6iYdYqdct66/Hj
        Fi6OigsylcBB63jhKOrycxWASNnHaGiPOfpjsbtKFr+63Ozw8GUqF5Ek+Bz9gjqMljPdjqeC45mD7
        HzFVB2XTPHXpG0F46EaimrM08G0TNQD2cYo7iIpOW/x4pwYGGVYCJBJW+4QYAIH+CJSLWpKtbQ1O4
        pBetgvj2cZl4ENGK/myDTR28MCx5ikZP43qr7UVv3Ij8dhZPk6pT38QY3A9d4e859X47nVk1jOM0D
        OQ+1H44rlRlimyID0vp/yTVH6r94TSVubBYv/MYLwWzwqbUvnEUMIfIuL9iH1vnBHfmcKkAeyBBnL
        /7w+2yNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSy2-0000sR-4k; Sat, 09 May 2020 17:08:50 +0000
Date:   Sat, 9 May 2020 10:08:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs_repair: fix missing dir buffer corruption
 checks
Message-ID: <20200509170850.GA12777@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904179840.982941.17275782452712518850.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904179840.982941.17275782452712518850.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:29:58AM -0700, Darrick J. Wong wrote:
> @@ -140,11 +140,24 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
>  		if (whichfork == XFS_DATA_FORK &&
>  		    (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
>  		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
> +			int bad = 0;
> +
>  			if (i != -1) {
>  				do_warn(
>  _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
>  					da_cursor->ino, bno);
> +				bad++;
>  			}
> +
> +			/* corrupt leafn node; rebuild the dir. */
> +			if (!bad &&
> +			    (bp->b_error == -EFSBADCRC ||
> +			     bp->b_error == -EFSCORRUPTED)) {
> +				do_warn(
> +_("corrupt %s LEAFN block %u for inode %" PRIu64 "\n"),
> +					FORKNAME(whichfork), bno, da_cursor->ino);
> +			}
> +

So this doesn't really change any return value, but just the error
message.  But looking at this code I wonder why we don't check
b_error first thing after reading the buffer, as checking the magic
for a corrupt buffer seems a little pointless.
