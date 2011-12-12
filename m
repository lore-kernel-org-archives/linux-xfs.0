Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCMgUV5126065 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:42:30 -0600
Received: from newverein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E93916F0224
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 14:42:29 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id bn2FZItXzUNIDWoX for
	<xfs@oss.sgi.com>; Mon, 12 Dec 2011 14:42:29 -0800 (PST)
Date: Mon, 12 Dec 2011 23:42:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix acl count validation in xfs_acl_from_disk()
Message-ID: <20111212224227.GA17461@lst.de>
References: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
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
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Dec 12, 2011 at 04:55:52PM -0500, Xi Wang wrote:
> Commit fa8b18ed didn't prevent the integer overflow and possible
> memory corruption.  "count" can go negative and bypass the check.

Thanks, this looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
