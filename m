Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o23CssI6077588 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 06:54:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D643D13D0082
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 04:56:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id X20p1AeDzq7OBea8 for
	<xfs@oss.sgi.com>; Wed, 03 Mar 2010 04:56:21 -0800 (PST)
Date: Wed, 3 Mar 2010 07:56:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfsqa: add delayed allocation @ ENOSPC exerciser
Message-ID: <20100303125619.GA26672@infradead.org>
References: <1267597162-12092-1-git-send-email-david@fromorbit.com>
	<1267597162-12092-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267597162-12092-2-git-send-email-david@fromorbit.com>
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

On Wed, Mar 03, 2010 at 05:19:20PM +1100, Dave Chinner wrote:
> +	killall -9 dd > /dev/null 2>&1

This seems a bit dangerous.  I have at least one old system that
uses dd to continously read the kernel message buffer in the
background, and there's tons of other potential dd uses.

Given that we now require bash and bash has array support you might
be able to store the pids of "our" dd instances in an array and
loop over them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
