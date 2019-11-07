Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795A5C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ACC821D79
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ge+yePvI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKGIlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:41:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbfKGIlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:41:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xh9BSvcFsiFfc8npwFk5+N/WRsSz8y1uyCZ0gKUivDM=; b=Ge+yePvIYqthRjjuHj+P2BS8s
        N2wNcnHuwhYe3DfCdLg7OcXRPFJNWYfZSWS3/IyGKEyMUJT6sCWxCh+ORQeqBpo+F1cgEUEVlue9o
        Xs/qEFYZIOdEegyiGJNdVFfzzy4m1uoRjipnqwceVADnO/W45wh5IlTMwkOi3svt/Dtkuxv+FMmYx
        I9tAMI/l8V8Z2r4inW9quriuqCDyUlsHYHZkxQm2ci2Zty7nTNZxO+y5r1kNt76g/lo2ZKXQvmrfQ
        3833t8mEFv+N/u3lAN5mIgVKkn5hwkXLlQLxviPA7XyvrF9oiw/er8DJsZwbmm16am8TcY3LkTOSs
        7CLdJqPtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdMK-00072T-74; Thu, 07 Nov 2019 08:41:40 +0000
Date:   Thu, 7 Nov 2019 00:41:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: null out bma->prev if no previous extent
Message-ID: <20191107084140.GD6729@infradead.org>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309576896.46520.15012779727563336898.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309576896.46520.15012779727563336898.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:02:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Coverity complains that we don't check the return value of
> xfs_iext_peek_prev_extent like we do nearly all of the time.  If there
> is no previous extent then just null out bma->prev like we do elsewhere
> in the bmap code.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
