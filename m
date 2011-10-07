Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97KA3KU260284 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 15:10:03 -0500
Date: Fri, 7 Oct 2011 16:10:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: remove xfs_buf_target_name
Message-ID: <20111007201001.GA23256@infradead.org>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210640.089607475@bombadil.infradead.org>
	<1318016243.2810.47.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318016243.2810.47.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 07, 2011 at 02:37:23PM -0500, Alex Elder wrote:
> On Thu, 2011-10-06 at 17:06 -0400, Christoph Hellwig wrote:
> > The calling convention that returns a pointer to a static buffer is
> > fairly nasty, so just opencode it in the only caller that is left.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Yay!  The name buffer needs not to be static any more though.
> I will remove it for you unless you want to re-post it.
> 
> Other than that, looks good.

I'll resping the series with this and the naming change.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
