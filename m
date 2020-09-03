Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6B4C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F34D3206C0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oUgLMdBn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgICJP2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgICJP1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 05:15:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7A2C061244
        for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2020 02:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h7hrOfIDjbeRnPgD6Jytu7OKV09KmrkD9JL0+OsZDtg=; b=oUgLMdBnzpY2RZ8LxQiPmWewGC
        VXWpAyAmO/5VfM482cwQnFN1vyDyBXnuoG2AYfnrHQftUHhjol5LaGYPJrLK0n2a25F9NTqX/MbQb
        QuEkINzqkW7dMVgi6GQGeSoxiqEXLAaChEA/+jO7c83gOKv1LbH+tM5GSjt4lQc/mV08L3yh4bdxw
        iy/SeWhfRjKHzFJbk1HIFGnaMbNgAuY+4F4NUiga6vLZcDSLN7IY5bW9drqOhWYUhCV0a6Ig/DFck
        e1jfnL24tM3I5G32mxXkoj+NP3avzc9dntrtRorBj55zU+CGQXdoDSk+XbClPpPk+NhfZt/pYXr8p
        zkzjhh4Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDlKw-0004Ap-L3; Thu, 03 Sep 2020 09:15:18 +0000
Date:   Thu, 3 Sep 2020 10:15:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: add inline helper to convert from data fork to
 xfs_attr_shortform
Message-ID: <20200903091518.GE10584@infradead.org>
References: <20200901095919.238598-1-cmaiolino@redhat.com>
 <20200901141341.GB174813@bfoster>
 <20200901152359.GD6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901152359.GD6096@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 08:23:59AM -0700, Darrick J. Wong wrote:
> > FWIW, I thought we tried to avoid including headers from other headers
> > like this. I'm also wondering if it's an issue that we'd be including a
> > a header that is external to libxfs from a libxfs header. Perhaps this
> > could be simplified by passing the xfs_ifork pointer to the new helper
> > rather than the xfs_inode and/or moving the helper to
> > libxfs/xfs_inode_fork.h and putting a forward declaration of
> > xfs_attr_shortform in there..?
> 
> If you change if_data to a (void *), all the casts become unnecessary,
> right?

Yes, that is probably an even better idea.
