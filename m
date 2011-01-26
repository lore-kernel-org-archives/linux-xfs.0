Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QKV1wQ162909 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 14:31:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 524141A32FD1
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 12:33:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9xDeVFpYl0Yys1gC for
	<xfs@oss.sgi.com>; Wed, 26 Jan 2011 12:33:26 -0800 (PST)
Date: Wed, 26 Jan 2011 15:33:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfstests: add simple splice test
Message-ID: <20110126203324.GA19159@infradead.org>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295927937-20634-2-git-send-email-david@fromorbit.com>
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

On Tue, Jan 25, 2011 at 02:58:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't have any coverage of the splice functionality provided by
> the kernel in xfstests. Add a simple test that uses the sendfile
> operation built into xfs_io to copy a file ensure we at least
> execute the code path in xfstests.

I'm pretty sure I reviewed this one before, but in case it's needed here
it is again:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
