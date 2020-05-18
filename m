Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D7CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5F28207D8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n4kynD5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgERREl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EB2C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ZqiXAUdWnjWF/gmOHfGgPxeZqPxwh2sbgeQE+s/6VtA=; b=n4kynD5lyRBXk+V/jXo/cLemJO
        QtYPxO2mG0BpH9iTFg2IgmrGM9kvntc6teOTVVIAYbU1jB6orodquB0guCySLbbsommH3SGlsRWUu
        BqbxBtgwPyubdwfRuEfRadg+OgztrmyMveHbI8Ftf4tBv6+JUP2UrgF2sMFt7E7YzwxkCZTK3yrwd
        tlopCfJ9w45oZcfbQUn/6v1ICsP26IQ5VxE+PL8B3M6xk1vKBIkeFDWgoJ8hc5iJg9oYw2cOpvelw
        TlHtzwREpaSlhPFYlFu8sRORkdGy+gcZvqyH1LnwHlzTeKuNdspPBAU5EYwdD1zECHPPeSXC+KORH
        pvzHEJzQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajBw-0001vZ-In
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: inode iterator cleanups
Date:   Mon, 18 May 2020 19:04:31 +0200
Message-Id: <20200518170437.1218883-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up a bunch of lose ends in the inode iterator
functions.
