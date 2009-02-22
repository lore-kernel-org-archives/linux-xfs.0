Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1MMnhSh065382 for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 16:49:44 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CA2B198671A
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 14:49:12 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id LfTXBAGaUcMrkThd for
	<xfs@oss.sgi.com>; Sun, 22 Feb 2009 14:49:12 -0800 (PST)
Date: Sun, 22 Feb 2009 17:48:41 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 4/7] xfs: cleanup xlog_bread
Message-ID: <20090222224841.GW13088@josefsipek.net>
References: <20090220085207.663702000@bombadil.infradead.org>
	<20090220085229.488121000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090220085229.488121000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 20, 2009 at 03:52:11AM -0500, Christoph Hellwig wrote:
> Most callers of xlog_bread need to call xlog_align to get the actual offset.
> Consolidate that call into the main xlog_bread and provide a _xlog_bread
> for those few that don't want the actual offset.

Only one leading underscore? IOW, why not not __xlog_bread? (That's
definitely more Linux-like.)

Josef 'Jeff' Sipek.

-- 
The box said "Windows XP or better required". So I installed Linux.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
