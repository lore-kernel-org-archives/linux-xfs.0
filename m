Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4SIOO2P235711 for <xfs@oss.sgi.com>; Fri, 28 May 2010 13:24:24 -0500
Subject: Re: [PATCH] xfs: fix access to upper inodes without inode64
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100527190515.GA16102@infradead.org>
References: <20100527190515.GA16102@infradead.org>
Date: Fri, 28 May 2010 13:19:19 -0500
Message-ID: <1275070759.2302.14.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2010-05-27 at 15:05 -0400, Christoph Hellwig wrote:
> If a filesystem is mounted without the inode64 mount option we should still
> be able to access inodes not fitting into 32 bits, just not created new
> ones.  For this to work we need to make sure the inode cache radix tree
> is initialized for all allocation groups, not just those we plan to allocate
> inodes from.  This patch makes sure we initialize the inode cache radix
> tree for all allocation groups, and also cleans xfs_initialize_perag up
> a bit to separate the inode32 logical from the general perag structure
> setup.

This looks generally good, but I have a comment below that
is not a bug now but could become one.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2010-05-27 20:59:09.191004330 +0200
> +++ xfs/fs/xfs/xfs_mount.c	2010-05-27 20:59:43.290004329 +0200

. . .

> @@ -497,30 +489,30 @@ xfs_initialize_perag(
>  		} else {
>  			max_metadata = agcount;
>  		}
> +
>  		for (index = 0; index < agcount; index++) {
>  			ino = XFS_AGINO_TO_INO(mp, index, agino);
> -			if (ino > max_inum) {
> +			if (ino > XFS_MAXINUMBER_32) {
>  				index++;
>  				break;
>  			}
>  
> -			/* This ag is preferred for inodes */
>  			pag = xfs_perag_get(mp, index);
>  			pag->pagi_inodeok = 1;
>  			if (index < max_metadata)
>  				pag->pagf_metadata = 1;
> -			xfs_initialize_perag_icache(pag);
>  			xfs_perag_put(pag);
>  		}
> +
> +		*maxagi = agcount;

Here you unconditionally assign to *maxagi...

>  	} else {
> -		/* Setup default behavior for smaller filesystems */
>  		for (index = 0; index < agcount; index++) {
>  			pag = xfs_perag_get(mp, index);
>  			pag->pagi_inodeok = 1;
> -			xfs_initialize_perag_icache(pag);
>  			xfs_perag_put(pag);
>  		}
>  	}
> +
>  	if (maxagi)
>  		*maxagi = index;

...while here it checks to be sure it's non-null before
assigning.  Right now, the two places that call this
function always pass the address of something.  I don't
care which way it goes, but the two assignments should
be done consistently (either both or neither should check
for null before assignment).

Other than that, this change looks really good.  Unless I
hear from you otherwise, I'll make the change before commit.
I will make both (all) spots assume a valid pointer is
passed in.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
