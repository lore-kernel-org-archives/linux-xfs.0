Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbeGaN15 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:27:57 -0400
Date: Tue, 31 Jul 2018 07:47:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/15] xfs: replace dop_low with transaction flag
Message-ID: <20180731114758.GC40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-6-bfoster@redhat.com>
 <20180731081659.GG16028@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731081659.GG16028@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 31, 2018 at 01:16:59AM -0700, Christoph Hellwig wrote:
> > +	/*
> > +	 * Low free space mode was historically controlled by a dfops field.
> > +	 * This meant that low mode state potentially carried across multiple
> > +	 * transaction rolls. Transfer low mode on a dfops move to preserve
> > +	 * that behavior.
> > +	 */
> > +	dtp->t_flags |= stp->t_flags & XFS_TRANS_LOWMODE;
> 
> Maybe add parentheses here for clarity.
> 

Added, thanks.

Brian

> Except for that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
