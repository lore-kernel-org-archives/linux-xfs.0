Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53492C10F14
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D74D21721
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LE2p20Zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfJHHA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:00:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbfJHHA4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 03:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vYJQ60I/CIdmk2+j28VtQwfOkVuDtxgRlxs/CxBtiKs=; b=LE2p20Zi9zm7Feo3sG9a/6zkd
        PqQ6ZW25mesYVEoYkrsqY8gZFgNwinOxrqj26iILqR/4v5pNjq8f2Yvppx2qXcVjXO2Z6TMPKQj82
        cNxe6l0sTAG78SbSIVJlGo6G7iS6tb86XRZOXI4a5Bg0VG3/J2WAiFFsnh+jVGURo3vmyL+GkcETD
        UofVtjMu2TM8p2s54agU7Lt7AU8c2n0+jCtw3ftRxl7Ua5d62HDmc7+aaACoezTeOmWdLOMl2+dsd
        ItTbHjRUOuxpYz8+oeOQHiualyamDUk/ZyuQ1DUyPmvRBgy/lpOjLX1vWaZtyJftqD/sjkGksHaVj
        U+6Bv6VGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjUO-00071V-Dp; Tue, 08 Oct 2019 07:00:56 +0000
Date:   Tue, 8 Oct 2019 00:00:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] xfs: move local to extent inode logging into bmap
 helper
Message-ID: <20191008070056.GC21805@infradead.org>
References: <20191007131938.23839-1-bfoster@redhat.com>
 <20191007131938.23839-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007131938.23839-4-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:19:38AM -0400, Brian Foster wrote:
> The callers of xfs_bmap_local_to_extents_empty() log the inode
> external to the function, yet this function is where the on-disk
> format value is updated. Push the inode logging down into the
> function itself to help prevent future mistakes.
> 
> Note that internal bmap callers track the inode logging flags
> independently and thus may log the inode core twice due to this
> change. This is harmless, so leave this code around for consistency
> with the other attr fork conversion functions.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
