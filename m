Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA6647F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 23:58:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 934FCAC003
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:58:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5e4gEt17MRelZmkC for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 21:58:05 -0800 (PST)
Date: Thu, 3 Dec 2015 16:57:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfsprogs: xfsdb: remove unnessary checks in
	process_leaf_node_dir_v2_free
Message-ID: <20151203055752.GU26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-5-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449055167-19936-5-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 04:49:20PM +0530, Vivek Trivedi wrote:
> xfs_dir2_free_hdr_t entries are unsigned, so they can't be negative.
> remove these unnessary checks in process_leaf_node_dir_v2_free.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  db/check.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 9c1541d..9d986b9 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3073,9 +3073,7 @@ process_leaf_node_dir_v3_free(
>  		return;
>  	}
>  	if (be32_to_cpu(free->hdr.nvalid) > maxent || 
> -				be32_to_cpu(free->hdr.nvalid) < 0 ||
>  				be32_to_cpu(free->hdr.nused) > maxent || 
> -				be32_to_cpu(free->hdr.nused) < 0 ||
>  				be32_to_cpu(free->hdr.nused) > 
>  					be32_to_cpu(free->hdr.nvalid)) {
>  		if (!sflag || v)

Pretty meaningless, but I think we made this change libxfs code some
time ago, so we may as well change it here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
