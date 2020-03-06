Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DD0C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39CF420726
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FoxJ86Dn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgCFOwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:52:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFOwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ofhWvA3hhdY0dQz5jfNrT9Ag01YRQj+oFAGjVeABfL0=; b=FoxJ86DnZZnZj+jALxqphL5FMB
        zCPOPf2SW9l+LhHr42vOu6+XiFW1LuJKmZo5k01zHiuQ2RCK4cTyx4Rg2navmOd/hs1iuzSDnkohr
        flbHtKpm4QGQOaP0R9npiuVheZZBZJQyA46D3niKesKC6fMiA3+IS2n4KYLzZnxfWNfSO1U67m3Fz
        mzjeajAz5vr8hfnNAoVqjhpN+ZhIYk6MuCkt63QlygQkjm3XYyrRUdgHpPElcJbPnmkWGR3WzRfxT
        TLOwTcxCQWETWiV+bzpQjBquoImkeXb+DB1y15CYAOXkjCfjoGuHPN5EfJRLnVhNx2S9/m7qOsArg
        nJz9UY8Q==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAEKo-0008Aw-5E; Fri, 06 Mar 2020 14:52:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: agfl and related cleanups v2
Date:   Fri,  6 Mar 2020 07:52:14 -0700
Message-Id: <20200306145220.242562-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

patch 1 is the interesting one that changes the struct agfl definition
so that we avoid warnings from new gcc versions about taking the address
of a member of a packed structure.  The rest is random cleanups in
related areas.

Changes since v1:
 - use existing local variables where possible
