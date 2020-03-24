Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758C5C54FCE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 12:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DABD2070A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 12:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iZOtoUt/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCXMhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 08:37:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXMhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 08:37:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DvZql2+KM86Mv/fpp2avXVBQtyDGPfK2CBdzSHTRsw0=; b=iZOtoUt/7ZdBZewgR1Rs5beoDd
        Ne7JEtKK1/u3La5XcGLJSNcaEXu9L5DuMesWbzymKMQpfBwRIyMmFzMAcp9psu7yyNNJyU5g1280J
        a2YBZp7W4vZlojmzAOtQPZB42ZNewxdLHLW19f03jdhOK8YILcxSf/9jh69q6IK+KwgsXudjDGgCy
        jdWwpxYmf25hI5LIDmK+zk2K/TD13xCNl9Bwa/OP1pxM2SQ2iIEDVmR6DaslASlO8i537ZZTPArQ/
        65he1nwPcMh7oxkzeL8IPeH12+J2GPMqVl5ApGp+alMS1gvzaj+xjJ7JCe/hQ8tYkHuyC6rU1mvpv
        5QrZhyQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGioN-0006IZ-8l; Tue, 24 Mar 2020 12:37:39 +0000
Date:   Tue, 24 Mar 2020 05:37:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: refactor and split xfs_log_done()
Message-ID: <20200324123739.GA20763@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-4-david@fromorbit.com>
 <20200305180644.GC28340@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305180644.GC28340@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 01:06:44PM -0500, Brian Foster wrote:
> Ok, but it looks like the original xfs_log_done() includes a bit of
> logic to end a regrant in the event of commit_record() error (shutdown).
> Do we need to lift that logic into callers (that might regrant) as well?

Yes.

> 
> > +/*
> > + * Release or regrant the ticket reservation now the transaction is done with
> > + * it depending on caller context. Rolling transactions need the ticket
> > + * regranted, otherwise we release it completely.
> > + */
> > +void
> > +xlog_ticket_done(
> > +	struct xlog		*log,
> > +	struct xlog_ticket	*ticket,
> > +	bool			regrant)
> > +{
> >  	if (!regrant) {
> >  		trace_xfs_log_done_nonperm(log, ticket);
> > -
> > -		/*
> > -		 * Release ticket if not permanent reservation or a specific
> > -		 * request has been made to release a permanent reservation.
> > -		 */
> >  		xlog_ungrant_log_space(log, ticket);
> >  	} else {
> >  		trace_xfs_log_done_perm(log, ticket);
> > -
> >  		xlog_regrant_reserve_log_space(log, ticket);
> > -		/* If this ticket was a permanent reservation and we aren't
> > -		 * trying to release it, reset the inited flags; so next time
> > -		 * we write, a start record will be written out.
> > -		 */
> > -		ticket->t_flags |= XLOG_TIC_INITED;
> >  	}
> > -	/* xfs_log_done always frees the ticket on error. */
> > -	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, false);
> > -	if (commit_lsn == -1)
> > -		goto out_abort;
> > +	error = xlog_write_done(log, tic, &commit_iclog, &commit_lsn);
> > +	if (error)
> > +		goto out_abort_free_ticket;
> > +
> > +	xlog_ticket_done(log, tic, false);
> 
> Seems it would be more simple to call xlog_ticket_done() before the
> error check and use the out_abort label (killing off the free ticket
> one). Otherwise looks Ok.

There are two other jumps to that label, so it can't be removed.
