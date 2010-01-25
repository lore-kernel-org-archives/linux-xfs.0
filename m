Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PC36Rg052673 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 06:03:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF7F01C77A81
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:04:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jVjB4XRM13GyBsgs for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:04:10 -0800 (PST)
Date: Mon, 25 Jan 2010 07:04:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: kill the unused XFS_QMOPT_* flush flags
Message-ID: <20100125120410.GG8595@infradead.org>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264400564-19704-7-git-send-email-david@fromorbit.com>
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

> +		error = xfs_qm_dqflush(dqp, (flags & SYNC_WAIT));

Just pass down the full flags, the other flag is ignored by
xfs_qm_dqflush.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
