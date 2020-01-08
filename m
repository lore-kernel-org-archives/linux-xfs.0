Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3FBC00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A5A2206DA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LCCE89V1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgAHI6k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:58:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgAHI6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l+lIqp6gkEDzFDNgCjU0Ga7bQ71JRj5Yjp1agZEtwBE=; b=LCCE89V16Fl6fBtgDeZBl4G+x
        LT73VUH4BcVF8ur6n2dkkrJSMjuDVJEhlraJPYsFIoD4vmu1EliRGMASRB2appIQK4bVJEnodFdtM
        ydSKTjCm90bI1IMsnpQTMFQMuogGmi3uE6owV+h0kpcMp9hUkkumWc6Y7u73zPL+X7Tc45qKUXnEq
        k5rtlJkhYK4tsKtEVHp3QcRaH0hp+STfX8uNHX8ett1QbZqjH1tGId51KbWEi77ZLzAudlV90tgZp
        jatc7Cb5PoKwYssks0hAvbQHFSmJ51tQPD6PF6G69d7TttpYPXL77OAZXf4B0vJMQ+nwYe7n8WCsh
        bbhTKWjwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip7Al-0002W0-1f; Wed, 08 Jan 2020 08:58:39 +0000
Date:   Wed, 8 Jan 2020 00:58:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] debian: turn debhelper compat level up to 11
Message-ID: <20200108085839.GB6971@infradead.org>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
 <157784177377.1372453.1008055450028015778.stgit@magnolia>
 <20200107142123.GB17614@infradead.org>
 <20200107185151.GC917713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107185151.GC917713@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 10:51:51AM -0800, Darrick J. Wong wrote:
> Related question: Are Debian oldoldstable and Ubuntu 16.04LTS old enough
> to drop the "debian: permit compat level 9 dh builds" patch?  On systems
> with software that old the kernel isn't going to support scrub, and who's
> going to build xfsprogs 5.xx for those old systems?

This sounds old enough to not bother.  And if someone screams loud
enough we could still add it back.
