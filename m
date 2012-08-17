Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HCNVLT034708 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 07:23:31 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7K4wIC0flksy87kn (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 05:23:30 -0700 (PDT)
Date: Fri, 17 Aug 2012 08:23:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: minor inode64 mount option cleanup
Message-ID: <20120817122329.GB2502@infradead.org>
References: <501943B5.4030309@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501943B5.4030309@inktank.com>
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
To: Alex Elder <elder@inktank.com>
Cc: xfs@oss.sgi.com

> @@ -295,12 +295,13 @@ xfs_parseargs(
>  			}
>  			dswidth = simple_strtoul(value, &eov, 10);
>  		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
> +#if XFS_BIG_INUMS
>  			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -#if !XFS_BIG_INUMS
> +#else /* !XFS_BIG_INUMS */

Looks good for now, but in the long run I'd prefer thast XFS simplify
requires 64-bit block numbers like gfs2 as there's not too much of a
point using it in a super-constrained envrionment and we could kill
all the XFS_BIG_INUMS conditionals, as well as the types that are
different based on the in-memory block number size.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
