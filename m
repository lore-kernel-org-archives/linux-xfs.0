Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2F5C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344020AbiD1MsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiD1MsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:48:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFEE631D
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DryzY2mFCrW3fjIlCJx3vNiEc74wVqLH03FeGPRO/Qw=; b=wmOSxb9ofiApORGfqfBLqERuUJ
        fdJ1MVSJCDfzmhS42IYBBJWY/4pgE7VpRAJjG0V6R9iYw2E3jWkcpOYSI+/zaw70o7Ls2tYJPHdTz
        dZs+BC4nSRuXu8JHNZPuYWn57nNmkPj1BILYPTdCNEqcU6vDJhQaDN9StbClSWD8KKn2ByCb+85nT
        MsnnrJrdCudgCAi4tSIQWKmAnzACC32tlZ0kwWFr1aUCJKZayvm8N9uiG5QwyK9BdmtyR9Yuq5487
        LpH85ar0PeWT8SEZV8+4OS5u/8YOi+KRZSGNf5TJRn6NL7aGfJjWr/e3ve2Zm26tB9hvVbeM0Q66B
        8vrlIpIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3Vk-006qzb-SY; Thu, 28 Apr 2022 12:44:44 +0000
Date:   Thu, 28 Apr 2022 05:44:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: speed up rmap lookups by using non-overlapped
 lookups when possible
Message-ID: <YmqMPHXhXoePYU6X@infradead.org>
References: <165102068549.3922526.15959517253241370597.stgit@magnolia>
 <165102070261.3922526.1584531429524068308.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102070261.3922526.1584531429524068308.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:51:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reverse mapping on a reflink-capable filesystem has some pretty high
> overhead when performing file operations.  This is because the rmap
> records for logically and physically adjacent extents might not be
> adjacent in the rmap index due to data block sharing.  As a result, we
> use expensive overlapped-interval btree search, which walks every record
> that overlaps with the supplied key in the hopes of finding the record.
> 
> However, profiling data shows that when the index contains a record that
> is an exact match for a query key, the non-overlapped btree search
> function can find the record much faster than the overlapped version.
> Try the non-overlapped lookup first, which will make scrub run much
> faster.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
