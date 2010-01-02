Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02DGC7M112279 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 07:16:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C00A11376DE
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 05:17:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kpfOY93CL1Rh24vf for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 05:17:02 -0800 (PST)
Date: Sat, 2 Jan 2010 08:17:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Don't flush stale inodes
Message-ID: <20100102131701.GA17320@infradead.org>
References: <1262399980-19277-1-git-send-email-david@fromorbit.com>
	<20100102120053.GB18502@infradead.org>
	<20100102122405.GI13802@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102122405.GI13802@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

This looks like a bigger problem to me.  We only mark inodes as stale
from xfs_ifree_cluster, which via xfs_ifree and xfs_inactive gets
called from xfs_fs_clear_inode.  Given that the inode has now been
deleted we should not mark it as reclaimable in xfs_fs_destroy_inode
but go on to reap it given that there is nothing to reclaim.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
