Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4823C33CB1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 15:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90ECF2187F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 15:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YnTV0f40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgAOPMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 10:12:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43482 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAOPMU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 10:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yVXhyxPmAp099182WRNIk8f4+pczlqoafhtdBtE4CEg=; b=YnTV0f40P6dZBMqKxiC/C6k6Q
        PWOhT8sURkaTBzIx6Io1ElPNG2b6IpGgq8TJAFkcGyxgNi5IqGY0XdXm9iWQjbHxCNLLfNjBS1pZP
        1VNST8SwIaLy3JgnllUjICxOGSNXuomePlpkuFH/Uauo0loYrvjgBUh1fJ87Vz+OdAvxD/UaMZd8f
        tzp7iMOQWh6O/wKUh9GzMe9VBxb91O/83uemGyrI/t/VR9+unhh8++OaleaLiFvpd0l+HcmqpPDCJ
        t8PFH2+sdW3gp3nV7yrFcGw6mSOjYeAtBPAVZTpri/oANr5kVvN9JgJFKcHof/sWGpzcHdgxKBM3X
        PxI08wxWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irkLD-00038i-R4; Wed, 15 Jan 2020 15:12:19 +0000
Date:   Wed, 15 Jan 2020 07:12:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Darrick Wong <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: 2019 NYE Patchbomb Guide!
Message-ID: <20200115151219.GA9817@infradead.org>
References: <6b5080eb-cb85-4504-a13b-bf9d90e4ad0d@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b5080eb-cb85-4504-a13b-bf9d90e4ad0d@default>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 31, 2019 at 05:25:08PM -0800, Darrick Wong wrote:
> Hi folks,
> 
> It's still the last day of 2019 in the US/Pacific timezone, which means
> it's time for me to patchbomb every new feature that's been sitting
> around in my development trees!  As you know, all of my development
> branches are kept freshly rebased on the latest Linus kernel so that I
> can send them all at a moment's notice.  Once a year I like to dump
> everything into the public archives to increase XFS' bus factor.

It seems like you missed the stale data exposure fix series using
unwritten extents in buffered writeback.  Can we get that one off the
back burner?
