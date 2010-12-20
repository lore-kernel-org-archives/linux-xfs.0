Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBX14i115909 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:33:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16E1F146CC53
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:34:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eQxFkyZJ9w9XhFwQ for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:34:58 -0800 (PST)
Date: Mon, 20 Dec 2010 06:34:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] xfs: convert log grant ticket queues to list heads
Message-ID: <20101220113458.GA12806@infradead.org>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292215483-18224-2-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 03:44:32PM +1100, Dave Chinner wrote:
> -		__field(void *, reserve_headq)
> -		__field(void *, write_headq)
> +		__field(void *, reserveq)
> +		__field(void *, writeq)

To repeat my question from the last review:  what's the point in logging
this at all?  There's not much we can do with it from trace-cmd / perf
output.  What might be more useful is a list_empty() boolean flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
