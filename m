Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GH92ke262001 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:09:02 -0500
Date: Fri, 16 Apr 2010 13:10:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: record log sector size rather than log2(that)
Message-ID: <20100416171059.GD2729@infradead.org>
References: <1271355457.2680.93.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271355457.2680.93.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, Apr 15, 2010 at 01:17:37PM -0500, Alex Elder wrote:
> Change struct log so it keeps track of the size (in basic blocks)
> of a log sector in l_sectsize rather than the log-base-2 of that
> value (previously, l_sectbb_log).  Rename a variable holding the
> sector size to more closely match the field it comes from.
> 
> (Updated so that a variable used in computing and verifying a log's
> sector size is named simply "size".  Also dropped some superfluous
> parentheses and renamed another local variable.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks correct, but I don't think the choice of "size" for a log2
is particularly intuitive.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
