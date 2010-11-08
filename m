Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8AkQjc094694 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 04:46:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFAA613993D8
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 02:47:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LxYbfsemMlQ3SF61 for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 02:47:53 -0800 (PST)
Date: Mon, 8 Nov 2010 05:47:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20101108104750.GA19985@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-8-git-send-email-david@fromorbit.com>
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

I finally tracked down the xfsqa 065 regression, and it's caused by this
patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
