Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CFFC83004
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 05:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0B8206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 05:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xl28nt6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgD1FL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 01:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1FL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 01:11:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A230C03C1A9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 22:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vf+kVd/Japo5SfP2RpQudLC0eiU5zdmFsax9MrPtZP4=; b=Xl28nt6PINXPjISpHzKHhbCNP+
        u62JAlTxwYARW7gbPzYpz2C2FItlvyKJyKq6SVncdfzzh26eLWLBgWLvyoDUNb78Ftl737kR/Bdvq
        YsbmShaNnBIVrcsXv/0CAC1QbRx99FGmvfL7D/KExZU+v5Hs+5uasxFe1UYIWPCo8fiWy3UlMMrN8
        XAt85BFBpjHWCQXbNnxYCV+72a2sgqviXTs+9Scu9SfCqa3xjOspgyFgLgfSdmilpaWl6J1XA0uuT
        COR/uW2e1Ke/mb/McNQuqsLjF72vxFO5JNXuCSNq5h2SvRaPT7Thoq7hiedZheXKHUcpDm8kALXAt
        lZfJqtwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTIXC-0001KK-VE; Tue, 28 Apr 2020 05:11:54 +0000
Date:   Mon, 27 Apr 2020 22:11:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/19] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200428051154.GA24105@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752117554.2140829.4901314701479350791.stgit@magnolia>
 <20200425181307.GA16698@infradead.org>
 <20200427220412.GY6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427220412.GY6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 03:04:12PM -0700, Darrick J. Wong wrote:
> > > +	case XFS_LI_INODE:
> > > +		return &xlog_inode_item_type;
> > > +	case XFS_LI_DQUOT:
> > > +		return &xlog_dquot_item_type;
> > > +	case XFS_LI_QUOTAOFF:
> > > +		return &xlog_quotaoff_item_type;
> > > +	case XFS_LI_IUNLINK:
> > > +		/* Not implemented? */
> > 
> > Not implemented!  I think we need a prep patch to remove this first.
> 
> The thing I can't tell is if XFS_LI_IUNLINK is a code point reserved
> from some long-ago log item that fell out, or reserved for some future
> project?
> 
> Either way, this case doesn't need to be there.

The addition goes back to:

commit 1588194c4a13b36badf2f55c022fc4487633f746
Author: Adam Sweeney <ajs@sgi.com>
Date:   Fri Feb 25 02:02:01 1994 +0000

    Add new prototypes and log item types.


In the imported tree, which only added the definition, and no code
related to it.  I can't find any code related to it either in random
checkpoints.
