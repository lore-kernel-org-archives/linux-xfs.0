Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E45C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 963312071E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vg6UYQ6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgBTPjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:39:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgBTPjX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Qxo691Lobys3uHf85gxwAAkYYPZsjNVS+Oz0SDSs3Qc=; b=Vg6UYQ6JHUUALv2SBszEczaiBW
        oxeZCFnAmFqZOAx/ehx1KPWZl0og3Gwz1zJxPlFBVAdx7wZCgz5PhjIROlrnx9B6PzAmO/SX7k+Zx
        AH/9uz49G0VnChGwV+0cWUcaLJMTYW4ssLWtGx94O962KHpKWTANc8MKTNnsWSHHG9iAE7d4ZYBQm
        21pHLNK+FNc0dzXh+PVy+DBlRdl0+GOAdbdupL1/5484PXDRGoKyMUi/+b05/buml/BC5DSJridOf
        2WUAZ8XK2NgWwHHV0A5kGr2r/5/OFFyxi/424kbPPgQbVlCAL77InmYRoh0MN2LcyeaWM9xM5cENf
        o5aNutXA==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4nv9-0001ma-EJ
        for linux-xfs@vger.kernel.org; Thu, 20 Feb 2020 15:39:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: reduce dmesg spam v2
Date:   Thu, 20 Feb 2020 07:39:19 -0800
Message-Id: <20200220153921.383899-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

When a device keeps failing I/O (for example using dm-flakey in various
tests), we keep spamming the log for each I/O error, although the
messages are very much duplicates.  Use xfs_alert_ratelimited() to reduce
the number of logged lines.

Changes sinve v1:
  - use xfs_alert_ratelimited
