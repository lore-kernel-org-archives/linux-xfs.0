Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FF1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFDB64ED3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhBYIjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhBYIjG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:39:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E7CC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Uuu7+c4erA44cyB1jqsgL917I6qAjgVua2sEyNiw1dw=; b=rYJgEJ+ahGh8JpSEKLtLpJegXS
        F8qpeMuthogywBs/6nlnucdtVASeT9yjfUXGMCIB1nDYKeS8KOE14/MszhuZKW8VPFWYSDRs8KBhS
        zekR4gZxTB0V1Tzisqo+I+9zherI2wp0Mcz8NVlfCgQ7L5Cv1pHrONY2YTV9VIpvFnooDimiDGNjQ
        b5TMbi/RncOLv7mtO9KU1OmLlfuaT6TFeDzu9leZRrDIAdBzxqDZIwG4Wn3IxSh51nQNBz72DCkO/
        UNljyX2WiPeUQI8YScWrWn4I/nSEkatcfTuFKysqW5IG8N9Pc2gCNwXyUWE58ANkC8PPZDNUyRNA4
        tiVvqe4g==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFC9y-00ATWP-S3; Thu, 25 Feb 2021 08:38:14 +0000
Date:   Thu, 25 Feb 2021 09:36:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move and rename xfs_blkdev_issue_flush
Message-ID: <YDdhcFBLwNKAwpGL@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:34:37PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move it to xfs_bio_io.c as we are about to add new async cache flush
> functionality that uses bios directly, so all this stuff should be
> in the same place. Rename the function to xfs_flush_bdev() to match
> the xfs_rw_bdev() function that already exists in this file.

I'd rather kill it off.  None that as of the latest Linus tree,
blkdev_issue_flush has also lost the gfp_mask argument.
