Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22B5B29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 04:46:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEA9CAC001
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 02:46:32 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8AsRldegyrpFB8bf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 02:46:31 -0800 (PST)
Date: Mon, 2 Dec 2013 02:46:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/15] mkfs: factor boolean option parsing
Message-ID: <20131202104631.GD21394@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-6-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:43:40PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Many of the options passed to mkfs have boolean options (0 or 1) and
> all hand roll the same code and validity checks. Factor these out
> into a common function.
> 
> Note that the lazy-count option is now changed to match other
> booleans in that if you don't specify a value, it reverts to the
> default value (on) rather than throwing an error. Similarly the -m
> crc and -n ftype options default to off rather than throwing an
> error.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Unrelated question that came up when reading through this patch:

should we start deprecating some options that have long been the
default, like lazy-count or attrv1?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
