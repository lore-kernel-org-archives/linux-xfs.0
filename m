Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3C427CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 12:06:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9170DAC004
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 10:06:03 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KQzeelV6jt5Td65a (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2016 10:05:56 -0800 (PST)
Date: Thu, 4 Feb 2016 10:05:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: reflink log reservations
Message-ID: <20160204180551.GB27899@birch.djwong.org>
References: <20160204074617.GB20496@lst.de>
	<20160204081620.GL20038@birch.djwong.org>
	<20160204133133.GA28701@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160204133133.GA28701@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Feb 04, 2016 at 02:31:33PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 04, 2016 at 12:16:20AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 04, 2016 at 08:46:17AM +0100, Christoph Hellwig wrote:
> > > Hi Darrick,
> > > 
> > > I'm running into the following log reservation assert after a few
> > > xfstests runs over NFS.  I'll try to understand the reservation
> > > calculations, but in case this is still fresh in your head here's
> > > a headsup:
> > 
> > Hmm, interesting, I haven't seen /that/ one... my guess is that the
> > block reservation needs to be bumped up for the refcount tree.
> 
> This seems to fix it for me:
> 
> ---
> From 6e27eb42ece3a25f610690487b403a0091cafa26 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 4 Feb 2016 13:50:16 +0100
> Subject: xfs: account for the refcount btree in the alloc/free log reservation
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index d495f82..f4c2648 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -65,12 +65,15 @@ xfs_calc_buf_res(
>  
>  /*
>   * Per-extent log reservation for the allocation btree changes
> - * involved in freeing or allocating an extent. When rmap is not enabled,
> - * there are only two trees that will be modified (free space trees), and when
> - * rmap is enabled there will be three (freespace + rmap trees). The number of
> - * blocks reserved is based on the formula:
> + * involved in freeing or allocating an extent.
>   *
> - * num trees * ((2 blocks/level * max depth) - 1)
> + * There are at least two trees that will be modified (free space trees), when
> + * rmap is enabled there will be an additional rmap tree, and when reflinks
> + * are enabled there will be a refcount btree as well
> + *
> + * The number of  blocks reserved is based on the formula:
> + *
> + *     num trees * ((2 blocks/level * max depth) - 1)

Huh, could've sworn I used to have a patch that does this... but I can't find
it, so it clearly fell out.  Thanks for the patch.

--D

>   */
>  static uint
>  xfs_allocfree_log_count(
> @@ -81,6 +84,8 @@ xfs_allocfree_log_count(
>  
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		num_trees++;
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		num_trees++;
>  
>  	return num_ops * num_trees * (2 * mp->m_ag_maxlevels - 1);
>  }
> -- 
> 2.1.4
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
