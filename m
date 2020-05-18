Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48EEC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94253207F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 07:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jBBIwzXR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgERHeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 03:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgERHeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 03:34:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E76AC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 00:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=kP2VEdi9rFvlQpVpJlyDDUCifp+pRhsx6IpJrjhnzTw=; b=jBBIwzXRc9Fw1X5jVTGqeYAMEL
        jt5lHLTw5ykphYMbXgKdh5OzFazhNAL3tc974fKjOxjKde81YANO/cfDPv31Uwd1kl7RFMWcSZ9nX
        LIEkSQXlnjtMEYRtnNkGZcoQJa7tDQTh6PEgwH5PbLWrbzKjUsiU+8ROnaF1m+Z0xi1nJ/HPaOfEf
        si+Z2Tmhm90YKbE2fmTMJq7WKUzucBZGFHgj9S4Z92lYY/ameUjeSOKWAySGv9PrClNosWTh9DWK3
        F8S1VBTo0sLtzFv4G4nt+hTKK8tlf/L03XXUdIacjNg+RihOe/hR8tmfZai05lxoN56KMhQyvSpZQ
        67rb/LSg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaaHh-0002pj-Lp
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 07:34:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: move the extent count and format into struct xfs_ifork v2
Date:   Mon, 18 May 2020 09:33:52 +0200
Message-Id: <20200518073358.760214-1-hch@lst.de>
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

    git://git.infradead.org/users/hch/xfs.git xfs-ifork-cleanup.2

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-ifork-cleanup.2

Changes since v1:
 - pick up a different scrub prep patch from Darrick
 - keep the nextents == 0 assert in xfs_attr_fork_remove
 - keep clearing various ifork fields in xfs_ifork_destroy
 - add more comments
