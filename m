Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197FBC38BFA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D507A20CC7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MnUHkjCk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgBXWC5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:02:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgBXWC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:02:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tqotj8psWF6s8AozwWiY2OC99/UCq1xiqI2H8HLvyWI=; b=MnUHkjCkpKydmRUbUnVmwdw4m/
        /0JhpqGP18vCq8xMdMHzOeL6Ilfs4zJms9Yk2/jh+voLsrFXTv975SAbD4jcXr5TVwAbukPPqBl3N
        Mk1h8VTxdD7J1g2SJ9hX9QokbuNo7VkbjLygBlKGntVRmAN6TggC87rGP896iPxnxG50QOqQt0fXV
        xIXzUCC6sM1pI+TMwsCA/NG4xPZpJhSJP8hzRj2hMdBRcuvgHGiywqZEYTQQzXdI6l7oFf5bjgBBw
        uyk08aUsDGwlsdoYdN5GP34HF4cDfs6PCSfbtfEu37hfTuFRFaO+1j7yCZ4YHAMKB4UrMduqNKS7r
        DZGCc5nQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6LoW-00017b-Td; Mon, 24 Feb 2020 22:02:56 +0000
Date:   Mon, 24 Feb 2020 14:02:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200224220256.GA3446@infradead.org>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130133343.225818-2-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 02:33:38PM +0100, Christoph Hellwig wrote:
> struct xfs_agfl is a header in front of the AGFL entries that exists
> for CRC enabled file systems.  For not CRC enabled file systems the AGFL
> is simply a list of agbno.  Make the CRC case similar to that by just
> using the list behind the new header.  This indirectly solves a problem
> with modern gcc versions that warn about taking addresses of packed
> structures (and we have to pack the AGFL given that gcc rounds up
> structure sizes).  Also replace the helper macro to get from a buffer
> with an inline function in xfs_alloc.h to make the code easier to
> read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Any chance we can pick this up for 5.6 to unbreak arm OABI?
