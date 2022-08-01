Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180E8C00144
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 17:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiHAROW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiHAROV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 13:14:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756842A268;
        Mon,  1 Aug 2022 10:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XLRm+bwOLEYkQYZ4l8poSx+rw2INBsokvjUDUsel0E0=; b=xyWg+qmkukZ73JGPHuK35CP3qM
        0o7Qg8frEIqc5L/DRx1UtSZVG+txCwTiFkuKJ0HB02cqCTqPaU64AIIHQXd5pGrh388N4JvJdcG00
        x8lRHLkpJWm56ALkcyKYp74TNNT8cTX3ZIUGGwq6hhGE87anKUb6RP5ipsrJEFZbAQokUyuJNgoU9
        B2Vol3Ulj0yhX6UC1gLv9KmmYoVr/PLg9CdJyCorRWJejmwf0UzK83yzavL4YgBsiTkNnJwxNRuzD
        giZ3Z7ASf5IhKJkBxjOpTU9fQIjmvrOD2b3wwLmH9s4t0NBBeLb70pRtWxnFnYKAEjkVIon2trHPM
        A9EwGJKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oIYzb-0089gb-Kh; Mon, 01 Aug 2022 17:14:11 +0000
Date:   Mon, 1 Aug 2022 10:14:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/432: fix this test when external devices are in
 use
Message-ID: <YugJ41IWh4m5Tbgp@infradead.org>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
 <165903223512.2338516.9583051314883581667.stgit@magnolia>
 <YuLunHKTHbw1wcvZ@infradead.org>
 <20220731052912.u3mcvvhl2dintaqq@zlang-mailbox>
 <Yua0vwCQFsayKH1x@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yua0vwCQFsayKH1x@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 31, 2022 at 09:58:39AM -0700, Darrick J. Wong wrote:
> *OR* we could just override the variable definition for the one line
> since (for once) bash makes this easy and the syntax communicates very
> loudly "HI USE THIS ALT SCRATCH_DEV PLZ".  And test authors already do
> this.

Ok, let's stick to that and I'll take my suggestion back.
