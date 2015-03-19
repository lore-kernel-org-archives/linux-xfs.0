Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7238F7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 13:28:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 60E298F8070
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:28:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b5P95HNKGn4BbUzx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 11:28:57 -0700 (PDT)
Date: Thu, 19 Mar 2015 14:28:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: don't abort on bad directory leaf crc during
	leaf check
Message-ID: <20150319182854.GJ11669@laptop.bfoster>
References: <20150318232239.GB24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150318232239.GB24608@birch.djwong.org>
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

On Wed, Mar 18, 2015 at 04:22:39PM -0700, Darrick J. Wong wrote:
> longform_dir2_check_leaf() checks a directory leaf block to help
> decide if we need to rebuild the directory.  If the verifier fails
> with a CRC or corrupt structure error, rebuild the directory instead
> of aborting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/phase6.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 1728609..c09b394 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1951,7 +1951,12 @@ longform_dir2_check_leaf(
>  	da_bno = mp->m_dirleafblk;
>  	error = dir_read_buf(ip, da_bno, -1, &bp, &xfs_dir3_leaf1_buf_ops,
>  			     &fixit);
> -	if (error) {
> +	if (error == EFSBADCRC || error == EFSCORRUPTED || fixit) {
> +		do_warn(
> +	_("leaf block %u for directory inode %" PRIu64 " bad CRC\n"),
> +			da_bno, ip->i_ino);
> +		return 1;
> +	} else if (error) {

I don't think we'll ever see EFSBADCRC from this codepath (that appears
to be the purpose of 'fixit'). Looking at it further, it's self
documenting and robust against changes in the read codepath, so seems
pretty good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		do_error(
>  	_("can't read block %u for directory inode %" PRIu64 ", error %d\n"),
>  			da_bno, ip->i_ino, error);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
