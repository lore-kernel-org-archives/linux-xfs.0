Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 60E1B7CA0
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 11:36:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7CE0AC001
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 09:36:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ItySA9FKTIqCMNH4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jul 2016 09:36:05 -0700 (PDT)
Date: Tue, 26 Jul 2016 12:36:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/47] xfs: fix attr shortform structure alignment on cris
Message-ID: <20160726163602.GA31917@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907698036.25461.13007151908183013504.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907698036.25461.13007151908183013504.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:56:20PM -0700, Darrick J. Wong wrote:
> Apparently cris doesn't require structure stride to align with the
> largest type in the struct, so list[0] isn't at offset 4 like it is
> everywhere else.  Fix this... insofar as existing XFSes on cris are
> screwed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_da_format.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 685f23b..9a492a9 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -629,6 +629,7 @@ typedef struct xfs_attr_shortform {
>  	struct xfs_attr_sf_hdr {	/* constant-structure header block */
>  		__be16	totsize;	/* total bytes in shortform list */
>  		__u8	count;	/* count of active entries */
> +		__u8	padding;
>  	} hdr;
>  	struct xfs_attr_sf_entry {
>  		__uint8_t namelen;	/* actual length of name (no NULL) */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
