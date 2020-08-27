Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4B5C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09B5D22BED
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HPuaAQhp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH0HUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0HUE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:20:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC95C061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OJR09EXRNyp0xmLkzODcbHNy6+kW9Uvd3d3wztb0Aew=; b=HPuaAQhpYoLZpLiMBUs8ZzUihs
        Rp0NV3YyKgy51H296qIJwGxMOPvPe5RUmcamHHadNXqDAcCiXmNvoGWv1AR/PX/KaRht8lxSGVztv
        J7dG88yhOAGZ6gDkYx3OcojXHR9skLrafln1r40btXkQjpOFDSsIB5DoIqCOlo0JUWIMM965tF20T
        IrrDypev1ej1qMv5AqyaORALazdq4RZXmyVCQ3VUMTzM7dDLqOOZZ+Hwdck6MWXlgqxJvZiiakr8a
        xRKv8uB42EN3P+/lTE71L86AVTmK+axAVPUJuAFQZU0Lr0SqsLhF8wA0voPcA+0ZqgWzmXOHaOzMY
        2nXnVLkg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBCCV-0006x0-8t; Thu, 27 Aug 2020 07:19:59 +0000
Date:   Thu, 27 Aug 2020 08:19:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use log_incompat feature instead of speculate
 matching
Message-ID: <20200827071959.GD25305@infradead.org>
References: <20200824154120.GA23868@xiangao.remote.csb>
 <20200825100601.2529-1-hsiangkao@redhat.com>
 <20200825145458.GC6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825145458.GC6096@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 07:54:58AM -0700, Darrick J. Wong wrote:
> > +	 XFS_SB_VERSION2_FTYPE		| \
> > +	 XFS_SB_VERSION2_NEW_IUNLINK)
> 
> NAK on this part; as I said earlier, don't add things to V4 filesystems.
> 
> If the rest of you have compelling reasons to want V4 support, now is
> the time to speak up.

I think that it because the series uses the longer unhashed chains
unconditionally.  And given that old kernels can't deal with that
at all I suspect that needs to be changed and support the old buckets
for old file systems.  And once that is done I don't think we should
enable the long single chain without the log item anyway, and remove
another possibly combination of flags.
