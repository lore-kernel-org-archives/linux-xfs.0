Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBM8orFT024828 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 02:50:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95CBF3DD4A
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 00:50:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9wQHcZthnuQjlH2R for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 00:50:52 -0800 (PST)
Date: Mon, 22 Dec 2008 03:50:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Intel X25-E running Linux using XFS
Message-ID: <20081222085047.GA24795@infradead.org>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
	<20081212185803.GE11974@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081212185803.GE11974@elf.ucw.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 07:58:03PM +0100, Pavel Machek wrote:
> Actually I'd like to know... how does it behave during powerfails
> while it is being written to?

I've done various powerfail tests with and X25-M and as expect it
behaves perfectly fine as long as you either disable the write cache
or use barriers.  The default ext3 setup without barriers corrupts
the filesystem left, right and center, but that's the same as other
recent disk drives with large caches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
