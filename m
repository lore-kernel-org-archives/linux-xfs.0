Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542E5C433E7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 17:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A6B22098B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 17:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIARM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 13:12:56 -0400
Received: from verein.lst.de ([213.95.11.211]:54481 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731268AbgIARMw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Sep 2020 13:12:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AE13F68B05; Tue,  1 Sep 2020 19:12:49 +0200 (CEST)
Date:   Tue, 1 Sep 2020 19:12:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: reuse _xfs_buf_read for re-reading the
 superblock
Message-ID: <20200901171249.GA8111@lst.de>
References: <20200901155018.2524-1-hch@lst.de> <20200901155018.2524-16-hch@lst.de> <20200901170249.GH6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901170249.GH6096@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 10:02:49AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 01, 2020 at 05:50:18PM +0200, Christoph Hellwig wrote:
> > Instead of poking deeply into buffer cache internals when re-reading the
> > superblock during log recovery just generalize _xfs_buf_read and use it
> > there.  Note that we don't have to explicitly set up the ops as they
> > must be set from the initial read.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> /me isn't too thrilled by the forward declaration of __xfs_buf_submit
> but oh well. :)

Im neither, but getting rid of that would required a major rearrangement
of xfs_buf.c.
