Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8EGeQck067381 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 11:40:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6A571218E24
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 09:41:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AlCu3liOwkcqGCLP for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2009 09:41:38 -0700 (PDT)
Date: Mon, 14 Sep 2009 12:41:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_log_force: error 5 returend
Message-ID: <20090914164138.GA13081@infradead.org>
References: <20090914100548.45440@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090914100548.45440@gmx.net>
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
To: Steffen Knauf <Steffen.Knauf@gmx.net>
Cc: xfs@oss.sgi.com

On Mon, Sep 14, 2009 at 12:05:48PM +0200, Steffen Knauf wrote:
> hello,
> 
> sometimes, our server crashed with xfs_log_force: error 5.
> It isn't reproducible and a xfs_check / xfs_repair don't find some errors.
> 
> Perhaps it's a bug?  

Error 5 is EIO, and xfs_log_force basically passed the error through
from the underlying device.  Most likely it is an issue with the
underlying storage device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
