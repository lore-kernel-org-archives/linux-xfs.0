Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83499C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5AE208CD
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l8HFEVEy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgCEPUN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:20:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgCEPUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 10:20:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5GSGd2JGUkKpYySVz+Pck51eyJO2/70Cq1V/eK8ix/o=; b=l8HFEVEy8WWlsIF8Wobo8uHfuu
        ejGiQxjaBB0NOmLR6tJdukFpISNPff5Qtu2YI0kZoHdrE/uFtDhnIU+PFVFjK4PEnK3U/0jHotwog
        Zubu4bLd+Cfrn9zZWK+3iItrFqaQPNIKad0toyGm89ci9W8EYep9b5tv6mKXqDeUuXJ0F756ioYpU
        dP4eIPZafIdSfD+aPY1P8fkIhv6AD19cOTEvRKC5CNm6QEwIOnh2Z2hYs8TmEy0pG2YfUwNfuK1tN
        kzQzjXYehqD2n1Bo9qQ6Bz1x9kWrfDJohSiSS1P+messdPCoXwjuGIGtBPG2wTiOPdIYUGPY7hYqp
        V2ry4W+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9sIH-0002ES-Kz; Thu, 05 Mar 2020 15:20:13 +0000
Date:   Thu, 5 Mar 2020 07:20:13 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: refactor and split xfs_log_done()
Message-ID: <20200305152013.GC8974@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-4-david@fromorbit.com>
 <20200304154955.GB17565@infradead.org>
 <20200304212818.GA10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304212818.GA10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 08:28:18AM +1100, Dave Chinner wrote:
> On Wed, Mar 04, 2020 at 07:49:55AM -0800, Christoph Hellwig wrote:
> > > +int
> > > +xlog_write_done(
> > > +	struct xlog		*log,
> > >  	struct xlog_ticket	*ticket,
> > >  	struct xlog_in_core	**iclog,
> > > +	xfs_lsn_t		*lsn)
> > >  {
> > > +	if (XLOG_FORCED_SHUTDOWN(log))
> > > +		return -EIO;
> > >  
> > > +	return xlog_commit_record(log, ticket, iclog, lsn);
> > > +}
> > 
> > Can we just move the XLOG_FORCED_SHUTDOWN check into xlog_commit_record
> > and call xlog_commit_record directly?
> 
> Next patch, because merging isn't obvious until the split is done.

Can you please at least avoid moving the code around in the next
patch then?  With the function now non-static there shouldn't really
be any reason to move it.
