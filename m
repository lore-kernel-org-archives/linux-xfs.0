Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF95C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08A220717
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JGxJFxv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFObg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39404 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCFObg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=MxhQ75zy1zKNsq8NyHSi0DLYEGZENIf2a7f4P+tflEw=; b=JGxJFxv88Q+MvKNofnjIjosvtZ
        Q2AJ492/tBTYX9Tud8e/r3sPp6bTFO2HMTMCvj06oxF1VVkZkSa1+SzgLk+OIEf7h7HjGvfRVLMAU
        /Tmp73L/mh+ADFTWOHDrxYwNnE6uHevJB9rSP9tl8TyB9KMqDqge5Bp/qvlc8WZeNVerjIf7nufOw
        xxIBryO6jrvvwHliyqTv4JfWNC+ItZBxwd6GY8933TyaaLW+c+EXpQ9TIcNjLQZlejUh/tnD9a4Un
        9RGB8YoeDl6XHmJ31GswF1J9VA7o5BsqKPOxK1R6Iti3nqeuRE4Zc8NVrUsakGnf9Py7qkiOq+bhp
        L3duK0gw==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0l-0008Gn-7Q; Fri, 06 Mar 2020 14:31:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: cleanup log I/O error handling
Date:   Fri,  6 Mar 2020 07:31:30 -0700
Message-Id: <20200306143137.236478-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up the XFS log I/O error handling and removes the
XLOG_STATE_IOERROR iclog state.  There first three are pretty harmless
cleanups, which I think might make sense to merge early.  The others
are more invasive and sometimes change behavior a bit, so careful
review is required.
