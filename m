Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E87C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4AAF2063A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V6VybzEg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgA3Nds (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 08:33:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:32836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3Nds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 08:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6TQio/TGgXEK81uA8HfybaNLCKSTiRQmNmqe70NjGlg=; b=V6VybzEgytoVKxrvsbZROOUhi
        ghOdhezurjzTu2CX5sYkIZ5q1DX0ogdV2xSSQtwpLows7RbhDt1mAs80CMNZZRCPQv7o5upljbAO5
        dq8T/16Hckhsw3GkSJz0Bmja6CXpBF+k12128Eb6gqFDDAgtPn/zpEyw1LwpvCQauP/INA/RRZHsO
        dIrdLUPV9g7Vp/08gFDK8bHA0wf42iNQ82tqaXWGItfpnSBJVz3Az473BBDet+XwtBdNaOnde80sn
        dDRAC+uovmjMdHcecckrJaMnibYxVLCVQDWAMd2wFrXiHHPMixl0+nAOq7z9bGOIUr4OdrDYzwXYs
        dpUFd67HA==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix9x4-0003pr-D7; Thu, 30 Jan 2020 13:33:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: agfl and related cleanups
Date:   Thu, 30 Jan 2020 14:33:37 +0100
Message-Id: <20200130133343.225818-1-hch@lst.de>
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
