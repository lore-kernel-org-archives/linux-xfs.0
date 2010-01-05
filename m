Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05HgfE8224987 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 11:42:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA76B1C2F06F
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 09:43:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XswLCgH0LHjB9fqd for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2010 09:43:32 -0800 (PST)
Date: Tue, 5 Jan 2010 12:43:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: NFS export broke with change from ext3 to xfs
Message-ID: <20100105174332.GA14496@infradead.org>
References: <1262652500.24160.27.camel@oxygen.netxsys.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262652500.24160.27.camel@oxygen.netxsys.com>
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
To: Krzysztof Adamski <k@adamski.org>
Cc: xfs@oss.sgi.com

Remove the inode64 mount option or move every export to a separate
filesystem.  The NFS code can't cope with 64 bit inode numbers when
exporting a subtree of a filesystem.  You'd see the same issue with e.g.
ocfs2 or gfs2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
