Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E90C54E49
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E39218AC
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D5uQk34p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgEJHZN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHZM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:25:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA0BC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jIV9WNzdJcEVnZtaR/Q0dR1TohLXhAYIfBZPpl+2JbM=; b=D5uQk34p8koTEaPB7t+bLnJJmz
        WS00wuiLGAsEOdZKKr3HRspZ6Wp15Ciia5pUp9WWD/CCfFg48rB9U8s5w2+HqW/kDJY65JOLbhrWu
        P/Fd7LgOoPwen677OYIHYfnPR9c8vm06Hydj9eQeEAByREVfkyI86z7nt5X9/wSPuZeiFb+L2NHt4
        QbQk/stPzNg6TIC6Nph3ewlGwMJDMU6gKDl9XIRwB2hR3uGMm2nDsIRK9T63Re75ZUOZHmvP1VExj
        NPgGLWhyl/ys83/FambMe7mUxWisgl0ek4rDUZkqEmp0h98+B1sVcSxs8YQ7c2tUqqz+X6BjH/jPG
        LNJUtgXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgKm-0007NI-5D; Sun, 10 May 2020 07:25:12 +0000
Date:   Sun, 10 May 2020 00:25:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs_repair: remove verify_aginum
Message-ID: <20200510072512.GC8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904187403.982941.11165171953121545705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904187403.982941.11165171953121545705.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace this homegrown inode pointer verification function with the
> libxfs checking helper.  This one is a little tricky because this
> function (unlike all of its verify_* siblings) returned 1 for bad and 0
> for good, so we must invert the checking logic.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
