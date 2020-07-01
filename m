Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48A9C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A752074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QrdngjYk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGAIeB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgGAIeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7595CC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UJ3roR/aZ5i1ZOeFiipP24JcEgz9r/F4E46Z3Wzce84=; b=QrdngjYk0umSapNdxkQu+Rlaux
        UK2M7VI2XK1YdLnA/pUqYXtsAadsaLn197sRGJaEgswwjf8rDIVF7qUhYpEMhAs6O3oMHUAbRC/wn
        PI3RVB2xLtk0TqB55YuzIxcgSEjPSzJrCeV/9Fj7iFRQ28uM7j91v50110jqNvxsIYvUFgdlVelA4
        5mbQyR82PsVHjA2a7TBez49ry9T3N3YDW9JUw6pvd38k8I41ahMZhcI6RSeNBmbNDH+pUAv31krDF
        G9gkMa14u22EWefTM9PPs34Ys8KqsUAEtwx+qBgMHx+U0kAZM2ZFVSeeOFDFJ9HQO3j2YxD5KhJpJ
        8GDAp78w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYBq-0006dt-UR; Wed, 01 Jul 2020 08:33:59 +0000
Date:   Wed, 1 Jul 2020 09:33:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] xfs: clear XFS_DQ_FREEING if we can't lock the
 dquot buffer to flush
Message-ID: <20200701083358.GA25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353171640.2864738.7967439700762859129.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353171640.2864738.7967439700762859129.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:41:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
> can't lock the dquot buf to flush the dquot.  This prevents the AIL from
> blocking on the dquot, but it also forgets to clear the FREEING flag on
> its way out.  A subsequent purge attempt will see the FREEING flag is
> set and bail out, which leads to dqpurge_all failing to purge all the
> dquots.  This causes unmounts and quotaoff operations to hang.
> 
> Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks like Dave submitted this as a separate fix just after you..

Reviewed-by: Christoph Hellwig <hch@lst.de>
