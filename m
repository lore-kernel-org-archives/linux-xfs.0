Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8C0C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 099CC24673
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="swx9XM/m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgBTQIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:08:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgBTQIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PSD95E/5nOio2I64Rg9zUcEs1lPAbzeAuwNLTIjTQnk=; b=swx9XM/m86RZZK3DD07OXvMC65
        WKcpWf4L7uaNrS+msvs3nsYkb3YL2EyeoXYIwEFpkkcDgxMVnFHewdWtfnNRXex7yYQk7d5IWvZcC
        Q3gNr+BqZ3eS3a/G03zNfUXT+P4ll4TU+pQY83/fPSPWXpOt8Py3ef5rTV6E9NWqA3vqTwveQUrRU
        Pi8dG1sGgEmEe5awYKSepM2KfoL2Qwo38tFORCK9/PLLbCZUf8lTX4ViCxtp56R6qjsxQqzn49bm5
        FSAB/WDrs+2vRyw4YY+000EOSmSZLh4k9H885g/lDY7zZL8AUD9xxXT6cvIfrTfUOFO78BD8yG1EK
        AaswhsrQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4oNA-0003tW-Ta; Thu, 20 Feb 2020 16:08:20 +0000
Date:   Thu, 20 Feb 2020 08:08:20 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        paul@paul-moore.com, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
Message-ID: <20200220160820.GA14640@infradead.org>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220155731.GU9506@magnolia>
 <20200220155938.GA1306@infradead.org>
 <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 11:06:10AM -0500, Stephen Smalley wrote:
> > The dquot_* routines are not generic quota code, but a specific
> > implementation used by most non-XFS file systems.  So if there is a bug
> > it is that the security call is not in the generic dispatch code.
> 
> Hmm...any reason the security hook call couldn't be taken to
> quota_quotaon()?

I haven't touched the quota code for a while, but yes, the existing
calls should move to the quota_* routines in fs/quota/quota.c.  Note
that you still need to add checks, e.g. for Q_XSETQLIM.
