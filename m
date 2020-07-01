Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887EDC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 654DC20775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:22:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uvNDgNRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgGAIWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgGAIWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:22:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279C6C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=uvNDgNRd+JOpfPA4YwB2FBf0eF
        KbStCKuTtkk4V5ESL9PP1+WJPPFCHlIoAYOsYrWV+yV4K7ejIOwRog3UdSFo9NeRQX5UjCwcIjiHw
        6Vbyew/g5PopNA8wkKxHAKquoJ6CqwUQgJC2eCy5Uy7b8Q6QAbdBloY7N6eOtcoSp3bnDlqSJ7BzR
        xhR8U1r3RW5ewCQOg603q1aQjl7MFcAH1lxsm7Ai2xSPTM1KFK2k1vLYIIzY7lYvcobZy1vCnUylu
        oSmuE9J8yw8oUzueYVN7FjfW264Uulcvzkotf1+qJw8wfb4w9HErXsW6A6TakLKsQl5Cv4gBWCKHR
        lC0E/sEw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqY0W-000622-Ph; Wed, 01 Jul 2020 08:22:16 +0000
Date:   Wed, 1 Jul 2020 09:22:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 5/9] xfs: only reserve quota blocks if we're mapping into
 a hole
Message-ID: <20200701082216.GE20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304789231.874036.3844840616429094322.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304789231.874036.3844840616429094322.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
