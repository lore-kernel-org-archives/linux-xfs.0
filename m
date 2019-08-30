Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D433C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 164C621721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gjfe8Gqa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfH3FhV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:37:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfH3FhV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6A5D5n4as+RLhjD7IzB/hCU5xfcTxaIxONW3roni/AM=; b=Gjfe8GqaEkVPz04gWrDJ17jK3
        BpT3gPt7e1zml7cMPX+mdmSfmBBF0Nt8s3bGaXpywhokh5e+9pj+WEfr87hUayOMKEalf+cNgBioj
        yFRAdMxs6CMQQk/q9ufLMhfvM+ZB0kSMsALRJMcvYgMxfyizMMCofbGeqzby8Cb/xXOstEy1m2X0m
        O3ACm7cp2hPKA8w0syL1zyftDgVYWJE/bPSq/tOxJhbV7Cr8w8d+lvcOgGVFv926J7ft0IXEC5bQq
        kUl4f6xYSJ8vIWAA0AiVI3ypC/RhI3aZ9Wy0XH/O4K4Ytsvu6tAXUT8leIIRE5KgWTOMYt8sKDV4m
        JDVn8TPeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Zb6-0007Oq-Fr; Fri, 30 Aug 2019 05:37:20 +0000
Date:   Thu, 29 Aug 2019 22:37:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 07/11] xfs: remove unlikely() from WARN_ON() condition
Message-ID: <20190830053720.GI6077@infradead.org>
References: <20190829165025.15750-1-efremov@linux.com>
 <20190829165025.15750-7-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829165025.15750-7-efremov@linux.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 07:50:21PM +0300, Denis Efremov wrote:
> "unlikely(WARN_ON(x))" is excessive. WARN_ON() already uses unlikely()
> internally.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
