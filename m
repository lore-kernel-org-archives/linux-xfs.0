Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB6EVPfD253779 for <xfs@oss.sgi.com>; Mon, 6 Dec 2010 08:31:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6C06141E06F
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 06:33:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LBcv47EQwPNQ9gxW for
	<xfs@oss.sgi.com>; Mon, 06 Dec 2010 06:33:12 -0800 (PST)
Date: Mon, 6 Dec 2010 09:33:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: remove all the inodes on a buffer from the AIL
	in bulk
Message-ID: <20101206143308.GA31100@infradead.org>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290993152-20999-7-git-send-email-david@fromorbit.com>
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

While the patch looks good for the ail lock contetion removal, I don't
quite like the model with the double iteration over the log item list
on the buffer.  What do you think about the following plan:

 (1) merge xfs_istale_done into xfs_iflush_done by checking for
     XFS_ISTALE
 (2) convert not only the inode log item completion to your new scheme,
     but also the dquots
 (3) replace xfs_buf_do_callbacks with a callback in the buffer, which
     now points to the inode and dqout routines, or calls the completion
     for the only items in "normal" buf items.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
