Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DE0C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 10:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1627F22518
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 10:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgLDKLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLDKLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 05:11:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5C2C0613D1
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 02:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p1Oh184YW+n4LpOGppzTTuU/LGVMJ6IMyEQJ0/jm2tk=; b=M0A3/ZxYgmWE99AMc4ANkoAN9q
        Q7klGB+rK52bteNTi1z4/8S9xPVyZ+jTKBF7qjZ5lbAgR0Xdy34YUyeqc4t6X42dfVDRxnRLolMBu
        rvS2s+HT/yFx8DIdZtfpEwjzbUyzmuoAfbWUh44oydXrUU7Ju6S7x7JFxTusTqZOHpZdpfloJVj8K
        4w/KUwaCAdjyJqds/vMwdFYiUjFxeDODEJOFsFBTonKK/m9vuaOG/8DztftpKktRH3J1JZLofSrdV
        OwblA+zz80+Y6d6ihWjAK26CbtYZyrv6R0DkIIjRR4g5SUmxoe0dBfn7UWk7UFvSe+3UtZpUzGfTx
        BKxD1rOA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl83J-0000gW-Ep; Fri, 04 Dec 2020 10:11:01 +0000
Date:   Fri, 4 Dec 2020 10:11:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: scrub should mark a directory corrupt if any
 entries cannot be iget'd
Message-ID: <20201204101101.GC1734@infradead.org>
References: <160704436050.736504.11280764290946254498.stgit@magnolia>
 <160704438289.736504.15952269053640029711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704438289.736504.15952269053640029711.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:13:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It's possible that xfs_iget can return EINVAL for inodes that the inobt
> thinks are free, or ENOENT for inodes that look free.  If this is the
> case, mark the directory corrupt immediately when we check ftype.  Note
> that we already check the ftype of the '.' and '..' entries, so we
> can skip the iget part since we already know the inode type for '.' and
> we have a separate parent pointer scrubber for '..'.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I wonder if we need the EINVAL vs ENOENT distinction to start
with or if we could return a single coherent error code from iget.
