Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52652 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbfETNUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:20:08 -0400
Date: Mon, 20 May 2019 15:19:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Message-ID: <20190520131946.GA8717@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-12-hch@lst.de> <20190520131232.GB31317@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190520131232.GB31317@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 09:12:33AM -0400, Brian Foster wrote:
> > +				spin_unlock(&iclog->ic_callback_lock);
> > +				xlog_cil_process_commited(&tmp, aborted);
> 
> s/commited/committed/ please.

Ok.

> > +	while ((ctx = list_first_entry_or_null(list,
> 
> Are double braces necessary here?

Without them gcc is unhappy:

fs/xfs/xfs_log_cil.c: In function ‘xlog_cil_process_commited’:
fs/xfs/xfs_log_cil.c:624:9: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
  while (ctx = list_first_entry_or_null(list,

> >  	/* attach all the transactions w/ busy extents to iclog */
> 
> Any idea what this ^ comment means? ISTM it's misplaced or stale. If so,
> we might as well toss/replace it.

No idea.  We can probbaly remove it.
