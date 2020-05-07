Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2C7C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645BB20736
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sabrxzDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEGMSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:18:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3798EC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VRVw9TYGyYIzZYvqoAUAb0ZcvlL9s7Ih/FazByBNELo=; b=sabrxzDcWzN1gMYpFxJfLjyhuR
        lD/Us5IN2pWGqTbrGyNH2TP6xuhJVScavHmaLeCBY0FgrJoY/52FVMXtskVzpswxFN8Dlgeza1e+H
        VPTnTl5/Ip/3tA5qNxN9IDvxyTbAJN5ExJbzgUZDYsxkx8jFE0WIixJbGayLpQBi15Em8m4mX1nNy
        iOoaqnluZyc2WD/NPRhd9/H1PGx8A97VfTyr3iPBKSMcdNZjsxLQ0/8wohGDBe7Ee5OuxU8jO0Ned
        yF3ybpCYBSOv7NanYl8wnxp5ub4VlW2z+DGMbYrMBKiPPG0mrkMRiyCEq8PdRCU+xj7z5igV/xi8O
        AuQTZAhw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUM-00052G-Dm; Thu, 07 May 2020 12:18:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: libxfs 5.7 resync
Date:   Thu,  7 May 2020 14:17:53 +0200
Message-Id: <20200507121851.304002-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

as I've done a lot of API churn in 5.7 I though I'd volunteer resyncing
libxfs for this window.  This series contains all the patches that
need to be ported over.

There are a few issues, though:

 - with "xfs: remove the di_version field from struct icdinode"
   xfs_check fails after various tests with multiply claimed extents.
   This seems like some weird race, as neither repair nor manually
   running check finds anything.  I had to patch out running xfs_check
   to get useful xfstests runs
 - but xfs/017 manually runs check and also still sees this
 - xfs/122 will need an update for the xfs_agl changes, I can send
   that
 - xfs/307 and xfs/308 now print new messages due to the ported over
   AGF verifier tightening

For now I'm a little lost on the xfs check issues and would like to
share the work.  Maybe someone has an idea, otherwise I need to keep
on digging more.
