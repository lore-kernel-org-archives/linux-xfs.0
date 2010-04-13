Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DNcOrl013126 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 18:38:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAC132BEE29
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 16:40:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	Pd2JvHuuxANIrCpB for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 16:40:17 -0700 (PDT)
Date: Wed, 14 Apr 2010 09:40:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: wait for direct I/O to complete in fsync and
	write_inode
Message-ID: <20100413234015.GB2493@dastard>
References: <20100306132018.GA31360@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100306132018.GA31360@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 08:20:18AM -0500, Christoph Hellwig wrote:
> 
> We need to wait for all pending direct I/O requests before taking care of
> metadata in fsync and write_inode.

Sorry, I missed this one when scaning the list for outstanding
patches yesterday. The concept looks fine, though:

> Note that the write_inode hunk will causes conflicts when merging with
> mainline, I'm not sure how to best deal with that.

I don't think it applies to the current xfs-dev tree any more,
either.  Can you rebase it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
