Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22ACB7F37
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 16:32:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB20F8F8033
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 14:32:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gnJIhABlw5dRBJye for <xfs@oss.sgi.com>;
	Sun, 31 May 2015 14:32:23 -0700 (PDT)
Date: Mon, 1 Jun 2015 07:32:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/5] xfs_repair: better checking of v5 metadata fields
Message-ID: <20150531213219.GF24666@dastard>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225139.26434.37575.stgit@birch.djwong.org>
	<20150527054450.GA10175@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150527054450.GA10175@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Tue, May 26, 2015 at 10:44:50PM -0700, Darrick J. Wong wrote:
> Check the UUID, owner, and block number fields during repair, looking for
> blocks that fail either the checksum or the data structure verifiers.  For
> directories we can simply rebuild corrupt/broken index data, though for
> anything else we have to toss out the broken object.
> 
> v2: Refactor the directory block header checks into a single function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

FYI, just a couple of quick whitespacy things, which I've fixed on
commit.

> diff --git a/repair/phase6.c b/repair/phase6.c
> index c09b394..7dd868c 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1925,6 +1925,69 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
>  	freetab->ents[db].s = 0;
>  }
>  
> +/* check v5 metadata */
> +static int
> +__check_dir3_header(
> +	xfs_mount_t			*mp,
> +	xfs_buf_t			*bp,

Don't use the typedef versions - struct xfs_mount. No need for quite
so much whitespace, either - this sort of thing is fine if there's
no need for larger alignment steps:

	struct xfs_mount *mp,
	struct xfs_buf	*bp,
	....

> +	/* verify uuid */
> +	if (platform_uuid_compare(uuid,
> +				  &mp->m_sb.sb_uuid) != 0) {

No need to split that line.

> +static int
> +check_da3_header(
> +	xfs_mount_t			*mp,
> +	xfs_buf_t			*bp,
> +	xfs_ino_t			ino)
> +{
> +	struct xfs_da3_blkinfo		*info;
> +
> +	info = bp->b_addr;

	struct xfs_da3_blkinfo	*info = bp->b_addr;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
