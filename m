Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D4FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 07:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A3F207BB
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 07:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vu54JFqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgGNHZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNHZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 03:25:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0071BC061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 00:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G+IqNNt8XR8Ic+ALXmYGaiO37YaxQD4DOf0l9G1LJfc=; b=vu54JFqMtLgTgP14WHS2ZgG3kt
        QzE0pXmaMNYk+PiwuyJHb6YvfIShEw1FwlOQSag0VscFuDHZBfA/2Op+hZ9XN9NJ8/5CjwU0sKiyi
        3HuBdw4nlapdqNtcifQvb3NxkRx81i7ctdsd0cJHaFuT9Ial2acoxIrcCkvvT7Jo4RzF6ry2Eexrj
        SKWFrCNKteO0Ifi4LCwkBkgWVOXg/k5N9UGf28+qj0KdzZOyJR+p5LqgyHrxO1PVvO0KGvYGjm0vz
        ac/4PEmUDYXBhA5wP/8LtGvZlx21HiIxW7Fwmd2i0vClsnHzAZCY+D9Tk9FWSrTsFkhV2ELA4Aptp
        /DvkDK1g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFJD-0005TR-3C; Tue, 14 Jul 2020 07:24:59 +0000
Date:   Tue, 14 Jul 2020 08:24:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] xfs: move the flags argument of
 xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
Message-ID: <20200714072459.GA19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469031402.2914673.4988908192357652743.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469031402.2914673.4988908192357652743.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:31:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since xfs_qm_scall_trunc_qfiles can take a bitset of quota types that we
> want to truncate, change the flags argument to take XFS_QMOPT_[UGP}QUOTA
> so that the next patch can start to deprecate XFS_DQ_*.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
