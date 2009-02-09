Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n197rkdH233207
	for <linux-xfs@oss.sgi.com>; Mon, 9 Feb 2009 01:53:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D714EFCE2D
	for <linux-xfs@oss.sgi.com>; Sun,  8 Feb 2009 23:53:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JkN73CoRMTVv4hk0 for
	<linux-xfs@oss.sgi.com>; Sun, 08 Feb 2009 23:53:09 -0800 (PST)
Date: Mon, 9 Feb 2009 02:53:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090209075308.GA7360@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1234133120.12370.7.camel@champagne.cantina>
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
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> sure, attached

That would be a missing PagePrivate bit in page_buffers() called from
end_buffer_async_write.  PG_private can only be cleared via drop_buffers
which requires the page not having PG_writeback set which must be
set until end_buffer_async_write is done.  Very strange, and all this
is generic code without xfs involvement.  Did this happen once
or can you reproduce it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
