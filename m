Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44GSe7j055229 for <xfs@oss.sgi.com>; Fri, 4 May 2012 11:28:40 -0500
Date: Fri, 4 May 2012 11:32:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/4] xfsprogs: Add qs_pquota to the fs_quota
Message-ID: <20120504163205.GS16881@sgi.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173304.31735.10706.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173304.31735.10706.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:33:04AM -0600, Chandra Seetharaman wrote:
> >From 9de21fc22372c3ba65a38e259aa023a74d1cae36 Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Tue, 13 Dec 2011 16:08:19 -0600
> Subject: [PATCH 3/4] Add a new field qs_pquota to the data structure fs_quota_stat and also
>  define a new version for the same.
> 
> Inform the kernel that the data structure is newer one and on return
> from kernel check the version and act accordingly.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  include/xqm.h |    2 ++
>  quota/state.c |    6 +++++-
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/xqm.h b/include/xqm.h
> index 47f58a0..24e1ea0 100644
> --- a/include/xqm.h
> +++ b/include/xqm.h
> @@ -124,6 +124,7 @@ typedef struct fs_disk_quota {
>   * incore.
>   */
>  #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
> +#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota */
>  
>  /*
>   * Some basic information about 'quota files'.
> @@ -146,6 +147,7 @@ typedef struct fs_quota_stat {
>  	__s32		qs_rtbtimelimit;/* limit for rt blks timer */
>  	__u16		qs_bwarnlimit;	/* limit for num warnings */
>  	__u16		qs_iwarnlimit;	/* limit for num warnings */
> +	fs_qfilestat_t	qs_pquota;	/* project quota storage information */
>  } fs_quota_stat_t;

Yep, same stuff you did for the kernel.

>  #endif	/* __XQM_H__ */
> diff --git a/quota/state.c b/quota/state.c
> index 42bffc0..678699f 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -152,6 +152,8 @@ state_quotafile_mount(
>  	fs_quota_stat_t	s;
>  	char		*dev = mount->fs_name;
>  
> +	bzero(&s, sizeof(struct fs_quota_stat));
> +	s.qs_version = FS_QSTAT_VERSION_2;
>  	if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
>  		if (flags & VERBOSE_FLAG)
>  			fprintf(fp, _("%s quota are not enabled on %s\n"),
> @@ -168,7 +170,9 @@ state_quotafile_mount(
>  				s.qs_flags & XFS_QUOTA_GDQ_ACCT,
>  				s.qs_flags & XFS_QUOTA_GDQ_ENFD);
>  	if (type & XFS_PROJ_QUOTA)
> -		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, &s.qs_gquota,
> +		state_qfilestat(fp, mount, XFS_PROJ_QUOTA, 
> +				(s.qs_version >= FS_QSTAT_VERSION_2) ?
> +				&s.qs_pquota : &s.qs_gquota,
>  				s.qs_flags & XFS_QUOTA_PDQ_ACCT,
>  				s.qs_flags & XFS_QUOTA_PDQ_ENFD);

Ah, nice.  Older kernels which do not have VERSION_2 overwrite qs_version.  You'll do the right thing either way.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
