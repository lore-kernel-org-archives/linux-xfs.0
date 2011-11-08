Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8J77XF144643 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 13:07:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 408D11CEE7A1
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 11:07:01 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SLuWDcnkw7UaiZG6 for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 11:07:01 -0800 (PST)
Date: Tue, 8 Nov 2011 14:07:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_repair: Properly set lost+found inode as used
Message-ID: <20111108190700.GA7941@infradead.org>
References: <1320777990-6556-1-git-send-email-cmaiolino@redhat.com>
	<1320777990-6556-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320777990-6556-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 04:46:30PM -0200, Carlos Maiolino wrote:
> This patch makes mk_orphanage() to properly set the inode link count of
> the recently allocated inode in the AVL tree, avoiding the lost+found
> directory to be bypass the link count check in phase7 and possibly leaving
> lost+found directory with a wrong link count.

Thanks a lot, this looks very good technically.

Unfortunately I have a few style nipicks anyway:

> @@ -875,6 +877,18 @@ mk_orphanage(xfs_mount_t *mp)
>  			ORPHANAGE, error);
>  	}
>  	ip->i_d.di_nlink++;		/* account for . */
> +	ino = ip->i_ino;
> +
> +	irec = find_inode_rec(mp,
> +			XFS_INO_TO_AGNO(mp, ino),
> +			XFS_INO_TO_AGINO(mp,ino));

Please always use whitespaces after the comma.

> +	ino_offset = get_inode_offset(mp, ino, irec);
> +
> +	/* Set the inode allocated to lost+found as used in the AVL
> + 	 * tree, so it is not bypassed in phase 7
> + 	 */

The canonical comment style would be:

	/*
	 * Mark the inode allocated to lost+found as used in the AVL tree
	 * so it is not skipped in phase 7.
	 */

(also note the slight change in wording to make it easier to parse for
 me, but I'm no native speaker either)
	 *

> +	set_inode_used(irec,ino_offset);
> +	add_inode_ref(irec,ino_offset);

Same whitespace comment as above here.

Feel free to add my:

Reviewed-by: Christoph Hellwig <hch@lst.de>

after these cosmetic fixups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
