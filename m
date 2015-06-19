Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9B8B7F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48E05AC001
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:19:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n8FyYybMKdVUN1Ui (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 06:19:55 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 766AB388B67
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 13:19:54 +0000 (UTC)
Date: Fri, 19 Jun 2015 09:19:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: refuse to unset lazycount on V5 filesystems
Message-ID: <20150619131952.GC12833@bfoster.bfoster>
References: <5582F962.2090400@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5582F962.2090400@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 18, 2015 at 12:01:22PM -0500, Eric Sandeen wrote:
> Running "xfs_admin -c 0" on a V5 fs has unfortunate results.
> 
> Before:
> versionnum [0xbca5+0x18a] = ... LAZYSBCOUNT,PROJID32BIT,CRC, ...
> After:
> versionnum [0xbca5+0x188] = ... LAZYSBCOUNT,PROJID32BIT,CRC, ...
> 
> The on-disk feature bit is in fact changed, but xfs_db reports that the
> feature is still present.  This is because xfs_sb_version_haslazysbcount()
> ignores the feature bit, and always reports that the lazy-count feature is
> present on a V5 fs.
> 
> i.e. the intent is that this feature is not optional on a V5 fs, yet we
> still flip the bit on disk when asked.  Not good.
> 
> So, document this, and error out if the user tries to disable lazy-count
> on a version 5 filesystem.
> 
> Reported-by: Richard W.M. Jones <rjones@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> (hm, xfs_repair should probably also turn the bit back on, if it's off on
> V5?  I'll save that for another patch.)
> 

Seems reasonable.

Brian

> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index b393d74..0968196 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -62,6 +62,10 @@ Print the current filesystem UUID (Universally Unique IDentifier).
>  .TP
>  .BR "\-c 0" | 1
>  Enable (1) or disable (0) lazy-counters in the filesystem.
> +.IP
> +Lazy-counters may not be disabled on Version 5 superblock filesystems
> +(i.e. those with metadata CRCs enabled).
> +.IP
>  This operation may take quite a bit of time on large filesystems as the
>  entire filesystem needs to be scanned when this option is changed.
>  .IP
> 
> diff --git a/repair/phase1.c b/repair/phase1.c
> index ec75ada..9e7011d 100644
> --- a/repair/phase1.c
> +++ b/repair/phase1.c
> @@ -121,8 +121,12 @@ phase1(xfs_mount_t *mp)
>  			sb->sb_bad_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
>  			primary_sb_modified = 1;
>  			printf(_("Enabling lazy-counters\n"));
> -		} else
> -		if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
> +		} else if (!lazy_count && xfs_sb_version_haslazysbcount(sb)) {
> +			if (XFS_SB_VERSION_NUM(sb) == XFS_SB_VERSION_5) {
> +				printf(
> +_("Cannot disable lazy-counters on V5 fs\n"));
> +				exit(1);
> +			}
>  			sb->sb_features2 &= ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
>  			sb->sb_bad_features2 &= ~XFS_SB_VERSION2_LAZYSBCOUNTBIT;
>  			printf(_("Disabling lazy-counters\n"));
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
