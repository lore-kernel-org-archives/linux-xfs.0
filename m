Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC57C433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EBE52075D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bQnGTn4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgGNIDb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNIDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:03:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B06C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Veol6zHcwyFTcI61GRZNvdlHvQrsif0mTYnaov0NtYk=; b=bQnGTn4TVHDRl7cpBE5C0ihrW0
        qVtE2NLH/LQqWZNlgr/50ffACbxIXyB+syUU5IRO3zJS4GhreyLsBXBQXpTbgvl0bmMGtZzLMOeEE
        qYPFXMp+YwcETfVvqqclTZCawX55VNlxf/xLmeLADWftBkoyyb4jisBgZxuroq9kmlgTpwY8N74+8
        XUZB4mZ0vTNdvio134onNQ+BuABnyhuVY0XhGfl4o3vwcy37D62AqzP4HRj4eMuLQ1C9Tp43S0xnJ
        dMhVrjaYaYadB9mWgQVIRFg9Ylhdt7B7mDcW8AW6L0yvhpyONXAJGOQQ6LJh2mH39jSynyTii5zY6
        z/hU+/GQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFuS-00078Y-WE; Tue, 14 Jul 2020 08:03:29 +0000
Date:   Tue, 14 Jul 2020 09:03:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/26] xfs: add more dquot tracepoints
Message-ID: <20200714080328.GK19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469045467.2914673.3575157462136790000.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469045467.2914673.3575157462136790000.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:34:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add all the xfs_dquot fields to the tracepoint for that type; add a new
> tracepoint type for the qtrx structure (dquot transaction deltas); and
> use our new tracepoints.  This makes it easier for the author to trace
> changes to dquot counters for debugging.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
