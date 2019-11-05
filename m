Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B141C5DF60
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 15:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F234721A4A
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 15:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nhf5BZZH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390031AbfKEPul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:50:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52976 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389571AbfKEPul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 10:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CvvrLs7de+/MEFP5OR3wdXPMuFLLcKrYjsaaOBUXDKE=; b=nhf5BZZHtXswdp7iVR8W2WScr
        iveZZbRMVc93wwZQPtft7cHqj+jKOUSbaVZiXV0OLVgBIiAzpqLxRAYMRPIg3SOvSmUMwR3kebFS7
        uWTD73fURWD7Adv4lhN6ZIBPsAcB8KJI8/qbCtALrNkAp98R+VfEU1PkbtDlfgwhGbtxMuk+obK6i
        258cizZ66XvzLC7VYCWUGtqtwZxj6ujMmc0Klp1Er6CmtwDpEvr7D59GMlU+BEH2d/yyK23cfoPd2
        vI+LQn3LFiaXWFEC1IkR890As2/8qnoQcBvTjYHianzTqnpZEbIrTWRPsJwbssrsrppb6gVtIKuPE
        F05N295CQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iS16O-0006kb-Un; Tue, 05 Nov 2019 15:50:40 +0000
Date:   Tue, 5 Nov 2019 07:50:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/6] xfs: make the assertion message functions take a
 mount parameter
Message-ID: <20191105155040.GA25872@infradead.org>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281986300.4151907.2698280321479729910.stgit@magnolia>
 <20191105010935.GW4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105010935.GW4153244@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
