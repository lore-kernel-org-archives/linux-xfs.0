Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AA137CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 04:15:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08DD9AC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 02:14:59 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6biNYqpUkO9HIBuG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 02:14:54 -0700 (PDT)
Date: Thu, 25 Aug 2016 02:14:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] misc: fix Coverity errors
Message-ID: <20160825091452.GE5685@infradead.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
	<147200549633.15538.18051281375686885659.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147200549633.15538.18051281375686885659.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 23, 2016 at 07:24:56PM -0700, Darrick J. Wong wrote:
> Fix various code sloppinesses pointed out by Coverity.
> 
> Coverity-id: 1371628 - 1371638

> @@ -75,6 +75,7 @@ fsmap(
>  	high.rm_owner = ULLONG_MAX;
>  	high.rm_offset = ULLONG_MAX;
>  	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK | XFS_RMAP_UNWRITTEN;
> +	high.rm_blockcount = low.rm_blockcount = 0;

Do the low initialization near the remaining low fields?

or better do a struct initialization ala

	struct xfs_rmap_irec low = { 0, };
	struct xfs_rmap_irec high = { 0, };

that ensures the who;le structure is zero-filled for uninitialized
fields.

> diff --git a/repair/phase5.c b/repair/phase5.c
> index e583879..5a7185c 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -1464,7 +1464,7 @@ prop_rmap_cursor(
>  		 * and set the rightsib pointer of current block
>  		 */
>  #ifdef XR_BLD_INO_TRACE
> -		fprintf(stderr, " ino prop agbno %d ", lptr->prev_agbno);
> +		fprintf(stderr, " rmap prop agbno %d ", lptr->prev_agbno);
>  #endif

Did Coveryity really point this out? :)

> @@ -1548,6 +1548,7 @@ prop_rmap_highkey(
>  		bt_key->rm_offset = cpu_to_be64(
>  				libxfs_rmap_irec_offset_pack(&high_key));
>  
> +		key.rm_blockcount = 0;

should probably be a struct initializer again

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
