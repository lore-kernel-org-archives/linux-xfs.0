Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42749C34031
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 22:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 156652465A
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 22:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lpwm1zsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgBRWgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:36:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBRWgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 17:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V1s0PLdEIkGnoAvCRDEFOP2nyPhZpQBdfvK9dFBC6MM=; b=Lpwm1zsl8KN3bnUc6scmLjvF54
        VS6Fq9Eam4oShEeQ09U8MdQpJjE741NNYXjW2NBJGDF/FUVaHp3nayfO1lhMaQETckfHsD4PmF2OC
        hp1Q2r88ajD7S2W342J8M7fwHBoWHRAInzs4uPlAGvC64CX1p8UDf33NPd/oONOIH0vgTQ2DM0jIv
        hyw0ZuwH/D66j8Uxl8Fx5jxOgXuxl9J7bXubCE8kwBgz10vPbuhCrD+AmSaFX1cP3Rqm89tsyKPE3
        d9Wk+BTClvq8j5bTyf4zo2/r6QVX3QVQBpZ5B8dhFgegZ23DjJNQMHeWp5P5xOWtEVVSFQii+WGYH
        ooQ4x39g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4BTw-0007oG-J1; Tue, 18 Feb 2020 22:36:44 +0000
Date:   Tue, 18 Feb 2020 14:36:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200218223644.GA24053@infradead.org>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218215243.GS10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:52:43AM +1100, Dave Chinner wrote:
> xfs_force_shutdown() will does nothing if the iclog at the head of
> the log->iclog list is marked with XLOG_STATE_IOERROR before IO is
> submitted. In general, that is the case here as the head iclog is
> what xlog_state_get_iclog_space() returns.
> 
> i.e. XLOG_STATE_IOERROR here implies the log has already been shut
> down because the state is IOERROR rather than ACTIVE or WANT_SYNC as
> was set when the iclog was obtained from
> xlog_state_get_iclog_space().
> 
> > +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > +		goto error;
> >  
> >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > +			spin_unlock(&log->l_icloglock);
> > +			goto error;
> > +		}
> >  		sync = __xlog_state_release_iclog(log, iclog);
> >  		spin_unlock(&log->l_icloglock);
> >  		if (sync)
> >  			xlog_sync(log, iclog);
> >  	}
> >  	return 0;
> > +error:
> > +	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > +	return -EIO;
> 
> Hence I suspect that this should be ASSERT(XLOG_FORCED_SHUTDOWN(log))
> just like is in xfs_log_force_umount() when this pre-existing log
> IO error condition is tripped over...

Indeed, the xfs_force_shutdown is a no-op both for the old and this
new check.

Now the real question, which is a bit out of scope for this patch is
why we even have XLOG_STATE_IOERROR?  Wouldn't it make more sense
to just user the shutdown flag in the mount structure and avoid the
extra state complexity and thus clean up this whole mess?
