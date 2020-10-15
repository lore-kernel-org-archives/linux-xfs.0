Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7355BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139CA2224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oEOWlgpI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgJOIlM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgJOIlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:41:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D8FC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WP54jSmBXtubd8rX7xw2Ef6AXxxDz/XABbWmz98OB9Y=; b=oEOWlgpIqpsiO3/wBbe+v2RAT1
        Zos7dQG0FqxK+DbmHY35m+viyx+W2PO9EeBpbHBh3xTHzEaDco9NPBGXFM9osHXjgtykij18LFr90
        HLoWdc4D2sCKOyWkeK/ltTCFVqMOb55n3oKn3yAqePVJMpUzETtHl1bgoVs9MQ132RXoFqJZZHvUN
        snad1+I3XH4NnPVzD0Wo5TGFP2gIXPrIb99jZLKuChVUwoekQILGs8jHc+01F18cL2MfeVLK8WYLI
        xv2H24FDfX01ioGYfkYKuu0dup7xWhtRDAqwKOhltF2zaWa1+fPQop2/5FdcY7pu7e24cv1jfKCLg
        macJmCLg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyow-0002AZ-Sz; Thu, 15 Oct 2020 08:41:10 +0000
Date:   Thu, 15 Oct 2020 09:41:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 11/11] xfs: Introduce error injection to allocate only
 minlen size extents for files
Message-ID: <20201015084110.GJ5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-12-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 02:59:38PM +0530, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> helps userspace test programs to get xfs_bmap_btalloc() to always
> allocate minlen sized extents.
> 
> This is required for test programs which need a guarantee that minlen
> extents allocated for a file do not get merged with their existing
> neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> Directories, Xattrs and extension of realtime inodes need this since the
> file offset at which the extents are being allocated cannot be
> explicitly controlled from userspace.
> 
> One way to use this error tag is to,
> 1. Consume all of the free space by sequentially writing to a file.
> 2. Punch alternate blocks of the file. This causes CNTBT to contain
>    sufficient number of one block sized extent records.
> 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> After step 3, xfs_bmap_btalloc() will issue space allocation
> requests for minlen sized extents only.
> 
> ENOSPC error code is returned to userspace when there aren't any "one
> block sized" extents left in any of the AGs.

Can we figure out a way to only build the extra code for debug kernels?
