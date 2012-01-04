Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04IgQvJ163527 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 12:42:27 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0TH2jhnOKKzsvlJO for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 10:42:25 -0800 (PST)
Date: Wed, 4 Jan 2012 13:42:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: use btrfsck to check btrfs filesystems
Message-ID: <20120104184224.GB8131@infradead.org>
References: <4EE851B8.8010505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE851B8.8010505@cn.fujitsu.com>
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
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 03:35:20PM +0800, Miao Xie wrote:
> We failed to get fsck program to check the btrfs file system, it is
> because btrfs uses its independent check tool which is named btrfsck
> to check the file system, so the common checker -- fsck -- could not
> find it, and reported there is no checker.
> 
> This patch fix it by using btrfsck directly. 
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
