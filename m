Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9566C83003
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 06:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A83F2083B
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 06:09:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oic9ZTnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD2GJa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 02:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD2GJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 02:09:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7997C03C1AD
        for <linux-xfs@vger.kernel.org>; Tue, 28 Apr 2020 23:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3UE1hWhV1H0aZ95GqIFoxWrgZ5tBo8faH2od8LnA65I=; b=Oic9ZTnHybJrdRDYKUx2MFFlIo
        mEKndqSCosl/644DHYIAnkdcC+P943ZIuM4YlLyHkAesBxXERlRW8CwaWok8/yegUrIJ9qFwGciZ6
        mDaUVvxbeMa5JhT38vxjR8VHWiRJyzC88Eu6apwjmX0C7NgGcT969y+OybRDJA1EN3tobWQRRNVRR
        8gsXf7s50iN2wNzn9cEIbJwzbGpyjssYoPeYTVoIQGNWmSKPA76VvjKk+ogYabAulfHZhOitZqNcO
        KDJQuN9yNcL+7CI6+1veDI1nA0aVOr7d3ff68k67y0f82Cmuvfz7o6AwmuA/ecEjnnkEaonjZ+1JI
        HsXS+k7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTfuS-0005pO-Au; Wed, 29 Apr 2020 06:09:28 +0000
Date:   Tue, 28 Apr 2020 23:09:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200429060928.GB9813@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <20200422161854.GB37352@bfoster>
 <20200428061208.GA18850@infradead.org>
 <20200428124342.GA10106@bfoster>
 <20200428223422.GL6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428223422.GL6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 03:34:22PM -0700, Darrick J. Wong wrote:
> > I find both the runtime logging and recovery code to be complex enough
> > individually that I prefer not to stuff them together, but there is
> > already precedent with dfops and such so that's not the biggest deal to
> > me if the interface is simplified (and hopefully amount of code
> > reduced).
> 
> I combined them largely on the observation that with the exception of
> buffers, log item recovery code is generally short and not worth
> creating even more files.  224 is enough.

True, the buffer items are a fair amount of code, also called into
from say the inode buffers.  Maybe we need a new xfs_buf_item_recovery.c
file in that case?
