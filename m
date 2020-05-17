Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF024C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4CE2067D
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgEQH4O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 03:56:14 -0400
Received: from verein.lst.de ([213.95.11.211]:34274 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgEQH4O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 May 2020 03:56:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CA4AF68C4E; Sun, 17 May 2020 09:56:11 +0200 (CEST)
Date:   Sun, 17 May 2020 09:56:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/12] xfs: remove the special COW fork handling in
 xfs_bmapi_read
Message-ID: <20200517075611.GA30453@lst.de>
References: <20200508063423.482370-1-hch@lst.de> <20200508063423.482370-12-hch@lst.de> <20200516175200.GA6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516175200.GA6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 10:52:00AM -0700, Darrick J. Wong wrote:
> On Fri, May 08, 2020 at 08:34:22AM +0200, Christoph Hellwig wrote:
> > We don't call xfs_bmapi_read for the COW fork anymore, so remove the
> > special casing.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I was surprised this assertion, but apparently it's true, even in my dev
> tree, so:

We really shouldn't add more xfs_bmapi_read callers anyway.  Going
straight to the xfs_iext_* APIs pretty much always improves the code.
