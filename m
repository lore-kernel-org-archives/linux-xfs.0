Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EB4C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1886221655
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TgzSR4i/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfHPGj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 02:39:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPGj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 02:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=TgzSR4i/rOvKiQnpPFJZCcvkV
        qv6bhD6h5K+vzG3TeTSc73CcJhgWKP/U5550wMEkS9V3ugW5PReHRV60dV25BGvS47YvWN2lgonbw
        icB/vv26xQdFYO9X8NAl6TJRv10tTeq1LXlsLpA2Ymg56TymCgVBYdhpkiAK/4V6PmbhjuZ1WdWz1
        0lXd/hVJYp+45cZ082MkHz74rGGk0cjyXQvAbL3QsLlscX6JDSWinswgJX14LhHkyfJoJfq22ibnJ
        5d/FfF+sW4NT0YqAqKQgz6v9UBu23OsVbLVeUHUmm18kWWze3VAB1gPuxCKo5/aYSAR9v5mi6lWiN
        ehJyZVSHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hyVtQ-000229-KZ; Fri, 16 Aug 2019 06:39:20 +0000
Date:   Thu, 15 Aug 2019 23:39:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, akpm@linux-foundation.org, tytso@mit.edu,
        viro@zeniv.linux.org.uk, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm: set S_SWAPFILE on blockdev swap devices
Message-ID: <20190816063920.GA2024@infradead.org>
References: <156588514105.111054.13645634739408399209.stgit@magnolia>
 <156588514761.111054.15427341787826850860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156588514761.111054.15427341787826850860.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
