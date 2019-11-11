Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25291C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 07:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB02E20818
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 07:59:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QCxwVowh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfKKH7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 02:59:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfKKH7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 02:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6sfw0T5QkWkxWyCMVy3rt3YcIle1Uq5nY34cbY5FYsE=; b=QCxwVowhI8JmmsEes5qfz60VV
        PR+0QRQM4/6ct99AZEIarOt8ma/ZUN6+D1coP02PcodOFvfwvuRRXk3+TFptQa8hr8N0MG9YX9rL5
        MZMHo+dwier7SIZa34ABudRxSLoM+YbFO3Vgy0JR0K9SMR3mohHand5FMzFf7pZ2Clw0IIlG71KpI
        P0aTI0lhEgeQ1ApNwHfpSceG/OTsm4MFgeNgA/4drLLRZ+K13sYs6KChcT1u/YuZ6uOm8hyj0NFLU
        namO2jdolpAOAmGJpvSzXFeS6ruUVehTytqjX0Jxx0IInFH0bXMOMBdjSkQPu7/wLI/DGz9ULIhsD
        oElRAwLJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU4bx-0001ep-2v; Mon, 11 Nov 2019 07:59:45 +0000
Date:   Sun, 10 Nov 2019 23:59:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/3] xfs: attach dquots and reserve quota blocks during
 unwritten conversion
Message-ID: <20191111075945.GB4548@infradead.org>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
 <157343510780.1948946.16275987302017348487.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157343510780.1948946.16275987302017348487.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 05:18:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_iomap_write_unwritten, we need to ensure that dquots are attached
> to the inode and quota blocks reserved so that we capture in the quota
> counters any blocks allocated to handle a bmbt split.  This can happen
> on the first unwritten extent conversion to a preallocated sparse file
> on a fresh mount.
> 
> This was found by running generic/311 with quotas enabled.  The bug
> seems to have been introduced in "[XFS] rework iocore infrastructure,
> remove some code and make it more" from ~2002?

Wow.  The fix looks correct, but I can't see how we got away with that
for so long..

Reviewed-by: Christoph Hellwig <hch@lst.de>
