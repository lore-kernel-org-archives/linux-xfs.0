Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1DINuJ210361 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 07:18:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 282551404539
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 05:20:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 21ms22AqSnJd31Es for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 05:20:06 -0800 (PST)
Date: Wed, 1 Dec 2010 08:20:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/14] xfs: replace use of sv_t with waitqueues in the log
Message-ID: <20101201132006.GE22455@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-14-git-send-email-david@fromorbit.com>
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

On Mon, Nov 29, 2010 at 12:38:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Only the log still uses the old Irix wait queue interface. The log
> grant lock scaling series killed one of the users, so convert
> the remaining users of sv_t to plain wait queues so the sv_t wrapper can
> be removed.

Looks good, but as said before I'd prefer it to be merged with the
introduction of xlog_wait and the first sv_t removal.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
