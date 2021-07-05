Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A16C07E99
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A8461968
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhGEP2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 11:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhGEP2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 11:28:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2442BC061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 08:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TpCbh2HJIPxSbnuJNgnCMdQZ+5pE+YUBUp/+8ntO4Gk=; b=QSU//r9TXvCfrzdUuK0pP8TW9+
        knXsvw5Ob3O0DQUbp1HvayNjgizLAhIZnX4hJE3a+br+m1ebAWhM+ecgJ2b44ZtsHGZm67GbingLQ
        ASTA1w2kCMwTg0FWx8tykaQ/GK8ALUPrZOt/XnT61Sry7pk1KRuZ8avAeMHF0hKwB/nktdiFR1uCC
        jKjFEJazWyv7kVnxQuhL1SmypTQ77hqJ5RphW2/5AJmj1XGiRo+gSSF/2Vmwy5YXq6hsU9RSvck2B
        reAk/+UD/K8xGROB/s/T2PaVMaWq+ugNLtONvzOOrWukY/n4oVkUkr2zSOVtpFNhNDeEdxfpEfZa4
        ehZN5fgQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0QTP-00AME0-H3; Mon, 05 Jul 2021 15:25:29 +0000
Date:   Mon, 5 Jul 2021 16:25:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: don't count fsmaps before querying fsmaps
Message-ID: <YOMkZyxoSJpG+rur@infradead.org>
References: <162528108960.38807.10502298775223215201.stgit@locust>
 <162528110051.38807.5958877066692397152.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528110051.38807.5958877066692397152.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's a bunch of code in fsmap.c that tries to count the GETFSMAP
> records so that it can size the fsmap array appropriately for the
> GETFSMAP call.  It's pointless to iterate the entire result set /twice/
> (unlike the bmap command where the extent count is actually stored in
> the fs metadata), so get rid of the duplicate walk.

In otherwords:  just keep iterating over the records using the default
chunk size instead of doing one call to find the size and then do
a giant allocation and GETFSMAP call.

I find the current commit log a little confusing, but the change itself
looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
