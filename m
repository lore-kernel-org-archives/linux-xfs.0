Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P8X03V043926 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 02:33:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA76F188CE8
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:34:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KD1JH14Zkt2pyv6K for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:34:04 -0800 (PST)
Date: Mon, 25 Jan 2010 03:34:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: turn off sign warnings
Message-ID: <20100125083403.GA1851@infradead.org>
References: <1264397602-18868-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264397602-18868-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 25, 2010 at 04:33:22PM +1100, Dave Chinner wrote:
> Because they cause warnings in static inline functions conditionally
> compiled into XFS from the VFS (e.g. fsnotify).

Ok.  As I already mention I feared something like this could happen.
Would be great to get it on for the whole kernel.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
