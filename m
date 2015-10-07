Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2C147FAC
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 01:18:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3983304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:18:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	e3RRzZd7ZgNfBDwE for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2015 23:18:43 -0700 (PDT)
Date: Wed, 7 Oct 2015 17:18:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: per-filesystem stats counter implementation
Message-ID: <20151007061805.GE32150@dastard>
References: <1443802960-26662-1-git-send-email-billodo@redhat.com>
	<1443802960-26662-8-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443802960-26662-8-git-send-email-billodo@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 02, 2015 at 11:22:40AM -0500, Bill O'Donnell wrote:
> This patch modifies the stats counting macros and the callers
> to those macros to properly increment, decrement, and add-to
> the xfs stats counts. The counts for global and per-fs stats
> are correctly advanced, and cleared by writing a "1" to the
> corresponding clear file.
> 
> global counts: /sys/fs/xfs/stats/stats
> per-fs counts: /sys/fs/xfs/sda*/stats/stats
> 
> global clear:  /sys/fs/xfs/stats/stats_clear
> per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
....
> +#define __XFS_BTREE_STATS_INC(mp, type, stat) \
> +	XFS_STATS_INC(mp, xs_ ## type ## _2_ ## stat)
> +#define XFS_BTREE_STATS_INC(cur, stat)	\
>  do {    \
> +	struct xfs_mount *mp = cur->bc_mp; \

This will cause gcc to throw "shadow definition" warnings in
userspace as the macro will be used in functions that already have a
"mp" variable defined. In general, variables within a macro like
this are given a "__" prefix so such namespace collisions are
unlikely. I'll fix this up manually.

Otherwise looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
