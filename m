Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7uYes205582 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:56:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 889B1185ECA0
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:55:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id smLJ39zmcWA1NUBT for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:55:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRMK0-0002ED-8N
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:55:52 +0000
Date: Mon, 26 Jan 2009 02:55:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/17] xfs: cleanup handling in xfs_swap_extents
Message-ID: <20090126075552.GA1062@infradead.org>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073200.459094000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073200.459094000@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

On Mon, Jan 26, 2009 at 02:31:39AM -0500, Christoph Hellwig wrote:
> Use multiple lables for proper error unwinding and get rid of some now
> superflous variables.

Sorry, should have been cleanup error handling and marked as beein
from Jeff.

Jeff, maybe you should just resend this yourself so that it doesn't
get messed up?  You can add my Tested-by flag as it passed xfsqa
on multiple platforms for me (although with the recent swapext flaw
I wonder if that actuall means anything :))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
