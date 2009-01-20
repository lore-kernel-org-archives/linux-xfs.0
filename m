Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KNMi7F023776 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 17:22:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 647E1182CCEF
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 15:22:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 98uWtDHOUiAWCmwN for
	<xfs@oss.sgi.com>; Tue, 20 Jan 2009 15:22:44 -0800 (PST)
Date: Tue, 20 Jan 2009 18:22:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: [XFS] 2.6.29-rc2: XFS internal error
	XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120232242.GA16776@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
	<20090120133521.GD10158@disturbed>
	<20090120230306.GE10158@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090120230306.GE10158@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, Jacek Luczak <difrost.kernel@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Wed, Jan 21, 2009 at 10:03:06AM +1100, Dave Chinner wrote:
> [XFS] Long btree pointers are still 64 bit on disk
> 
> On 32 bit machines with CONFIG_LBD=n, XFS reduces the
> in memory size of xfs_fsblock_t to 32 bits so that it
> will fit within 32 bit addressing. However, the disk format
> for long btree pointers are still 64 bits in size.
> 
> The recent btree rewrite failed to take this into account
> when initialising new btree blocks, setting sibling pointers
> to NULL and checking if they are NULL. Hence checking whether
> a 64 bit NULL was the same as a 32 bit NULL was failingi
> resulting in NULL sibling pointers failing to be detected
> correctly. This showed up as WANT_CORRUPTED_GOTO shutdowns
> in xfs_btree_delrec.
> 
> Fix this by making all the comparisons and setting of long
> pointer btree NULL blocks to the disk format, not the
> in memory format. i.e. use NULLDFSBNO.

Thanks, this fixes the testcase for me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
