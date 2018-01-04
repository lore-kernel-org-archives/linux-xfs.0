Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbeADSGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 13:06:31 -0500
Date: Thu, 4 Jan 2018 10:06:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs_db: check should deal with cow staging events
 correctly
Message-ID: <20180104180626.GA5602@magnolia>
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
 <151500481975.7713.14990901464976914162.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151500481975.7713.14990901464976914162.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 10:40:19AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> Subject: [PATCH 2/5] xfs_db: check should deal with cow staging events correctly

s/events/extents/

> Teach xfs_check to record cow staging events correctly.  This means that

s/events/extents/

> we strip off the high bit before using startblock.

high, indeed. :P

--D

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/check.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 3afde02..2f8dee5 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -4730,13 +4730,24 @@ scanfunc_refcnt(
>  		lastblock = 0;
>  		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
>  			if (be32_to_cpu(rp[i].rc_refcount) == 1) {
> -				dbprintf(_(
> -		"leftover CoW extent (%u/%u) len %u\n"),
> +				xfs_agblock_t	agbno;
> +				char		*msg;
> +
> +				agbno = be32_to_cpu(rp[i].rc_startblock);
> +				if (agbno >= XFS_REFC_COW_START) {
> +					agbno -= XFS_REFC_COW_START;
> +					msg = _(
> +		"leftover CoW extent (%u/%u) len %u\n");
> +				} else {
> +					msg = _(
> +		"leftover CoW extent at unexpected address (%u/%u) len %u\n");
> +				}
> +				dbprintf(msg,
>  					seqno,
> -					be32_to_cpu(rp[i].rc_startblock),
> +					agbno,
>  					be32_to_cpu(rp[i].rc_blockcount));
>  				set_dbmap(seqno,
> -					be32_to_cpu(rp[i].rc_startblock),
> +					agbno,
>  					be32_to_cpu(rp[i].rc_blockcount),
>  					DBM_COWDATA, seqno, bno);
>  			} else {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
