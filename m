Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21D6C25B0C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 12:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiHKMdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbiHKMdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:33:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9453ADEAE;
        Thu, 11 Aug 2022 05:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xTjBT1mxr3sKSzFSDEH/YrT54q
        RoLrNe/00eQREyyisIl0LslK9nLv+LuOQdWF12vF81hGqk1msWCRCPIsxZaS1uMILmAzbE/zDxVSK
        aspMggrV/CxNE8LFlCDwhq1r/GHw4oa0w7hBa+V/hCqzm93kyXq0GJoJJsXAHsBnTkPgIWB2uro1B
        c4oPFhTLd0yviWZiJgZ4vbjs9h+B74CHeRc9rBVCRZdEzxnvylGrgCXVZpja/YNUYKOeJpUXiZaYM
        VgD0wl8C2LSGmu6daYMTqrks3DiFzdkmUrRao797w9xRAGa5u02EqskT8fMUerMzFBsfJbFpZFR/O
        9eEbrBIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM7Mx-00C9IB-Ro; Thu, 11 Aug 2022 12:32:59 +0000
Date:   Thu, 11 Aug 2022 05:32:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] common/ext4: provide custom ext4 scratch fs options
Message-ID: <YvT2+2TCP8BiUUmd@infradead.org>
References: <166007884125.3276300.15348421560641051945.stgit@magnolia>
 <166007885800.3276300.2421777224579305613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007885800.3276300.2421777224579305613.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
