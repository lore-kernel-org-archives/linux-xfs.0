Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35BUOww243799 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 06:30:30 -0500
Date: Mon, 5 Apr 2010 07:32:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: encapsulate bbcount validity checking
Message-ID: <20100405113212.GA6338@infradead.org>
References: <201003182254.o2IMs6g0001880@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182254.o2IMs6g0001880@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 18, 2010 at 05:54:06PM -0500, Alex Elder wrote:
> This replaces is a duplicated block of essentially identical code
> in three spots with a call to a common helper routine.

I don't think I really like this.  It's adding a lot of indirections
for some simple error reporting.

> +	if (bbcount > 0 && bbcount <= log->l_logBBsize)
> +	    	return 1;

Adding a tiny helper just for this might be worthwhile, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
