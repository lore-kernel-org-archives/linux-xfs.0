Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RJdftT218043 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 14:39:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 655DA9AA31
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 12:39:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JPULl5pTPRdIMBTq for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 12:39:40 -0700 (PDT)
Date: Wed, 27 Jul 2011 15:39:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Message-ID: <20110727193937.GA5354@infradead.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 27, 2011 at 03:35:01PM -0400, Justin Piszcz wrote:
> Currently I do not see any dupes, however I have a script that moves
> images out of the directory once an hour:
> 0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1

Do you keep adding files to the directory while you move files out?
What's the rate of additions/removals to the directory?

If we add files to the directory while removing others we could easily
re-use the same offset for a different file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
