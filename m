Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18195 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729963AbfETNZq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:25:46 -0400
Date: Mon, 20 May 2019 09:25:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Message-ID: <20190520132543.GL31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-12-hch@lst.de>
 <20190520131232.GB31317@bfoster>
 <20190520131946.GA8717@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190520131946.GA8717@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 03:19:46PM +0200, Christoph Hellwig wrote:
> On Mon, May 20, 2019 at 09:12:33AM -0400, Brian Foster wrote:
> > > +				spin_unlock(&iclog->ic_callback_lock);
> > > +				xlog_cil_process_commited(&tmp, aborted);
> > 
> > s/commited/committed/ please.
> 
> Ok.
> 
> > > +	while ((ctx = list_first_entry_or_null(list,
> > 
> > Are double braces necessary here?
> 
> Without them gcc is unhappy:
> 
> fs/xfs/xfs_log_cil.c: In function ‘xlog_cil_process_commited’:
> fs/xfs/xfs_log_cil.c:624:9: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
>   while (ctx = list_first_entry_or_null(list,
> 

Ok, wasn't quite sure if that mattered.

Brian

> > >  	/* attach all the transactions w/ busy extents to iclog */
> > 
> > Any idea what this ^ comment means? ISTM it's misplaced or stale. If so,
> > we might as well toss/replace it.
> 
> No idea.  We can probbaly remove it.
