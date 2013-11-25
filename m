Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB51A7F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 07:48:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A83E4304048
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:48:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AN7YQGDknGSXaS8i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 05:48:21 -0800 (PST)
Date: Mon, 25 Nov 2013 05:48:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/4] xfs: add xfs_create_tmpfile() for O_TMPFILE
	support
Message-ID: <20131125134821.GB30189@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-3-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385379154-3802-3-git-send-email-zwu.kernel@gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 07:32:32PM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> The function is used to create one O_TMPFILE file.
> 
> http://oss.sgi.com/archives/xfs/2013-08/msg00339.html
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/xfs/xfs_inode.c       |  129 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h       |    2 +
>  fs/xfs/xfs_shared.h      |    4 +-
>  fs/xfs/xfs_trans_resv.c  |   35 ++++++++++++
>  fs/xfs/xfs_trans_resv.h  |    2 +
>  fs/xfs/xfs_trans_space.h |    2 +
>  6 files changed, 173 insertions(+), 1 deletions(-)

>  int
> +xfs_create_tmpfile(
> +	xfs_mount_t		*mp,
> +	umode_t			mode,
> +	dev_t			rdev,
> +	xfs_inode_t		**ipp)

Please use struct xfs_mount and struct xfs_inode for any new code.

> +	/*
> +	 * Initially assume that the file does not exist and
> +	 * reserve the resources for that case.  If that is not
> +	 * the case we'll drop the one we have and get a more
> +	 * appropriate transaction later.
> +	 */

I can't see how this comment makes any sense.

> +	tres = &M_RES(mp)->tr_create_tmpfile;
> +	error = xfs_trans_reserve(tp, tres, resblks, 0);
> +	if (error == ENOSPC) {
> +		/* flush outstanding delalloc blocks and retry */
> +		xfs_flush_inodes(mp);
> +		error = xfs_trans_reserve(tp, tres, resblks, 0);
> +	}
> +	if (error == ENOSPC) {
> +		/* No space at all so try a "no-allocation" reservation */
> +		resblks = 0;
> +		error = xfs_trans_reserve(tp, tres, 0, 0);
> +	}

Please factor this into a new xfs_trans_reserver_create helper (better
names welcome of course).
similar.

> +	/*
> +	 * Reserve disk quota and the inode.
> +	 */

I don't think that comment adds a whole lot of value.  (Same for the
other quota comment above).

> +	/*
> +	 * A newly created regular or special file just has one directory
> +	 * entry pointing to them, but a directory also the "." entry
> +	 * pointing to itself.
> +	 */

Given that we only create regular files here the comment can be removed.

>  
> +STATIC uint
> +xfs_calc_icreate_tmpfile_reservation(xfs_mount_t *mp)
> +{
> +	return XFS_DQUOT_LOGRES(mp) +
> +		xfs_calc_icreate_resv_alloc(mp) +
> +		xfs_calc_inode_res(mp, 1) +
> +		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
> +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
> +}
> +
> +STATIC uint
> +__xfs_calc_create_tmpfile_reservation(
> +	struct xfs_mount	*mp)
> +{
> +	return XFS_DQUOT_LOGRES(mp) +
> +		xfs_calc_create_resv_alloc(mp) +
> +		xfs_calc_inode_res(mp, 1) +
> +		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
> +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
> +}
> +
> +STATIC uint
> +xfs_calc_create_tmpfile_reservation(
> +	struct xfs_mount        *mp)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		return xfs_calc_icreate_tmpfile_reservation(mp);
> +	return __xfs_calc_create_tmpfile_reservation(mp);

Shouldn't we name this xfs_calc_create_tmpfile_reservation_v4 and _v5
or no postix and _crc?  Either way the double underscore naming looks
confusing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
