Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E39C54E49
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8FB208E4
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ETRqMlMX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgEJHYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FF0C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=rzkhfQTiHTqbOFzEccShieXTiAIAbYtv5Tpc0jVK/SM=; b=ETRqMlMXFKStp0Um8nwNR098Cd
        FsrEe3uoUVbFBxX6/NhL6HjwpluEO0tbkGIwA9U6SOvGN/HxW6E/u+9o778vJb701Uuik+/Gk4d6p
        Bn+ulb77MG30rcxpsFunFYkSeHC93BWboIwMiJVjkMuISYiLRLnzhVf+S0janod1nEmGgJH4I/yic
        1eIH2loXbwiquK37aSwCYDd+lOmYrVZqr5IaWua6RWYxep3+ULdAc6VCnMf59/hV2sIadHdxmIoH/
        a5DS1M2GuJTX5V9cLO2+PlccenFa6UiVulE+R6LwostQ+sVLWXOUtEGDnDy5eSRAkRrOJQ446Q1Tc
        yCZtSPZg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgJi-0004v0-Uj
        for linux-xfs@vger.kernel.org; Sun, 10 May 2020 07:24:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: move the extent count and format into struct xfs_ifork
Date:   Sun, 10 May 2020 09:23:58 +0200
Message-Id: <20200510072404.986627-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series moves the extent count and format fields into the xfs_ifork
structure.  It is based on the "dinode reading cleanups v2" series.

Git tree:

    git://git.infradead.org/users/hch/xfs.git xfs-ifork-cleanup

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-ifork-cleanup
