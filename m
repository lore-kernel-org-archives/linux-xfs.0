Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MH6nEh218047 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:06:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24EA24DA024
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 10:08:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wZZ6Tl5TsOdKxIOB for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 10:08:50 -0700 (PDT)
Date: Thu, 22 Apr 2010 13:08:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Improve scalability of busy extent tracking
Message-ID: <20100422170848.GA26101@infradead.org>
References: <1271828835-2094-1-git-send-email-david@fromorbit.com>
	<20100422110143.GA21867@infradead.org>
	<20100422161626.GE23541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422161626.GE23541@dastard>
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

Been looking at this a bit and I have a theory:

 - a tid is not actually unique to a xfs_trans structure, if
   we call xfs_trans_dup a single xlog_ticket, and with that the
   tid is re-used by multiple transaction structure.
 - because of that the major semantic change in the version vs
   the previous one is that we now do not force the synchronous
   transaction for the case where we re-used a block in
   the rolled over transaction.

Still not quite sure about the implications of this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
