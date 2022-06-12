Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F8FC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiFLVcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 17:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbiFLVcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 17:32:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844229FFD;
        Sun, 12 Jun 2022 14:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=v4mIWqTNLi/H6cmlkOhqCaPgNun/BIW7dc3RoGC1nCY=; b=RCB5aj0M0GTxq97GmTfmw83ojw
        6Lz0+yDJJVhmt3dLRuQcUvAeQI0hjWuSjpff2j//5DuETvlCYUQNTjVC7GKOLZcY96yNhWKXFKjKr
        DNvkjqt7GtQXUS3s8qhb1hqvDShj56YIdu6eEfQ6D0KkCOteF4ZqmEH3bSNyP6SmQPk+QahDv1N3o
        84o8/lp4NngLD7yLlh7Lgn2Vmc+eNN0Wpfg6z7zyON1RrlZMMWBl+PqAyHHd77AgWykWepvY9Sl/F
        +QlPO0Mc0maVzAY9VXdlpUW2m8lzQMEwxQ5TOQj3LrQnRSxdzzGS12ueggK/EncIqqFrNtPg8R+xI
        0YRAnZaw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0VC9-00GHpu-A8; Sun, 12 Jun 2022 21:32:29 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/3] Fixes for usercopy
Date:   Sun, 12 Jun 2022 22:32:24 +0100
Message-Id: <20220612213227.3881769-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Kees, I'm hoping you'll take these through your tree.  I think they're
all reasonable fixes to go into 5.19.  The first one is essential;
it fixes two different bugs that people have hit.

Matthew Wilcox (Oracle) (3):
  usercopy: Handle vm_map_ram() areas
  usercopy: Cast pointer to an integer once
  usercopy: Make usercopy resilient against ridiculously large copies

 include/linux/vmalloc.h |  1 +
 mm/usercopy.c           | 24 +++++++++++++-----------
 mm/vmalloc.c            |  2 +-
 3 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.35.1

