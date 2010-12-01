Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1Cep1V207442 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 06:40:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69D751BA274
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 04:42:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id m2zCzzLfuPlb0TYe for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 04:42:35 -0800 (PST)
Date: Wed, 1 Dec 2010 07:42:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/14] xfs: convert log grant heads to LSN notation
Message-ID: <20101201124234.GB612@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-4-git-send-email-david@fromorbit.com>
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

The patch looks good to me, but I really hate overloading the lsn types
and helpers.  Just add duplicated of CYCLE_LSN/BLOCK_LSN and
xlog_assign_lsn for a new type as use them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
