Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A00C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 09:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A986120C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 09:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhGBJas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 05:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhGBJar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 05:30:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF18DC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 02:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/RbPgCHo+ZYnem+RKjM/+96wWN87Ik6vEBmaEoiWhZk=; b=dTqdaagK1/eBFmWDkBchKCheua
        Qrx16OxRL7cTkYe+PrfQ0E+metsDaRNRG0pX31Yb+LZJpywuNmi0q26NdewAb/IvDC9TMKd0yHvB2
        9yagSPIst7y0Z9ZD3iWqiuZ13Xi9gVgRXOmRN4YhOi46DKh+D+hGNZl4LLJuYUEt5NzJs3NLkOCy8
        2mYmBmszSu6u2hOtzMbT6ctlhCIQG9ofzhOFwbD3NE4fthVRRe/e00rZqoTAZaZLCeWkJSp2JDdq9
        pEHU0833pUFqlvGXMKB9Pbo/Mk5yFNq5f0hrMIv+0vb4h+F8Edi+Cl01jJN27HhMYwZUyoVG3vivr
        f7waFIEw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzFSe-007Z1i-4h; Fri, 02 Jul 2021 09:27:52 +0000
Date:   Fri, 2 Jul 2021 10:27:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: convert XLOG_FORCED_SHUTDOWN() to
 xlog_is_shutdown()
Message-ID: <YN7cFL6eVVi+dom+@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-2-david@fromorbit.com>
 <YN7Et6kfwhGaVfEp@infradead.org>
 <20210702084558.GG664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702084558.GG664593@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 06:45:58PM +1000, Dave Chinner wrote:
> On Fri, Jul 02, 2021 at 08:48:07AM +0100, Christoph Hellwig wrote:
> > > @@ -366,7 +366,7 @@ xfs_log_writable(
> > >  		return false;
> > >  	if (xfs_readonly_buftarg(mp->m_log->l_targ))
> > >  		return false;
> > > -	if (XFS_FORCED_SHUTDOWN(mp))
> > > +	if (xlog_is_shutdown(mp->m_log))
> > 
> > This wasn't XLOG_FORCED_SHUTDOWN to start with.  Same for a few more
> > spots.
> 
> Yup, but in the places where we are working on the log, we should be
> checking the log state for shutdown, not the mount. They currently
> mean the same thing, but that doesn't mean we should use mount based
> checks in the log and vice versa.

Need documentation in the changelog, or even better a separate commit.
