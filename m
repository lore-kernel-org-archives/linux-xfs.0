Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB29C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2E32073A
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EcUXxwfF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgGUO4h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUO4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:56:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A938FC061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GY+0bUFRLYQWzVgA+I+Gu3QEGLEyJdUvaH6M4NLVdTI=; b=EcUXxwfFLoGYC47OAClhhd9T60
        7+oeOAlt+OTbjzVA3HxHXw39mXQQ1dvVOdx7fXDYVrt4/KlXQaBO4+77TgEP4AvNEt0UP7bgMzH17
        60c5EdvR5uH2kpez7O2f+fJ8gDTLGPf8eLa6pjHd92pce5mT9BRnG3QxKZOhbzlcsbXkGIOImNt2U
        6sGLNy6oZ7GuThZW9+MOA4WREWsAEi+C8LzB4bKwFTYe0Ec2Rb8zQ3X7LzpamnvSyLnZ+BjFQYI14
        dD9roGA6SWufW12IwNWpJdDnm2fY2A+B4uXWipuzprNWo8AT3jLTtrF445ZCIT25eDA+UBjsMG5J+
        rRf1otMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxth5-0001oi-7y; Tue, 21 Jul 2020 14:56:35 +0000
Date:   Tue, 21 Jul 2020 15:56:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: always use xfs_dquot_type when extracting
 type from a dquot
Message-ID: <20200721145635.GF6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488195772.3813063.4337415651120546350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488195772.3813063.4337415651120546350.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always use the xfs_dquot_type helper to extract the quota type from an
> incore dquot.  This moves responsibility for filtering internal state
> information and whatnot to anybody passing around a dquot.

Looks good, especially with the minor nit that Dave noticed fixed:

Reviewed-by: Christoph Hellwig <hch@lst.de>
