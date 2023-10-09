Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E40E95A8E
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 10:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbjJIKaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345769AbjJIKa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:30:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E97CCA
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3Ov+j8esqfA+Q1mKv5C5kA5iNTuuTmHpjRB58il/5O0=; b=dkRMECkb4UtwpDdEPmOULvUPWT
        WUVcTQj+c9yDIcqKDlBAUVHm7RHmMPEkqOFY85gkFvfnAgFXX7i6boXUIRjIvf4QFb/LLI7BVDvaX
        3OxQyR4PxM5+QYpuyJQZ46RfYZX3QZ8rH6rwPmujEkq/4VuaKrlNDPGEbQ6KRf+aFRYhoVVUIQB+h
        9LSmgFOUBbvkZ+RG7qk3SXgEi2wFESkMgLs91uJKawLJS4cDKA2mnBK11qiqITuxIcziMt/uN7njo
        5UfoozgioFmwPyVqk4QWkj3QFGKkS2/5X7euq5gXSxNklH5u0xSPtnympNt6DORDfwCQnbGumO3rj
        w3gTv+fQ==;
Received: from [2001:4bb8:182:6657:e5a9:584c:4324:b228] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qpnWs-00ADZ1-37
        for linux-xfs@vger.kernel.org;
        Mon, 09 Oct 2023 10:30:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: handle nimaps=0 from xfs_bmapi_write
Date:   Mon,  9 Oct 2023 12:30:19 +0200
Message-Id: <20231009103020.230639-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've recently been playing around with re-enabling delayed
allocations on the RT subvolume (for the rextentsize=1 case), and ran
into an interesting bug where fsx unexpectedly returned -ENOSPC when
testing this code on top of Darrick's rtgroups code.

It turns out that this is because xfs_alloc_file_space does not retry
when xfs_bmapi_write returns 0 with *nimaps = 0, which can happen if the
allocator can't fill the entire space from the beginning of a delalloc
extent to the start of the actually requested range in the call to
xfs_bmapi_write.


