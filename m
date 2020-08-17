Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104A6C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5A77207DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:54:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qunmmnp8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgHQGyP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQGyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:54:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79D3C061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8M7uzcB8cwTf6ef2D0cB2P+iI6e4jQU0SWvKsMwEBcU=; b=Qunmmnp8ZgfIOYr+f0hwLle4qq
        CcSaeQeN+tK6+YyjFetIXhkA1BM21VLkE2iIXm51Esx1F4jisgOIkb8W6xKJI8fjwmDa/ZAMdqr/I
        oawtQYgN1uGRssiLPvlohYNi5DBGhzGHxbToRJzHxmbpmVjQg+DTm5K6d2ZwATiY4GpQ6NccBAClp
        8RPZ9QxgK/lUhFmmF4QDkax5xR4ehCMvszgovSaGKcn+MiS0PSmwYMoQIY7HEIGyhc5Aq5mTUzi1v
        dEgBLtcKowctoNmXXOTnUM/iaGfodmujpPpeYyqlK/7I7IAKOfZOAq/A4XXkCiSTqT07l1aDXVImZ
        jB3T+sXw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z21-0006bI-FN; Mon, 17 Aug 2020 06:54:09 +0000
Date:   Mon, 17 Aug 2020 07:54:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] man: update mkfs.xfs inode flag option documentation
Message-ID: <20200817065409.GE23516@infradead.org>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736125533.3063459.18063990185908155478.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736125533.3063459.18063990185908155478.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The mkfs manpage says that the extent size, cow extent size, realtime,
> and project id inheritance bits are passed on to "newly created
> children".  This isn't technically true -- it's only passed on to newly
> created regular files and directories.  It is not passed on to special
> files.
> 
> Fix this minor inaccuracy in the documentation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
