Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,URIBL_DBL_ABUSE_MALW,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EF1C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F8822070E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eaHLyxGh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgA2RDN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:03:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgA2RDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wRoWpm9kQz2Qg9hfLGlpFn/iZ6ybSkJL/iFvGLbuu8M=; b=eaHLyxGhHpSyRtTrSckBCO5FV
        2TTapzqkL0Muq/E4LwBCwrmWs37pMJj3LSAAmx/px+hM5iEGW6cM7SgUYvBta3phgkcVZwHvED28h
        1kGtzxCVlwW/iSiEEi+t82ZlKzzbLGU7quS8qYR1TJNw2sgSnSdK+SR28yIuTyuAu8TYge46V9+cA
        OHVHjCHWl82NPJUpibxZ0Ou7dqujDu7cFWRxvdUesYGuDoIJhRN01VR/04S80nCW6BCzt+2IilRLr
        gyCkimzthXMdsAxZlhpxcxxVPE5uo33LG3QkSrUvTdTXBZBvOLuihJiKpydAW5FWHH8fxPm6cTqdr
        6r/pjPL3w==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkC-0006qJ-4v; Wed, 29 Jan 2020 17:03:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the attr interface v3
Date:   Wed, 29 Jan 2020 18:02:39 +0100
Message-Id: <20200129170310.51370-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs patches porting over the libxfs changes are available here:

    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup

Changes since v2:
 - add more comments
 - fix up an error handling corner case in __xfs_set_acl
 - add more cowbell^H^H^H^H^H^H^Hbool
 - add a new patch to reject invalid namespaces flags in
   XFS_IOC_ATTRLIST_BY_HANDLE
 - remove ATTR_ENTSIZE entirely

Changes since v1:
 - rebased to for-next, which includes the fixes from the first
   version
