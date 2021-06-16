Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945F6C48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 08:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D4861351
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 08:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhFPI2k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 04:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhFPI2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 04:28:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D092C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 01:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QWOEFoUSwzeidn2GaIYc0OejOBwfBLuB0ETnpLnclUw=; b=llTCRbGpkLbH0xdJMrDx7GSMFS
        QupSTqOeN1MSjLo2lwawws7CO9QmEqhydnMqGGQJPpBPjJ4dRbzix8oKg0K3KbpHcOWarJYElEGE6
        1HPEe1nG8z83edIbTDwk/EEFHHrjgr0+J7M0R1MtZ9XQkTpc3EeXNHWaXcveFEsBQZtAJqtKLBry9
        jH0x5hJmQWyxrt+vEMIUB7L3hswBmJj10VAvCpcWqJvv1kTdRKIRNYD8S5uFOEZMqmnTOSZJvvH3v
        KvwsGrccUDTFleTkXUQgnzcAemVFm72SDE9g3rFIefUvIFLdTi/vruqEYcnOrYHkQYlbG59TURpb3
        dhLFK7+A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltQsH-007npg-78; Wed, 16 Jun 2021 08:26:17 +0000
Date:   Wed, 16 Jun 2021 09:26:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Subject: Re: [PATCH 05/16] xfs: separate primary inode selection criteria in
 xfs_iget_cache_hit
Message-ID: <YMm1pS4R6PUxdhLe@infradead.org>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360482438.1530792.18197198406001465325.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360482438.1530792.18197198406001465325.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During review of the v6 deferred inode inactivation patchset[1], Dave
> commented that _cache_hit should have a clear separation between inode
> selection criteria and actions performed on a selected inode.  Move a
> hunk to make this true, and compact the shrink cases in the function.

I'm not sure the backstore really belongs here vs describing what
changes for what reason in the code.

It might be worth that this is now consistently calling the tracepoints
and incrementing xs_ig_frecycle, though.

But the actual changes look like a really nice improvement, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
