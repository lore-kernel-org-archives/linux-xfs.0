Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59546 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfGAM0R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 08:26:17 -0400
Date: Mon, 1 Jul 2019 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] mkfs: use libxfs to write out new AGs
Message-ID: <20190701122504.GM7777@dread.disaster.area>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114705924.1643538.6635085530435538461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114705924.1643538.6635085530435538461.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the libxfs AG initialization functions to write out the new
> filesystem instead of open-coding everything.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> @@ -4087,8 +3770,16 @@ main(
>  	/*
>  	 * Initialise all the static on disk metadata.
>  	 */
> +	INIT_LIST_HEAD(&buffer_list);
>  	for (agno = 0; agno < cfg.agcount; agno++)
> -		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist);
> +		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist,
> +				&buffer_list);
> +
> +	if (libxfs_buf_delwri_submit(&buffer_list)) {
> +		fprintf(stderr, _("%s: writing AG headers failed\n"),
> +				progname);
> +		exit(1);
> +	}

The problem I came across with this "one big delwri list" construct
when adding delwri lists for batched AIO processing is that the
memory footprint for high AG count filesystems really blows out. Did
you check what happens when you create a filesystem with a few tens
of thousands of AGs? 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
