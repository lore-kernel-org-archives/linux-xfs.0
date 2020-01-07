Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900B2C33C9B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6641624676
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tNbFIZJw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgAGOVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 09:21:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35806 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGOVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 09:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=G6/+ftKN1FAX7I9VUFeGRcELkt7QhzNGy+lLfAVVhwg=; b=tNbFIZJwbSfE82LtbEmikZFG1
        RILAACsGK3Ngw6IuiD6bTsrgJ8GLAmFVkJJ4IJlkpKEp2vUiovGdobMtmPzjcArWvnq4HbTnOMlXU
        S/raySu/p5XC1jxaoiOYQtjxFD/hf/7yXiBB5yLYrAvUroMNWI4QCSkZTAdtDreeSOHR+apbLFpTy
        6UxeGRaHU+WGzEa0gdG+VvrE4RZcyOtFWliccIQW/4jXGnML13Rgb+LUg29HLF6JIWJMUJAHre1BW
        5avYKKHIDM7QRCGUY4QW8ShwD6xB7RBy+ScXZathFoxuo4o8E5cjBnZrapcH8xXAGPQibzv02NWUh
        46Wb7SUeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iopjX-00062q-JQ; Tue, 07 Jan 2020 14:21:23 +0000
Date:   Tue, 7 Jan 2020 06:21:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] debian: turn debhelper compat level up to 11
Message-ID: <20200107142123.GB17614@infradead.org>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
 <157784177377.1372453.1008055450028015778.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157784177377.1372453.1008055450028015778.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 31, 2019 at 05:22:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Upgrade to debhelper level 11 to take advantage of dh_installsystemd,
> which greatly simplifies the installation and activation of the scrub
> systemd services.

The subject and description seem upside down.  You want to use
dh_installsystemd, and to do so you'll have to bump the level..
