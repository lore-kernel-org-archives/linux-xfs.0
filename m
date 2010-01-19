Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9XfNm181015 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:33:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8187A124D0F9
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:34:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ppFXd4HhkAaSiXbF for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:34:41 -0800 (PST)
Date: Tue, 19 Jan 2010 04:34:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfsprogs: fix some trivial warnings in xfs_db
Message-ID: <20100119093440.GA15482@infradead.org>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
	<1263861413-13729-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861413-13729-4-git-send-email-david@fromorbit.com>
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

On Tue, Jan 19, 2010 at 11:36:49AM +1100, Dave Chinner wrote:
> Three warnings, none harmful - one dir2 name sign warning and
> two cases where gcc can't work out if a variable is initialised
> correctly in a child function or not.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  db/check.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 7620d9c..f94a16b 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2317,7 +2317,7 @@ process_data_dir_v2(
>  		tag_err += be16_to_cpu(*tagp) != (char *)dep - (char *)data;
>  		addr = xfs_dir2_db_off_to_dataptr(mp, db,
>  			(char *)dep - (char *)data);
> -		xname.name = (char *)dep->name;
> +		xname.name = (uchar_t *)dep->name;

Aren't hese now both unsigned after the kernel changes are sycned over?

And btw, please also avoid uchar_t in xfsprogs, it will be gone with
next full libxfs resync.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
