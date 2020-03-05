Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90F0C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C42D20848
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gszJH90v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgCEP1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:27:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCEP1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 10:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pVIStGvtbWmKAHCa084ZnBmLp99/ZuqKj1my74l1Qpc=; b=gszJH90vlr95NqJJKDwGOFhUlu
        dwpED8GRYRLru3SfWW0ZTh5C/F3lZysikQHfEsw4RaGoKo8H5Rk/hn86QXaTfkEZdBoDY28qsCtvb
        zLJYvX5byoMkf1sYtaPlMF8ghw5mLaYJ8O3Q0YBdBR7mVOoto3Jx93G0NpD59Ym8Ad3dxj4+H0L9N
        NoVDvvf26mPJKGy8se95r0lxetW9dXMD9mdUApIPrmAV7B0oFWkc5+tnzyUlmNGROB3NAylRnIXww
        KPeolJmu+OdOzJ799kjYSVya+m9wkwTmOwrIgBEi5FagStPf+nDRXgxr2m0mw6w0Do108625gbyLd
        PnnzT2kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9sPN-0003ty-8S; Thu, 05 Mar 2020 15:27:33 +0000
Date:   Thu, 5 Mar 2020 07:27:33 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: merge unmount record write iclog cleanup.
Message-ID: <20200305152733.GE8974@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-10-david@fromorbit.com>
 <20200304155332.GG17565@infradead.org>
 <20200304213854.GB10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304213854.GB10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 08:38:54AM +1100, Dave Chinner wrote:
> On Wed, Mar 04, 2020 at 07:53:32AM -0800, Christoph Hellwig wrote:
> > On Wed, Mar 04, 2020 at 06:53:59PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The unmount iclog handling is duplicated in both
> > > xfs_log_unmount_write() and xfs_log_write_unmount_record(). We only
> > > need one copy of it in xfs_log_unmount_write() because that is the
> > > only function that calls xfs_log_write_unmount_record().
> > 
> > The copy in xfs_log_unmount_write actually is dead code.  It only
> > is called in the XLOG_FORCED_SHUTDOWN case, in which case all iclogs
> > are marked as STATE_IOERROR, and thus xlog_state_release_iclog is
> > a no-op.  I really need to send the series out to clean this up
> > ASAP..
> 
> Well, this patch pretty much solves that "dead code" problem in that
> it now handles already shut down, error in unmount record write and
> successful unmount record write now. i.e. we run the same code in
> all cases now, so you'll only need to fix the IOERROR handling in
> one place :P

It doesn't really.  We still end up with more convoluted logic after
your series, that goes through a whole bunch of steps that don't make
any sense when the log is already shut down.  Just like everywhere
else we should just return early with a shutdown log / iclog and just
delete this code instead of rearranging the chairs.
