Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P9lU5s235264 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:47:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2819F1A1E94D
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:49:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id g3HaZX5rNlSA7jqx for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:49:53 -0800 (PST)
Date: Tue, 25 Jan 2011 04:49:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfs: prevent extsize alignment from exceeding
	maximum extent size
Message-ID: <20110125094953.GA23990@infradead.org>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295945444-29488-6-git-send-email-david@fromorbit.com>
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

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

> +					alen = XFS_FILBLKS_MIN( len,

just a little whitespace damage here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
