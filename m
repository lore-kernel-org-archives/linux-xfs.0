Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32326C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B2A2080D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l8Sh7WyV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgEFPVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgEFPVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:21:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF0BC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l9wkD4wCFf0cqriYntC24klCaR2wX8dnYwlo3M0L57g=; b=l8Sh7WyV4mJ69cLntb2qn5wUP4
        LvN5TMcCa64wRS0+vGbJH4gNe2nYEoecvbQmOZoKnlevu4TncuD+vzAcBHO6pBkT5BA64Lu4/g1it
        B7M3rbT8A47oXuJ2f1aDb8DRApdKh53Dgnt/J7woWG6ra2/ymQLv8K73HZCZeY7+wf/e8HtnteMLp
        k1o6E01FRU+iExZ/UT0hDk0ZPJkK2zP6wp8IucTwAgH/1gU+OJIK/BLRODpaxMgEvCcb14HGlWpDQ
        K0+DpgLczIw2UxlUQgxwRssuUynUoPLlxOVbr/3+DySnYLiv2xlgHpCbyOPQ6HG3o2ZYRNGO7JR5v
        NHSlpP1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLrK-0003Q3-7n; Wed, 06 May 2020 15:21:18 +0000
Date:   Wed, 6 May 2020 08:21:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/28] xfs: refactor recovered BUI log item playback
Message-ID: <20200506152118.GV7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864114272.182683.11138860973756666002.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864114272.182683.11138860973756666002.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xlog_item_is_intent change needs to be documented, or even better
split into a separate patch.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
