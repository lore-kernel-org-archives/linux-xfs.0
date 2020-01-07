Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308A8C33C9E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0804E21744
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V3D217A1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgAGQyq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:54:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgAGQyp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 11:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zCD0O6MMtHf7dB7H8lPt9h3YnmSjrvH6kh+Q1XAKGHI=; b=V3D217A1lrP+WoNjrZqDki+uv
        kbrPh6IK6xTJ20tJO9UWrpVzOumPyoYNgxANxsWsIigwQRx+ikdyBgEBLX321bJW4dShjDjp953Px
        SzPaPPsExoNeyORtKBXekYWPh/TZDrcsKUcqJgBc3aIUv1URqgoCDSyNRNBiejqSizxmf/u6939+P
        jTtmpv7ClvREJqljMLqcVqetaSRe9bJj2ykcUj60XYybuCBvAC2NMWGGARVMQPO2YCkHPpNS1ikHN
        99vMpkTp4Bh4BBej2HNurQE+CecJGiHhoS+3J8JaPnFpt7NLCKhzamzxDiYOz+xMWOU8hF/aKgDLD
        6rFALrfEw==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ios7w-0002Ob-If
        for linux-xfs@vger.kernel.org; Tue, 07 Jan 2020 16:54:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: attr fixes
Date:   Tue,  7 Jan 2020 17:54:38 +0100
Message-Id: <20200107165442.262020-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series contains a bunch of fixes for nasty bugs in the attr interface.
