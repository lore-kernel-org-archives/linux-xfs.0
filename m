Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AEEC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F32020795
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 09:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CeNbdpgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIQJHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIQJHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 05:07:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B8DC061756
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 02:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Pdu/07EMkI5B5iV8/JtRllatidjH/53P4wE8keK59LA=; b=CeNbdpgf3GIXAyWIe8RKRn1/HM
        csb1BnuxSU8kOhPO1L9PeL58fPZCznVIhfmdKmGGhD+6X1ijvnKsgLiAoIqB4mxXacq18umLs7x/D
        stj7I/BMAack+Iuy3hnXafXZa3rScbbGfY9+p6XhdP0vZEHc5P5YaUzbtHD1B9TmwSdszoKq+nuDo
        zFr/uti7skBOAvBZ6PeOyLnSxtALjGQEfzyNEHq33smQH+8aiiKPow6ZgbtwTY8fnRN6cWQ8Epozg
        tiAcl7+ghHckMO8RjXTMFBNioJzsaLkJi4Ko39Js5oXiY9ucpMsQjHxwIc17+760XbL7e/qC+hN0M
        K+JPSJrg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIptG-0003tj-Kc; Thu, 17 Sep 2020 09:07:42 +0000
Date:   Thu, 17 Sep 2020 10:07:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/2] xfs: log new intent items created as part of
 finishing recovered intent items
Message-ID: <20200917090742.GC13366@infradead.org>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031332982.3624373.6230830770363563010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031332982.3624373.6230830770363563010.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During a code inspection, I found a serious bug in the log intent item
> recovery code when an intent item cannot complete all the work and
> decides to requeue itself to get that done.  When this happens, the
> item recovery creates a new incore deferred op representing the
> remaining work and attaches it to the transaction that it allocated.  At
> the end of _item_recover, it moves the entire chain of deferred ops to
> the dummy parent_tp that xlog_recover_process_intents passed to it, but
> fail to log a new intent item for the remaining work before committing
> the transaction for the single unit of work.
> 
> xlog_finish_defer_ops logs those new intent items once recovery has
> finished dealing with the intent items that it recovered, but this isn't
> sufficient.  If the log is forced to disk after a recovered log item
> decides to requeue itself and the system goes down before we call
> xlog_finish_defer_ops, the second log recovery will never see the new
> intent item and therefore has no idea that there was more work to do.
> It will finish recovery leaving the filesystem in a corrupted state.
> 
> The same logic applies to /any/ deferred ops added during intent item
> recovery, not just the one handling the remaining work.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I wonder how we could come up with a reliable reproducer for this,
though..
