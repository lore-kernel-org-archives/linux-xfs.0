Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02A9D7F58
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 09:47:05 -0600 (CST)
Date: Thu, 30 Jan 2014 09:47:01 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: ensure correct timestamp updates from truncate
Message-ID: <20140130154701.GP1935@sgi.com>
References: <20140110122700.GA12624@localhost> <52CFF402.5080409@oracle.com>
	<20140110133306.GA22918@infradead.org>
	<52CFFD1C.7050005@oracle.com>
	<20140111111045.GA29380@infradead.org>
	<52E8FE81.7040402@redhat.com>
	<20140130080652.GA23758@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140130080652.GA23758@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Jan 30, 2014 at 12:06:52AM -0800, Christoph Hellwig wrote:
> The VFS doesn't set the proper ATTR_CTIME and ATTR_MTIME values for truncate,
> so filesystems have to manually add them.  The introduction of
> xfs_setattr_time accidentally broke this special case an caused a
> regression in generic/313.  Fix this by removing the local mask variable
> in xfs_setattr_size so that we only have a single place to keep the
> attribute information.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>

That is v3.13-rc2-14-gc91c46c, so I believe we'll want to Cc: stable on this
one.  Correct?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
