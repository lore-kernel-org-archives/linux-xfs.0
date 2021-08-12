Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D6EC4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D207C60C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhHLIpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbhHLIpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:45:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8F8C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=4sbYaBVCjfnqFsbI69EgaGotuKy4YrYWLbnfACNkSCM=; b=W70ajQk8GPfif3ba3d3/+VjCQ3
        ydUnaU+GpVKafSCUr4giO2rvbNd/znOpEbFcVbL6M1j3VRvdUb4gkAhu3Zj5SHZaRBEZwTzzVTa5X
        DWAAMNvvxb0Kf6g0BwCV7EBx9DoMx5wkBcXj1yilNR7NbBiiAA9GRqaf1oaTPaRxJu9uy4c4OLyYr
        H1wJejBL/vsa6OViWT1JJU/LG0/6rgNwBsoI+z91vjfB5Rpc60Mj4jAqePzk1Dx/hAkwvAXlN4zEr
        Gfe73AENCao9+FFa+YX9QMUMG18k2mHZkEKB4zH1PVTRblteeBV7g56KWdtMycb4Gb4FfUGmcMnwY
        EGk1imrw==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6JU-00EM3H-Og
        for linux-xfs@vger.kernel.org; Thu, 12 Aug 2021 08:43:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: misc typedef removal
Date:   Thu, 12 Aug 2021 10:43:40 +0200
Message-Id: <20210812084343.27934-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series removes a bunch of almost unused typedefs.  I had these
lying around in an otherwise unrelated branch and would like to
offload them.
