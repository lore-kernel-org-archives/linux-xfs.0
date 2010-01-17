Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBdd8A008886 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:39:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F15AF18C2F
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:40:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ntBLSeOXkdv57zQh for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:40:37 -0800 (PST)
Date: Sun, 17 Jan 2010 06:40:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: get size of device properly
Message-ID: <20100117114036.GA7813@infradead.org>
References: <4B50F2F0.4050909@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B50F2F0.4050909@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 15, 2010 at 04:57:52PM -0600, Eric Sandeen wrote:
> Ok, one more.
> 
> I've been having too many problems w/ xfstests today to have run
> the last patch through xfstests but should have at least run
> 032.  :(
> 
> Anyway, last change wasn't valid to test the size of a device
> node; total brain fart.  After this I'm testing the hell out
> of the next patch I send, I promise!
> 
> --------
> 
> Test device node size properly in check_overwrite, st_size
> is only valid for regular files.

The patch looks correct to me, but it also means we now open the device
twice in check_overwrite.  We might aswell use it just once and keep the
fd for the blkid probe.  Anyway, probably better to put this one in
ASAP, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Any chance you could create a xfstests regression test for this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
