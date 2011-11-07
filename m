Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA77cDsA045625 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 01:38:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 801DE162222E
	for <xfs@oss.sgi.com>; Sun,  6 Nov 2011 23:38:11 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Guk0gsxmYRUmuBjZ for <xfs@oss.sgi.com>;
	Sun, 06 Nov 2011 23:38:11 -0800 (PST)
Date: Mon, 7 Nov 2011 02:38:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 075 112 redirect stderr of fsx to /dev/null too
Message-ID: <20111107073808.GA14283@infradead.org>
References: <1319941555-4405-1-git-send-email-guaneryu@gmail.com>
	<20111106230631.GD5534@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111106230631.GD5534@dastard>
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
Cc: Eryu Guan <guaneryu@gmail.com>, xfs@oss.sgi.com

On Mon, Nov 07, 2011 at 10:06:31AM +1100, Dave Chinner wrote:
> If this hasn't been committed, the correct fix is to pass the "-q"
> option to fsx to tell it not to emit these messages. We still really
> want any other output to stderr to cause a test failure....

I already commited it.  I'll also take care of fixing it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
