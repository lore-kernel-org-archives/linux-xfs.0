Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J7j7Aw054210 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 02:45:07 -0500
Date: Tue, 19 Jun 2012 03:45:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 v2] xfs: rename log structure and remove xlog_t
	typedef.
Message-ID: <20120619074505.GA30375@infradead.org>
References: <20120614142214.445982138@sgi.com>
	<20120614142430.963813265@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120614142430.963813265@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Thu, Jun 14, 2012 at 09:22:15AM -0500, tinguely@sgi.com wrote:
> From: Mark Tinguely <tinguely@sgi.com>
> 
> Rename the XFS log structure to xlog to help crash distinquish it from the
> other logs in Linux.

Please don't use the same subject for two patches, instead this one
should be some thing like

	xfs: rename struct log to struct xlog

and the next one

	xfs: remove the xlog_t typedef

otherwise both patches look fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
