Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A683C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1E9208E4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aw/DWUJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgEFO52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 10:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbgEFO52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 10:57:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D59C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 07:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cdirfk65ASPEiu2IWOhAPwgG9bkAxL+em4hq6wrQBws=; b=aw/DWUJ8PzKVjoGQsZ8UYPBmBU
        KeMrvihGJsOUS9jLYThbHxsUptNC1jpHnP0asxePqLVLHDC89MwwVwEjwjNoXo1LkJRdIL1ksMbZa
        5mEqshJBqWtWjhemkmjEWU6N1f4h7GoswT91yfQ6FxOSCY1Lzx+MFcpAoi0ZdAsd7BJH+JJQDUMg7
        AZ0vCbiXMH81HpUjatSZuEt6pNF34cdjJcRGKQCkbewTs+KXvaVFuu4KuLBQ0vfU7RgcbDp4pYjyh
        uBF7XJouvwvXb6oLULI00OyPw3SOf4bA+hRi6IdX6YU1MCJWRsgoVoAQ+JCMwsHP+OerTLk3xQiN4
        wZE8BiBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLUG-00057d-A1; Wed, 06 May 2020 14:57:28 +0000
Date:   Wed, 6 May 2020 07:57:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually account for quota changes in
 xfs_swap_extents
Message-ID: <20200506145728.GC7864@infradead.org>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864102885.182577.15936710415441871446.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864102885.182577.15936710415441871446.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:10:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, xfs_swap_extents neither checks for sufficient quota
> reservation nor does it actually update quota counts when swapping the
> extent forks.  While the primary known user of extent swapping (xfs_fsr)
> is careful to ensure that the user/group/project ids of both files
> match, this is not required by the kernel.  Consequently, unprivileged
> userspace can cause the quota counts to be incorrect.

Wouldn't be the right fix to enforce an id match?  I think that is a
very sensible limitation.
