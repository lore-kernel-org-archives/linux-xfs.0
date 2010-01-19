Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9QnjG180625 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:26:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 132F91735C8
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:27:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bMGGQH0srfviRnqA for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:27:49 -0800 (PST)
Date: Tue, 19 Jan 2010 04:27:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfs: clean up sign warnings in dir2 code
Message-ID: <20100119092749.GF7168@infradead.org>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
	<1263861026-13448-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861026-13448-8-git-send-email-david@fromorbit.com>
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

On Tue, Jan 19, 2010 at 11:30:25AM +1100, Dave Chinner wrote:
> We are now consistently using unsigned char strings for names
> so fix up the remaining warnings in the dir2 code to complete
> the cleanup.

The cast in the initializers looks a bit ugly, but I don't know a better
way either.
Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
