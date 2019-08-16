Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC2EC3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8907F21655
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BG/fm2VM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfHPGmH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 02:42:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49602 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPGmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 02:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=75yAvQMeHUOOfStvGDr7kFZIB3XPI0gGlgceRdem48U=; b=BG/fm2VMHeTtEvFuupffxqpeR
        1Hg6CGEY2ePgy0ZGDs+Xg4+JtInvgrk3Gr2Ty4t0nL1xKWFxAnvls6/PLATItpO2lUkX/G7kmY3Vl
        8YIrkkJOke84sIHaxa8sjPVMg2ecoCcS510Aw0B47jPZrZqy6Pb3YBruFdkJ0LUkK5UDb8An2zsN4
        7CvGNj0LQ962y6lVTYwWDoCWHjbmT6gBx/1dtlxvlWqv2TXydE/IMXKmLdfXTCEQABh1gT6TspSUw
        q9/ggNdiEBCmqFRiUGCZdui3HiGwkmbkSGSdMxQdvnLEJweF7Fcvy+4VRvxhNRTa5HtQhbE+Avh+n
        bFkGCn/4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hyVw6-0003Mk-6e; Fri, 16 Aug 2019 06:42:06 +0000
Date:   Thu, 15 Aug 2019 23:42:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix reflink source file racing with directio writes
Message-ID: <20190816064206.GC2024@infradead.org>
References: <20190815165043.GB15186@magnolia>
 <20190815213716.GS6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815213716.GS6129@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 07:37:17AM +1000, Dave Chinner wrote:
> I don't think this is quite right yet. The source inode locking
> change is good, but it doesn't break the layout on the source inode
> and so there is still they possibility that something has physical
> access and is directly modifying the source file.
> 
> And with that, I suspect the locking algorithm changes
> substantially:
> 
> 	order inodes
> restart:
> 	lock first inode
> 	break layout on first inode
> 	lock second inode
> 	break layout on second inode
> 	fail then unlock both inodes, goto restart

Agreed, that is the locking scheme I'd expect.
