Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ID0u3I129297 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 07:00:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A9D31EA063B
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:03:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wKrPQhx67VAG4hTU for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 05:03:14 -0800 (PST)
Date: Tue, 18 Jan 2011 08:03:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH 0/12] xfs: rework error logging infrastructure
Message-ID: <20110118130314.GC23988@infradead.org>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

The series looks good to me.  One thing that feels a bit odd is
the xfs_printk.[ch] name - the functions exported to the rest of the
code don't contain prink anyway.  Maybe xfs_msg.[ch] or
xfs_message.[ch]?

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

for the whole series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
