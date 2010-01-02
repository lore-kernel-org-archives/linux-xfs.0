Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02BMeZr097876 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 05:22:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2118C1374BD
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 03:23:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ke9tztTBoQFSHgsH for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 03:23:30 -0800 (PST)
Date: Sat, 2 Jan 2010 06:23:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Ensure we force all busy extents in range to disk
Message-ID: <20100102112329.GA27329@infradead.org>
References: <1262399936-19195-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262399936-19195-1-git-send-email-david@fromorbit.com>
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

Looks good, and quite interestin that we never could it before.

Some nipicks below:

> +	/*
> +	 * search pagb_list for this slot, skipping open slots. We have to
> +	 * search the entire array as there may be multiple overlaps and
> +	 * we have to get the most recent LSN for the log force to push out
> +	 * all the transactions that span the range.
> +	 */
> +	for (bsy = pag->pagb_list; cnt; bsy++, cnt--) {

Maybe you coult convert this to a more standard loop idiom while you're
at it:

	for (cnt = 0; cnt < pag->pagb_count; cnt++) {
		bsy = &pag->pagb_list[cnt];

> +		if (!bsy->busy_tp)
> +			continue;
>  
> +		bend = bsy->busy_start + bsy->busy_length - 1;
> +		if ((bno > bend) || (uend < bsy->busy_start))

no need for the inner braces here.


And btw, the standard subsystem prefix is all lower case, xfs:, not
XFS:.

Also it seems like this patch requires your perag-lookup fixes first.
Time to get them into the for-2.6.34 git tree ASAP as a base to work
against.  That might also make it easier to work on the lockless patch
separately.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
