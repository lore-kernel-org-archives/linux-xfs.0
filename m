Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A1AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 17:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2D72075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 17:36:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l7oLFjDE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgETRgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 13:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgETRgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 13:36:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9B9C061A0E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 10:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0U7BufH6UNecC0lexI3GDRsWtWHYL9VTZ26+p6eryj4=; b=l7oLFjDElRDgHo7dlvRdVERa/j
        vCpDLEI+Oxk7EmFGckz8nux2GzdGg51in1x78zqlJ2vVUTkatqx/eiGwWDU8qQRfRPQiHU5KMUG2u
        DIeh3K/OAJOpg+Gan8iW0dxsFI/nsUtQ5Tovu4z/Se4OKrrcxZbvZ4mMGBsuSiXkk3FEs0JbHGkr6
        s52wseCXPjF+oBYkpxB6NYpQ00wUtWC7hAMudonupG4LY4e+gDpKfPxMdKZJjPoj3s5U23J9uJh7X
        b4g45Z6P6jGqBj9CETczxNh71NT40HaWRbhY1SMbY5xd3SazIqfoT6dh/+awLiPG482yhIk3wAUWT
        3USK6Ufw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSdx-0003TV-Li; Wed, 20 May 2020 17:36:37 +0000
Date:   Wed, 20 May 2020 10:36:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_db: fix rdbmap_boundscheck
Message-ID: <20200520173637.GB1713@infradead.org>
References: <158984953155.623441.15225705949586714685.stgit@magnolia>
 <158984954380.623441.11000410439582315428.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984954380.623441.11000410439582315428.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:52:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This predicate should check the a rt block number against number of
> rtblocks, not the number of AG blocks.  Ooops.
> 
> Fixes: 7161cd21b3ed ("xfs_db: bounds-check access to the dbmap array")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
