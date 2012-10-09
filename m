Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99DehfC046453 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 08:40:43 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fsbFJgKYEaDYKOu9 for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 06:42:14 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q99DgDGm028788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 09:42:13 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-88.phx2.redhat.com
	[10.3.113.88])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q99DgAt9001722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 09:42:13 -0400
Date: Tue, 9 Oct 2012 10:42:10 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
Message-ID: <20121009134210.GB22834@andromeda.usersys.redhat.com>
References: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
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
To: xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 02:15:45PM +0200, Lukas Czerner wrote:
> Currently if len argument in xfs_ioc_trim() is smaller than one BB
> (basic block) the 'end' variable underflow. Avoid that by bailing out if
> len is smaller than BB.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/xfs/xfs_discard.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 69cf4fc..54dc58a 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -183,8 +183,12 @@ xfs_ioc_trim(
>  	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
>  		return -XFS_ERROR(EINVAL);
>  
> +	end = BTOBBT(range.len);
> +	if (0 == end)
> +		goto out;
> +
>  	start = BTOBB(range.start);
> -	end = start + BTOBBT(range.len) - 1;
> +	end += start - 1;
>  	minlen = BTOBB(max_t(u64, granularity, range.minlen));
>  
>  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> @@ -203,6 +207,7 @@ xfs_ioc_trim(
>  	if (last_error)
>  		return last_error;
>  
> +out:
>  	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
>  	if (copy_to_user(urange, &range, sizeof(range)))
>  		return -XFS_ERROR(EFAULT);
> -- 
> 1.7.7.6
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
