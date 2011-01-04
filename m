Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p049onCj219210 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 03:50:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86F221618B8B
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 01:52:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Yz3L4ThRFsL1fjwU for
	<xfs@oss.sgi.com>; Tue, 04 Jan 2011 01:52:57 -0800 (PST)
Date: Tue, 4 Jan 2011 04:52:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] repair: warn if running in low memory mode
Message-ID: <20110104095256.GA26885@infradead.org>
References: <1294121563-17150-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294121563-17150-1-git-send-email-david@fromorbit.com>
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

On Tue, Jan 04, 2011 at 05:12:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When checking large filesystems, xfs_repair makes an estimate of how
> much RAM it will need to execute effectively. If the amount of RAM
> is less than this, it reduces the bhash size and turns of
> prefetching, which will substantially slow down the repair process.
> Add a warning that indicates this is happening, along with a
> recommendation of how much RAM repair calculates it needs to run
> with prefetching enabled.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +				do_warn(_("Not enough RAM available for repair "
> +					"to enable prefetching. This will be "
> +					"_slow_.\n"
> +					"You need at least %luMB RAM to run "
> +					"with prefetching enabled."),
> +					mem_used * 1280 / (1024 * 1024));

Maybe but the strings on a separate line to be easier readable and
greppable, e.g.:

				do_warn(
	_("Not enough RAM available for repair to enable prefetching. "
	  "This will be _slow_.\n"
	  "You need at least %luMB RAM to run with prefetching enabled."),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
