Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24709 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753777AbcJZAtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 20:49:25 -0400
Date: Wed, 26 Oct 2016 11:49:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/39] xfs_db: add support for checking the refcount btree
Message-ID: <20161026004920.GD23194@dastard>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743667991.11035.9533585332530820648.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743667991.11035.9533585332530820648.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:04:39PM -0700, Darrick J. Wong wrote:
> Do some basic checks of the refcount btree.  xfs_repair will have to
> check that the reference counts match the various bmbt mappings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> @@ -1561,10 +1597,15 @@ check_set_dbmap(
>  			agbno, agbno + len - 1, c_agno, c_agbno);
>  		return;
>  	}
> -	check_dbmap(agno, agbno, len, type1);
> +	check_dbmap(agno, agbno, len, type1, is_reflink(type2));
>  	mayprint = verbose | blist_size;
>  	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
> -		*p = (char)type2;
> +		if (*p == DBM_RLDATA && type2 == DBM_DATA)
> +			;	/* do nothing */
> +		if (*p == DBM_DATA && type2 == DBM_DATA)
> +			*p = (char)DBM_RLDATA;
> +		else
> +			*p = (char)type2;

What this /* do nothing */ case for?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
