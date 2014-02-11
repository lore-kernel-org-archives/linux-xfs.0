Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34D877F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 01:31:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 133F68F8050
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 23:31:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1E1aotaoRkAL6Klu for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 23:31:07 -0800 (PST)
Date: Tue, 11 Feb 2014 18:31:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 08/11] xfs: update the finobt on inode free
Message-ID: <20140211073103.GI13647@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-9-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391536182-9048-9-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 12:49:39PM -0500, Brian Foster wrote:
> An inode free operation can have several effects on the finobt. If
> all inodes have been freed and the chunk deallocated, we remove the
> finobt record. If the inode chunk was previously full, we must
> insert a new record based on the existing inobt record. Otherwise,
> we modify the record in place.
> 
> Create the xfs_ifree_finobt() function to identify the potential
> scenarios and update the finobt appropriately.

Couple of minor things....

> +	 * Read and update the existing record.
> +	 */
> +	error = xfs_inobt_get_rec(cur, &rec, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +
> +	rec.ir_free |= XFS_INOBT_MASK(offset);
> +	rec.ir_freecount++;
> +
> +	XFS_WANT_CORRUPTED_GOTO((rec.ir_free == ibtrec->ir_free) &&
> +				(rec.ir_freecount == ibtrec->ir_freecount),
> +				error);

I'd add a small comment here saying:

	/*
	 * We could just copy the ibtrec across here, but that
	 * defeats the purpose of having redundant metadata. By
	 * doing the modifications independently, we can catch
	 * corruptions that we wouldn't see if we just copied from
	 * one record to another.
	 */

> +	/*
> +	 * The content of inobt records should always match between the inobt
> +	 * and finobt. The lifecycle of records in the finobt is different from
> +	 * the inobt in that the finobt only tracks records with at least one
> +	 * free inode. This is to optimize lookup for inode allocation purposes.
> +	 * The following checks determine whether to update the existing record or
> +	 * remove it entirely.
> +	 */
> +

extra whitespace line

> +	if (rec.ir_freecount == XFS_IALLOC_INODES(mp) &&
> +	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> +		/*
> +		 * If all inodes are free and we're in !ikeep mode, the entire
> +		 * inode chunk has been deallocated. Remove the record from the
> +		 * finobt.
> +		 */
> +		error = xfs_btree_delete(cur, &i);
> +		if (error)
> +			goto error;
> +		ASSERT(i == 1);
> +	} else {
> +		/*
> +		 * The existing finobt record was modified and has a combination
> +		 * of allocated and free inodes or is completely free and ikeep
> +		 * is enabled. Update the record.
> +		 */
> +		error = xfs_inobt_update(cur, &rec);
> +		if (error)
> +			goto error;
> +	}

All th comments say pretty much the same thing, and repeat what the
code does. Hence I think this is sufficient:

	/*
	 * The content of inobt records should always match between the inobt
	 * and finobt. The lifecycle of records in the finobt is different from
	 * the inobt in that the finobt only tracks records with at least one
	 * free inode. Hence if all the inodes are free and we aren't keeping
	 * inode chunks permanently on disk, remove them. Otherwise just
	 * update the record with the new information.
	 */
	if (rec.ir_freecount == XFS_IALLOC_INODES(mp) &&
	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
		error = xfs_btree_delete(cur, &i);
		if (error)
			goto error;
		ASSERT(i == 1);
	} else {
		error = xfs_inobt_update(cur, &rec);
		if (error)
			goto error;
	}

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
