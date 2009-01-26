Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7lKhT205073 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:47:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BB02B76B4
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:46:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id U5S6DrQsJrPJ8nl1 for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:46:38 -0800 (PST)
Date: Mon, 26 Jan 2009 02:46:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] don't reallocate sxp variable passed into xfs_swapext
Message-ID: <20090126074636.GB27188@infradead.org>
References: <497D258C.1000908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <497D258C.1000908@sandeen.net>
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
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@linux-foundation.org>, pm@debian.org, xfs-oss <xfs@oss.sgi.com>

On Sun, Jan 25, 2009 at 08:53:00PM -0600, Eric Sandeen wrote:
> fixes kernel.org bugzilla 12538, xfs_fsr fails on 2.6.29-rc kernels
> 
> Regression caused by 743bb4650da9e2595d6cedd01c680b5b9398c74a
> 
> This was an embarrasing mistake, reallocating the sxp pointer passed
> in from the main ioctl switch.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net
> Reported-by: Paul Martin <pm@debian.org>
> Tested-by: Paul Martin <pm@debian.org>

Yikes.  Looks good to me, but any chance you could try cooking up a
xfsqa test that would hit this as our existing xfs_fsr test apparently
doesn't?


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
