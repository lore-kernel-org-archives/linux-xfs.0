Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0DFC433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EBC065018
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 08:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCEIZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCEIYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:24:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA3FC061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h2P4Gvu7QT4CKFjEFqgDHGinHu9WYBtbDrhztWQ65E0=; b=BT8id59yWg58v1rIc2JEtRxHi/
        eQtO3mZqlBc4K7UiRLNJgLk9Rr6ZBdbIMzn/oIgEII4w6UXACiS3nSzsNI8r8ffnKWV3IwMQq3+RE
        nXy7uf7vpeNym7Gmwkldpw932zQol8U00xdDbHHsJtbnO856+GNEm0o4CIflgE6nms1sHTswfims0
        S2A1431DCR6TuCXGGmLaxOpaDzbQxjDYn91myA8VD+gwGaefR58VM4hecyEHcKb1ueAm8Me1rpipi
        KZEN1KGSLlflsvhUKEJ3B1SKx9JaeYiUxKXpgfAj4wLt2bDVyH2HIQhrribE6ZirDpuQUFpDMn1Jz
        DbmMau1g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5l5-00ApA3-2i; Fri, 05 Mar 2021 08:24:32 +0000
Date:   Fri, 5 Mar 2021 08:24:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: fix dquot scrub loop cancellation
Message-ID: <20210305082427.GB2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472412783.3421582.2613422908869140732.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472412783.3421582.2613422908869140732.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When xchk_quota_item figures out that it needs to terminate the scrub
> operation, it needs to return some error code to abort the loop, but
> instead it returns zero and the loop keeps running.  Fix this by making
> it use ECANCELED, and fix the other loop bailout condition check at the
> bottom too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
