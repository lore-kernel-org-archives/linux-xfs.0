Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE48C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4203020729
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nKgELrB/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGUO7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgGUO7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:59:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29B0C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IlyK+n37SuRE2cA8WKjSbqTyu4j/DGu+kB7y9eQdGJg=; b=nKgELrB/g8LVGCsQTTGpUR8fj7
        Rnynh0eIudPmKEm9CmT/KaRNKNE7RhRU9qoVQ6Es87lY09s54qn9G2pvaZHvvUdKyiEkDXKHU45f9
        gjuo6IRT2dIamnSKS8tiTM1DgGtcYV8n3er0NStJtN9y5vPT+LPnAGZppCLiYFTUsImvD/aFsNyoL
        wAx0XdBVz/eFnczfwkbDy4A8FOx68ilS2k/KnxwF7ZHYJ9lKafNr50US/KvhJ2AhzyChFPIk9uxmB
        rudLqDuJwCDZ5W92KuKEn0BPl8ZcH2wtQOgcgq/zSJ1s9JmRaKLZnEosMdGtqjxWb+PiRhK7g8SZb
        Vh4tAA7Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtji-0001wV-Cp; Tue, 21 Jul 2020 14:59:18 +0000
Date:   Tue, 21 Jul 2020 15:59:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: rename the ondisk dquot d_flags to d_type
Message-ID: <20200721145918.GK6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488199070.3813063.17484927860165624202.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488199070.3813063.17484927860165624202.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The ondisk dquot stores the quota record type in the flags field.
> Rename this field to d_type to make the _type relationship between the
> ondisk and incore dquot more obvious.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
