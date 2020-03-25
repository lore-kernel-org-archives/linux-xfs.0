Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D426C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 07:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4517521582
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 07:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tqlrc495"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgCYHNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 03:13:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgCYHNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 03:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZJs21eyWAj1NQ/N/ngtAmBnwNuBf7PkmphY9IJqZkmY=; b=tqlrc495XiHHd9FoJXoo5kA4uj
        QVuLF8Ak1X4KpFWSPsW+fpy7tTlLemV7mBlSmvFtILRlSbmo+XNh1WGMhcQivO5hCD7XD1xcP7Q0Q
        R5756U2VWySP5nj7W0HK5ZOtAAyPj0NamogDB5iDkrpRYPfNNa8PXSNBL2TQQanhQci3WOnok3lB3
        vMBJcWiCHk4DKcOzqbwMZnFYMyHFblK1dTWAk6/8MuKWdhGdc1XmPEQwyeW/7FQ7uiti1viqsi7Y+
        5/HFTIBD5W2EDjXIVvlq0QWPBzGfIWWj35R7jLXiw+GHtj2VDu6rU4gt0JCpzfyi1wK0/D0AiJC7H
        PlILpX9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH0E2-0006VG-4L; Wed, 25 Mar 2020 07:13:18 +0000
Date:   Wed, 25 Mar 2020 00:13:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: preserve default grace interval during quotacheck
Message-ID: <20200325071318.GB17629@infradead.org>
References: <20200324210146.GR29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324210146.GR29339@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 02:01:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When quotacheck runs, it zeroes all the timer fields in every dquot.
> Unfortunately, it also does this to the root dquot, which erases any
> preconfigured grace intervals and warning limits that the administrator
> may have set.  Worse yet, the incore copies of those variables remain
> set.  This cache coherence problem manifests itself as the grace
> interval mysteriously being reset back to the defaults at the /next/
> mount.
> 
> Fix it by not resetting the root disk dquot's timer and warning fields.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, although a comment in the code about the special nature
of qid 0 might be useful.  Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
