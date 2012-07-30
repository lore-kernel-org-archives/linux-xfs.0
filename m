Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UHL72g069197 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 12:21:07 -0500
Message-ID: <5016C27C.9060700@sgi.com>
Date: Mon, 30 Jul 2012 12:21:00 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] xfs: merge xfs_ialloc_ag_select into xfs_dialloc
References: <20120704145444.863203951@bombadil.infradead.org>
	<20120704145616.894941902@bombadil.infradead.org>
	<501182AE.2090109@sgi.com>
In-Reply-To: <501182AE.2090109@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/26/12 12:47, Mark Tinguely wrote:
>
>
> + if (pass < 2) {
> + /*
> + * Is there enough free space for the file plus a block
> + * of inodes?
> + */
> + xfs_extlen_t longest = pag->pagf_longest;
> + int needspace =
> + S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> +
> + if (!longest)
> + longest = pag->pagf_flcount > 0;
> +
> + if (pag->pagf_freeblks <
> + XFS_IALLOC_BLOCKS(mp) + needspace)
> + goto nextag;
> ^^^^^^^ here
>
> + if (longest < XFS_IALLOC_BLOCKS(mp))
> + goto nextag;
>
> ^^^^^^^ and here
> + }
>
> Isn't the agbp locked from the earlier xfs_ialloc_read_agi()?
> Do we want to release them before going on to the next AG?
>
> Thank-you,
>
> --Mark.
>

same line of thought as above:


+		if (!pag->pagf_init) {
+			int flags = pass ? 0 : XFS_ALLOC_FLAG_TRYLOCK;
+
+			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
+			if (error)
+				goto out_error;
+		}

Also, don't we still have the AGI buffer locked when we try to
initialize the AGF? If the AGF initialization fails, do we need to also
unlock the AGI buffer before returning?

Thank-you.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
