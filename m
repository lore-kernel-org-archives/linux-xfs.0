Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6EFC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F9FD20775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e3QtPMnA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgGAIek (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgGAIek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD75C03E979
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=e3QtPMnAHbKVdGCnAux6RsPIxo
        OqP4/4agw8L6mDE87741LAHpJc7eTcoPRtUEgCBDEuhw/wGvRKaKhqhDkVE3+z+/0+T32TxK5Pvc8
        mrb1U+tQEgqx9EuWFBAoyEU8LW8WI6lxvz5A/ruzTaocQ9Xn2zsIkcOQTIBT/mjL5KNLfh4EhGY38
        ChejEOr4CN4qDZ+6ld/3X+9ex5ZopropNglESu/mKECCJb3PyfbVX9pYz5lMt39ORFPhh+64GfWeA
        HbVMz+ujng5pSk7jrlbetSebxVS9IoCmgVBqHisaF0ybv2eqXBuRb3t6RLBDmd16zwKmndg1KVmfh
        osIN82wg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYCU-0006gQ-OW; Wed, 01 Jul 2020 08:34:38 +0000
Date:   Wed, 1 Jul 2020 09:34:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/18] xfs: fix inode quota reservation checks
Message-ID: <20200701083438.GB25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172261.2864738.3201442261854530990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353172261.2864738.3201442261854530990.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
