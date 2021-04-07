Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD995C433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F27613B3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhDGGez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 02:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhDGGey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 02:34:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A06C06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FdphxKKQd0R9BjUC5xEDFk3H5Lrf9WmNzZITDe4TqC4=; b=Nhu56TugvLbBPzG926a7wErera
        ePqdQIO942WIQsGNn1U6h91vHzOQuDFEMjDrEcDVTYxoHDnYycxp4SoZeOBtUWET2hacS54NIFW2g
        C9TR6fdnKUoWst+rfH40swaxf9qbe2IupFr+5qG7Lmc9vRAF4IgzsI6BDrBfPOgb1iOmr9+e2m74I
        qoqJ1xnRT/zO5/VH6fhPaoGZ/OFW4iCL/gODjYoC4TjqP1RfU9/V7AE69uNI0FI2J4aTvJl5KZN5q
        5gq/jZ48Hd6Y5ekIgb56I1o6zIK6UIoE9/mjdDPbg6VnmxBoO4oDjsBqwDQyoEZSAMSGCJL+60/6k
        y4Pfu+Dw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU1lw-00E1LM-Oq; Wed, 07 Apr 2021 06:34:41 +0000
Date:   Wed, 7 Apr 2021 07:34:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: open code ioend needs workqueue helper
Message-ID: <20210407063440.GC3339217@infradead.org>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 10:59:01AM -0400, Brian Foster wrote:
> Open code xfs_ioend_needs_workqueue() into the only remaining
> caller.

This description would all fit on a single line.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
