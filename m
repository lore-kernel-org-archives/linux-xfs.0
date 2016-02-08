Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A4657CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:12:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B9D8304048
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:12:38 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id m9EOOPvJtKjRSzsG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 01:12:36 -0800 (PST)
Date: Mon, 8 Feb 2016 01:12:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: rename XFS_BUF_ZEROFLAGS macro
Message-ID: <20160208091235.GN5534@infradead.org>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
	<1454632683-20543-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454632683-20543-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Instead of just renaming it I'd rather dig deeper.

In xlog_bwrite we call xfs_bwrite, which already handles all flag
clearing, so the call to XFS_BUF_ZEROFLAGS can just
be removed.

xlog_sync already sets a lot of these flags again, and is called on an
iclog buffer which never has the READ or XBF_WRITE_FAIL set, so just
replacing it with an opencoded

	bp->b_flags &= (XBF_FUA | XBF_FLUSH);

for both instances should be enough, and even that could be moved
into and else clause of the

	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)

conditional.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
