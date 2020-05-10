Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502F8C54E49
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC02208E4
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EqZH2Ofz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgEJH0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJH0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:26:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7226DC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FjLkpfGZo587SzcW2yGvv6LElyNMC8kst40FqRv06+4=; b=EqZH2Ofza9GjDqgn6HrSauVf+b
        5WkSCEB2G1SZX7koGM+6BA4WhGRBHAmRFwISdtU/dkhOjdJYJgAJy2Oa0xEw0dssOv7wZCe22k6vr
        lYFAyGyRAxUvjmYWzVPOZC45dq6R3w54+LbCbdYnZVadrAF3SpOnqydHOfuVEZp44cPT5KK2CRxIj
        qiFeXnaWJTV5758wsQlYtKZIcWvyQlebMdjG8r5TZj9YFcBkKducABr59KSdGm4pFIwAGKGQ2E0NE
        35YqZfzJ/cRN3QdeH/j/gBNueOMm/SaG1OrEEJ9nJVp4IKJhzcQU1R209oGIsqV8DUeY7tvWVSOq3
        BtHEr24w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgMO-0007TU-Nc; Sun, 10 May 2020 07:26:52 +0000
Date:   Sun, 10 May 2020 00:26:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs_repair: complain about free space only seen by
 one btree
Message-ID: <20200510072652.GE8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904188639.982941.5408652247371014933.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904188639.982941.5408652247371014933.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During the free space btree walk, scan_allocbt claims in a comment that
> we'll catch FREE1 blocks (i.e. blocks that were seen by only one free
> space btree) later.  This never happens, with the result that xfs_repair
> in dry-run mode can return 0 on a filesystem with corrupt free space
> btrees.
> 
> Found by fuzzing xfs/358 with numrecs = middlebit (or sub).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
