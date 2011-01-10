Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AJKr91033447 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:20:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 560C01D1F412
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:23:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DMllbSlKAvcOhxt6 for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:23:06 -0800 (PST)
Date: Mon, 10 Jan 2011 14:23:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking the
	inode
Message-ID: <20110110192305.GF25029@infradead.org>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
	<1294399825-1157-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294399825-1157-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL);

this now takes i_mutex, which will be taken again by
generic_file_splice_write.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
