Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUMvIqv148006 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 16:57:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82CC613F75E9
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:59:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YI1iEc3bJFsWf6wm for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:59:01 -0800 (PST)
Date: Tue, 30 Nov 2010 17:59:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/14] xfs: convert log grant ticket queues to list heads
Message-ID: <20101130225900.GA23850@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-2-git-send-email-david@fromorbit.com>
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

On Mon, Nov 29, 2010 at 12:38:19PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The grant write and reserve queues use a roll-your-own double linked
> list, so convert it to a standard list_head structure and convert
> all the list traversals to use list_for_each_entry(). We can also
> get rid of the XLOG_TIC_IN_Q flag as we can use the list_empty()
> check to tell if the ticket is in a list or not.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

A minor comment below:

> -		__field(void *, reserve_headq)
> -		__field(void *, write_headq)
> +		__field(void *, reserveq)
> +		__field(void *, writeq)

Not sure why added these to the traces originally, but imho
it's pretty pointless.  If we care at all we could log a boolean
flag if the queues are empty or not.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
