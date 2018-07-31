Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731920AbeGaN3G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:29:06 -0400
Date: Tue, 31 Jul 2018 07:49:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 15/15] xfs: fold dfops into the transaction
Message-ID: <20180731114906.GE40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-16-bfoster@redhat.com>
 <20180731083603.GD9242@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731083603.GD9242@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 31, 2018 at 01:36:03AM -0700, Christoph Hellwig wrote:
> > -	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
> > +	trace_xfs_defer_trans_abort(tp->t_mountp, tp, _RET_IP_);
> 
> Can't we stop passing the explicit xfs_mount to these tracepoints now?
> 

I thought I tried that and ran into xfs_trans definition issues. Looking
again, I see that we're using ->t_mountp in other tracepoints so perhaps
something else was going on. I don't recall exactly so I'll make another
pass and try to clean these up wherever we have a transaction.

Brian

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
