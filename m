Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6E0C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CAF924653
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ATNbGWZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgBUO5o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:57:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58024 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbgBUO5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M1vaq8PmNllQRO/kReJAdpnAp5Cm1J60giR2ulS2Dfs=; b=ATNbGWZE4eGlbH1DvH8DqWOgNC
        /kICoIpodyrdqilIL/d3tD47MRkIfNkEuhnd/jWwCBUo1gbaqtsL4iQXjmaKqyOL8JEGSX8XMaWY0
        ezcnihs+otmCZBNHrGnT83NiX5ry3GDvc5NEwsMzs+2ubqRu55i72vnbE8GybCvk47aR0swtxwq21
        cygl31d0fljliIUUwYowwj6IJnxeSFRn49NxlPgr+DscOeKHEKjOejMQajztfyO4a7zgM5ECFxa1W
        LzkRlclRhQG9pmocrgOw+H7CGn0Dcz+JhyUuG7OuMMNl67B24fgt7CXwIkALz51rBctxJLBl7Xqu4
        Oa/mVmyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59kN-0006X9-6Z; Fri, 21 Feb 2020 14:57:43 +0000
Date:   Fri, 21 Feb 2020 06:57:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] libxfs: make libxfs_buf_get_map return an error
 code
Message-ID: <20200221145743.GS15358@infradead.org>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216308793.603628.12888791331568943049.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216308793.603628.12888791331568943049.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -120,8 +121,9 @@ pf_queue_io(
>  	 * the lock holder is either reading it from disk himself or
>  	 * completely overwriting it this behaviour is perfectly fine.

> -	bp = libxfs_buf_get_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
> -	if (!bp)
> +	error = -libxfs_buf_get_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK,

This adds an overly long line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
