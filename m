Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46048 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750924AbeADSMJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 13:12:09 -0500
Subject: Re: [PATCH 2/5] xfs_db: check should deal with cow staging events
 correctly
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
 <151500481975.7713.14990901464976914162.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <01dcfb24-10b8-e6b1-12cf-326672c203a9@sandeen.net>
Date: Thu, 4 Jan 2018 12:12:07 -0600
MIME-Version: 1.0
In-Reply-To: <151500481975.7713.14990901464976914162.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/3/18 12:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach xfs_check to record cow staging events correctly.  This means that
> we strip off the high bit before using startblock.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
> 
