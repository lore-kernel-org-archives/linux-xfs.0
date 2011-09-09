Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8980udX026863 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 03:00:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E794454BCDE
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 01:00:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pOGhGmzYhGHrzm13 for <xfs@oss.sgi.com>;
	Fri, 09 Sep 2011 01:00:52 -0700 (PDT)
Date: Fri, 9 Sep 2011 04:00:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ENOSPC and filesystem shutdowns
Message-ID: <20110909080051.GB31050@infradead.org>
References: <CAKxAxjFgBd0Vt02m7FJKq_ZWNBBJ5B=N4u7kS69FKtOKT4UowA@mail.gmail.com>
	<20110905074734.GA18504@infradead.org>
	<CAKxAxjFUMrQpb5kQUdpRdt2wx83oKxaLZPTVTR_j43dkhcOyyw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKxAxjFUMrQpb5kQUdpRdt2wx83oKxaLZPTVTR_j43dkhcOyyw@mail.gmail.com>
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
To: Bernard Chan <bernard@goanimate.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2011 at 07:09:55PM +0800, Bernard Chan wrote:
> So should we bother with inode64 and 64-bit servers with NFS4, and should we
> anticipate any other issues running on this setup with a 4TB volume without
> enabling inode64?

I would absolutely recommend using inode64 if your are running a pure
64-bit environment.  Even if you are not running out of inodes it will
give you a much better allocation pattern.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
