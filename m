Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404584AbfFKIqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 04:46:53 -0400
Date: Tue, 11 Jun 2019 10:46:46 +0200
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Message-ID: <20190611084646.GA22981@infradead.org>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-3-hch@lst.de>
 <20190520220844.GD5335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520220844.GD5335@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 03:08:44PM -0700, Darrick J. Wong wrote:
> > -xlog_state_do_callback(
> > -	struct xlog		*log,
> > -	int			aborted,
> > -	struct xlog_in_core	*iclog);
> > +STATIC void xlog_state_done_syncing(
> > +	struct xlog_in_core	*iclog,
> > +	bool			aborted);
> 
> I totally mistook this for a function definition. :/
> 
> STATIC void xlog_state_done_syncing(struct xlog_in_core *iclog, bool aborted);
> 
> ...seems to fit on one line, right?

Yes, but this style is used by all the forward declarations in
xfs_log.c.  Eventually we should fix them all, or even better get rid
of most of them.
