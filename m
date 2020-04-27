Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC686C55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8410E206BF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 13:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eQxO1ZXv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgD0Nwd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 09:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgD0Nwc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 09:52:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600F3C0610D5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 06:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ZFAfNuWNoOyP15/fTu+sdcJw1ezzamwvnBt580K+z5A=; b=eQxO1ZXvqun5uEqyKP+xddUVtT
        k3v5WqR+9QC7YIBlk2zepdfHe0gk5QuSRsG23ZPp6E4mQT1ciHqjMw92yuYsJkDcjaSaP55DzVuDE
        2jhMJLIhgJiUo3lTkwbDzrSZjlhysU7TfURVcurMQ3/ULsNr0y+o4EJSYCTLiEC/10tDiQ0u/iAiu
        g/X6B4kwsRyJ5BiZur0eOxYQ0avvgHPCQnnXnbB8Wiv8wHFpVfyTUTjnY6+ES2Jd+RiTdIp4qoH+t
        ht+16K+KUBp71tngpt14OBZkMrtk06F+cmtG/hi8aR87Kbbwwk7Zi9LTZCMbHMZkeJTbesw60KUrN
        wAJnr2mA==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT4BT-0003vf-TN
        for linux-xfs@vger.kernel.org; Mon, 27 Apr 2020 13:52:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: two small log recovery cleanups
Date:   Mon, 27 Apr 2020 15:52:27 +0200
Message-Id: <20200427135229.1480993-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

two small log recovery cleanups based on my review of the refactoring
series from Darrick.
