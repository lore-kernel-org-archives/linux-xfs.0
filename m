Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0QNjMK5261721 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 17:45:23 -0600
In-Reply-To: <20090126073201.084826000@bombadil.infradead.org>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073201.084826000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <619A4CB0-9EA5-416C-80E3-0F86A2D9262F@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH 05/17] xfs: remove unused XFS_MOUNT_ILOCK/XFS_MOUNT_IUNLOCK
Date: Mon, 26 Jan 2009 17:43:59 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Jan 26, 2009, at 1:31 AM, Christoph Hellwig wrote:

> These aren't only unused but also reference a lock that doesn't  
> exist anymore.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, leftover from "kill deleted inode list" commit.

Reviewed-by: Felix Blyakher <felixb@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
