Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBQvqH115555 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:26:58 -0600
Date: Mon, 20 Dec 2010 06:28:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: refactor xlog_recover_commit_trans
Message-ID: <20101220112852.GB6881@infradead.org>
References: <20101201220620.340188389@bombadil.infradead.org>
	<20101201220710.454838485@bombadil.infradead.org>
	<1292534295.2457.58.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292534295.2457.58.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 16, 2010 at 03:18:15PM -0600, Alex Elder wrote:
> On Wed, 2010-12-01 at 17:06 -0500, Christoph Hellwig wrote:
> > 
> > Merge the call to xlog_recover_reorder_trans and the loop over the
> > recovery items from xlog_recover_do_trans into xlog_recover_commit_trans,
> > and keep the switch statement over the log item types as a separate helper.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> I'm making a small change to this one patch though...

> > +	case XFS_LI_BUF:
> > +		return xlog_recover_do_buffer_trans(log, item, pass);
> > +		break;
> 
> I have deleted this "break" statement.

Yeah, this is a leftover from an earlier variant.  Thanks for spotting
it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
