Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D1BC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4354214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bhSMbuYc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKGSQh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:16:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfKGSQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:16:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NDvCFmfuuxItwwbIIM3otQ2jE0OdaXh6osmr540fcsQ=; b=bhSMbuYcc4+UZiBXWHRRwKqKF
        97VG9AvwLoNqxYuxFPEtObdmR8xmClPWwA7Usg5scnycunXz3UWiDxTDnP3uzpX8jbRk+296m8/s8
        cPtUFFnoEDHK+TYW8fpZxMc2voxgTwJESzfWYhzgOs8roj/gjTAA7RmAnRiZsKD3ZA3E5BbLrIMaK
        Uyc+0MImQgsp0QBXOiHbhpKzVbJ2irY9Oxi0lm9Lam/6y/Edi9H8O7OfFYnZu4Db4jYdiNmrB45V2
        ejhSr2X7zL5PFlUTy/MeDIlIR1TygK7cfJRwtk4Peq+1qzxxRI9upcn5eiIia0FELkmZhoQHMa9wO
        GCh5ExP5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmKj-0000oS-18; Thu, 07 Nov 2019 18:16:37 +0000
Date:   Thu, 7 Nov 2019 10:16:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/4] xfs: kill the XFS_WANT_CORRUPT_* macros
Message-ID: <20191107181637.GB2682@infradead.org>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
 <157309572114.45542.3388449920293224134.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309572114.45542.3388449920293224134.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good as far as I can tell:

Reviewed-by: Christoph Hellwig <hch@lst.de>
