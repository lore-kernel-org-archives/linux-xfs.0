Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5QBgWJ4193677 for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 06:42:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7395F407130
	for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 04:45:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yvhxoR5OOOtibc2J for
	<xfs@oss.sgi.com>; Sat, 26 Jun 2010 04:45:16 -0700 (PDT)
Date: Sat, 26 Jun 2010 07:45:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: check for valid inode data pointer before
	dereferencing
Message-ID: <20100626114513.GB15157@infradead.org>
References: <1277418283-23381-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277418283-23381-1-git-send-email-david@fromorbit.com>
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

On Fri, Jun 25, 2010 at 08:24:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When processing an inode, the code checks various flags to determine
> whether to output messages or not. When checking the CLI provided
> inode numbers to be verbose about, we fail to check if the inode
> data structre returned is valid or not before dereferencing it.
> Hence running xfs_check with the "serious errors only" flag, xfs_db
> will crash. Fix up the "should we output" logic to be safe.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
