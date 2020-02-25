Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC346C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 879D620CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fJkpRCRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgBYRoJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:44:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57160 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYRoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:44:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hs1ewHYlmVkfTUfATGN+FlHvA1scD/FaKsQTrLGmOo4=; b=fJkpRCRR1CHl9Q2IZgnDr1qOmM
        A+0ComrkAuUhG4BP1bZuNiFpVnVX43c/LfoRXvRmRWcEPY+KydgS360Z++qzJ8yhSCmFzw3fds65N
        RZIlE1ev5iAelf9Rqam0w4N4v4rlfvsx4OTiYTvKK/BFZlcpSsviNEgwMaIgGTj0/UBK1DkLEUZlZ
        5JTlygGyCwpbhkinI+zJfNAoPBFhFdBjzVGIUsXBj4r+cRCTv1uNW1jib17KnHd/HsD7QBr4KOfd3
        3DJzKE9aM8t+zSygBZYsyvVKRkZnnkJZCbnevpZIIOBJ5pH7hHfUPAmuVJED9pUv4/mBPANLoM8av
        kU1IKbQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eFc-00063C-39; Tue, 25 Feb 2020 17:44:08 +0000
Date:   Tue, 25 Feb 2020 09:44:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/25] libxfs: rename libxfs_writebufr to libxfs_bwrite
Message-ID: <20200225174408.GJ20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258953343.451378.17961363922648690111.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258953343.451378.17961363922648690111.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:12:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename this function so that we have an API that matches the kernel
> without a #define.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
