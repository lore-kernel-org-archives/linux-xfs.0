Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4E2C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08CD2084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LNXbuc1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgBYRhw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:37:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYRhw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EtYd5UMyW/pXrqlTTzQGNFwYUWe7TEQh5aSjbjp7sLc=; b=LNXbuc1Cdxub/YqvQk2vBu4Ft1
        NZJHRG6EpdWKF3auzJVBdQVM5nfbN33eDXd3bugvFhmatNHrdbTv8exqsWXYUjNb/G7qJA84xaLqL
        eGRZ+u51bkCVAS62xKy40jkr3PAa45Ncr+dRg7O6071powysfCrpw9FlMkIshZ+Y8BTaZq1HQAUep
        VzwR0n5cn/nwU4/595NyvAYUxYakS4lFMigiXT5vXn9U1R4ZNcnHXyCCeGG7VQjD+b7tJOmSG8go0
        Nq9Vjd9vJDyun8mbIWY+2Tn7PPJhyxlPBZW5AiY8quwU0dpT1peq/LreAcHlouMPHBohN13QNXifG
        G1qsSLrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6e9X-00013R-Bs; Tue, 25 Feb 2020 17:37:51 +0000
Date:   Tue, 25 Feb 2020 09:37:51 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] mkfs: check that metadata updates have been committed
Message-ID: <20200225173751.GB20570@infradead.org>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258945969.451075.3231072619586225611.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258945969.451075.3231072619586225611.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:10:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that all the metadata we wrote in the process of formatting
> the filesystem have been written correctly, or exit with failure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
