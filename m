Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G6NZVR071788 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 01:23:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C16E1C452EF
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:23:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZXQNHBxKwt6KVoAj for
	<xfs@oss.sgi.com>; Sun, 15 Mar 2009 23:23:14 -0700 (PDT)
Date: Mon, 16 Mar 2009 02:23:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] [XFSQA] Reduce the number of processes forked
Message-ID: <20090316062313.GA30641@infradead.org>
References: <1237114181-18431-1-git-send-email-david@fromorbit.com>
	<1237114181-18431-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237114181-18431-2-git-send-email-david@fromorbit.com>
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

On Sun, Mar 15, 2009 at 09:49:39PM +1100, Dave Chinner wrote:
> One of the big cpu time consumers when running xfsqa on UML
> is forking of new processes. when looping lots of times,
> using 'expr' to calculate the loop counter increment means
> we fork at least once every loop. using shell builtins means
> that we don't fork and many tests run substantially faster.
> 
> Some tests are even runnable with this modification. e.g. 110
> went from taking 4500s to run down to 9s with the loop iterators
> changed to avoid forking.

Looks good.

Care to see if any tests should be added to the quick group after this?
The above 110 sounds like a candidate for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
