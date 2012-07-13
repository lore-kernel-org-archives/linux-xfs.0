Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D6Gu52121894 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 01:16:56 -0500
Date: Fri, 13 Jul 2012 02:16:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120713061651.GA20909@infradead.org>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120712230421.GE29979@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120712230421.GE29979@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 12, 2012 at 06:04:21PM -0500, Ben Myers wrote:
> xfs/fs/xfs/xfs_buf.c:1062: error: static declaration of ???xfs_bdstrat_cb??? follows non-static declaration
> xfs/fs/xfs/xfs_buf.h:183: error: previous declaration of ???xfs_bdstrat_cb??? was here
> 
> CONFIG_XFS_DEBUG was not set.
> 
> I'm happy to have caught that before pulling this in.  Most of the time I am
> testing with CONFIG_XFS_DEBUG=y.  I'll fix it up.

The one in the header should just go away, that's why I moved
xfs_bwrite.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
