Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TDa2lO074949 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 08:36:03 -0500
Date: Thu, 29 Apr 2010 09:38:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] [PATCH] xfs: simplify buffer to transaction matching
Message-ID: <20100429133806.GA16259@infradead.org>
References: <20100418001041.865247520@bombadil.infradead.org>
	<20100418001058.677429475@bombadil.infradead.org>
	<1272548122.3221.77.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272548122.3221.77.camel@doink>
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

On Thu, Apr 29, 2010 at 08:35:22AM -0500, Alex Elder wrote:
> Dave suggested using the xfs_trans_*_item() routines (which maybe
> could be renamed xfs_trans_item_*() someday).  That is the right
> thing to do, but not necessary at this point.  In fact I prefer
> this smaller change anyway, since it clearly just transforms
> the original xfs_trans_buf_item_match_all() code directly to
> the new result.  The switch to use xfs_trans_*_item() can (and
> should) happen as a follow-on patch.

Yes, I'll prepare an incremental patch in the next days.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
