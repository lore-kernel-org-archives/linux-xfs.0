Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B64C33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C3522053B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CcyLc+mS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgANINF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:13:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgANINF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uLALMNyT+stZslPCitSu1kQcB6dmBra6SRa/QRjoB/o=; b=CcyLc+mSmO+H6yATfH+n02xwk
        68ips7YQ8hZDjDI3UpFAEeGRDHaeIVBW1rWWCIUxdJlAXu/XGiGced0I0j2BMnn6pz5j0NE2wgZoM
        AthNE1TaFawUeRfw/pDUD8XYSzAn+ZcU/C4ceGL8pPMB10XBKuQNnEC6r3AqrSdsonOr3r6mBWdg9
        ypHP4c15EDdBZ+SV4Jo/LVNWZVyovJvuxStxmf7PR04LPGwFgEoxca5r6yk0wTS6avP6QzZgf6OID
        ROa8UrXfpCwupAzCCtjHDnCUhFMCr2FveQdccio/q9UrtZjB8SnpO+FnA2zHDH4LRP8ayM8r1caJY
        322jv6Veg==;
Received: from 213-225-33-36.nat.highway.a1.net ([213.225.33.36] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHJw-0005YO-J1; Tue, 14 Jan 2020 08:13:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the attr interface v2
Date:   Tue, 14 Jan 2020 09:10:22 +0100
Message-Id: <20200114081051.297488-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Changes since v1:
 - rebased to for-next, which includes the fixes from the first
   version

