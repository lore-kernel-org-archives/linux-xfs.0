Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OEfKUu148004 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 08:41:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 302AC148F6C
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 06:40:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id STimXKTphJB4EHCF for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 06:40:49 -0800 (PST)
Date: Tue, 24 Feb 2009 09:40:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: cleanup xlog_bread
Message-ID: <20090224144048.GA17151@infradead.org>
References: <20090220085207.663702000@bombadil.infradead.org>
	<20090220085229.488121000@bombadil.infradead.org>
	<20090222224841.GW13088@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090222224841.GW13088@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Feb 22, 2009 at 05:48:41PM -0500, Josef 'Jeff' Sipek wrote:
> On Fri, Feb 20, 2009 at 03:52:11AM -0500, Christoph Hellwig wrote:
> > Most callers of xlog_bread need to call xlog_align to get the actual offset.
> > Consolidate that call into the main xlog_bread and provide a _xlog_bread
> > for those few that don't want the actual offset.
> 
> Only one leading underscore? IOW, why not not __xlog_bread? (That's
> definitely more Linux-like.)

In that deep down xfs code a single underscore is the more common idiom.
Of course a descriptive name might be even better :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
