Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02BqnC4102682 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 05:52:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E8D31DAB800
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 03:53:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KALeJaUkqxZIB2Ip for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 03:53:38 -0800 (PST)
Date: Sat, 2 Jan 2010 06:53:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Kill filestreams cache flush
Message-ID: <20100102115338.GA18502@infradead.org>
References: <1262399900-19110-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262399900-19110-1-git-send-email-david@fromorbit.com>
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

On Sat, Jan 02, 2010 at 01:38:20PM +1100, Dave Chinner wrote:
> The filestreams cache flush is not needed in the sync code as it
> does not affect data writeback, and it is now not used by the
> growfs code, either, so kill it.

I have to admit I never understood the purpose of this call.

What xfs_fstrm_free_func does is:

 - clear the filesystems flag on the inode
 - decrement pagf_fstrms
 - drop references on the inode (and parent if known)
 - free the filestream item

Nothing of that should matter for sync, although dropping inode
references during sync might generally be a good idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
