Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73LmxLp116868 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 16:49:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 005791448F2F
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 14:49:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id a9FsUAVnwcrcK6XZ for
	<xfs@oss.sgi.com>; Mon, 03 Aug 2009 14:49:35 -0700 (PDT)
Date: Mon, 3 Aug 2009 17:49:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
Message-ID: <20090803214929.GB3167@infradead.org>
References: <1249329808.7686.26.camel@logos>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1249329808.7686.26.camel@logos>
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
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: xfs@oss.sgi.com, hch@lst.de, linux-kernel@vger.kernel.org, mszeredi@novell.com

On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
> The __xfs_get_blocks function does not check if the pointer to the target
> device is valid before dereferencing it.

It should never be zero.  It's set by xfs_imap_to_bmap to either
mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
which is always allocated if we have a realtime device, and
XFS_IS_REALTIME_INODE should only be true in that case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
