Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6TKqAnZ070210 for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 15:52:16 -0500
Date: Thu, 29 Jul 2010 16:55:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: negative_icount.patch V2
Message-ID: <20100729205514.GA6737@infradead.org>
References: <1280434718.7149.4.camel@superior.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280434718.7149.4.camel@superior.americas.sgi.com>
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
To: Stuart Brodsky <sbrodsky@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 29, 2010 at 03:18:38PM -0500, Stuart Brodsky wrote:
> can somebody please review this for me?

For a start it's still missing a useful subject line.

> +       long long               i;

Very bad naming of the variable, something like ffree would bebetter.
Also to fit with the rest of XFS it probably should be a __int64_t.

> +       i = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
> +       if( i < 0 )

wrong indentation.

> +               statp->f_ffree = 0;     /* cap at 0 */
> +       else
> +               statp->f_ffree = (__u64)i;

and it could probably done simpler as a

	statp->f_ffree = max_t(__int64_t, 0,
			statp->f_files + sbp->sb_ifree - sbp->sb_icount));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
