Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEBC17F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 14:42:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9528F304032
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 12:42:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lXdI7FceNihst3lQ for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 12:42:44 -0800 (PST)
Date: Mon, 24 Feb 2014 15:42:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/10] repair: translation lookups limit scalability
Message-ID: <20140224204238.GA49654@bfoster.bfoster>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393223369-4696-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 24, 2014 at 05:29:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A bit of perf magic showed that scalability was limits to 3-4
> concurrent threads due to contention on a lock inside in something
> called __dcigettext(). That some library somewhere that repair is
> linked against, and it turns out to be inside the translation
> infrastructure to support the _() string mechanism:
> 
> # Samples: 34K of event 'cs'
> # Event count (approx.): 495567
> #
> # Overhead        Command      Shared Object          Symbol
> # ........  .............  .................  ..............
> #
>     60.30%     xfs_repair  [kernel.kallsyms]  [k] __schedule
>                |
>                --- 0x63fffff9c
>                    process_bmbt_reclist_int
>                   |
>                   |--39.95%-- __dcigettext
>                   |          __lll_lock_wait
>                   |          system_call_fastpath
>                   |          SyS_futex
>                   |          do_futex
>                   |          futex_wait
>                   |          futex_wait_queue_me
>                   |          schedule
>                   |          __schedule
>                   |
>                   |--8.91%-- __lll_lock_wait
>                   |          system_call_fastpath
>                   |          SyS_futex
>                   |          do_futex
>                   |          futex_wait
>                   |          futex_wait_queue_me
>                   |          schedule
>                   |          __schedule
>                    --51.13%-- [...]
> 
> Fix this by initialising global variables that hold the translated
> strings at startup, hence avoiding the need to do repeated runtime
> translation of the same strings.
> 
> Runtime of an unpatched xfs_repair is roughly:
> 
>         XFS_REPAIR Summary    Fri Dec  6 11:15:50 2013
> 
> Phase           Start           End             Duration
> Phase 1:        12/06 10:56:21  12/06 10:56:21
> Phase 2:        12/06 10:56:21  12/06 10:56:23  2 seconds
> Phase 3:        12/06 10:56:23  12/06 11:01:31  5 minutes, 8 seconds
> Phase 4:        12/06 11:01:31  12/06 11:07:08  5 minutes, 37 seconds
> Phase 5:        12/06 11:07:08  12/06 11:07:09  1 second
> Phase 6:        12/06 11:07:09  12/06 11:15:49  8 minutes, 40 seconds
> Phase 7:        12/06 11:15:49  12/06 11:15:50  1 second
> 
> Total run time: 19 minutes, 29 seconds
> 
> Patched version:
> 
> Phase           Start           End             Duration
> Phase 1:        12/06 10:36:29  12/06 10:36:29
> Phase 2:        12/06 10:36:29  12/06 10:36:31  2 seconds
> Phase 3:        12/06 10:36:31  12/06 10:40:08  3 minutes, 37 seconds
> Phase 4:        12/06 10:40:08  12/06 10:43:42  3 minutes, 34 seconds
> Phase 5:        12/06 10:43:42  12/06 10:43:42
> Phase 6:        12/06 10:43:42  12/06 10:50:28  6 minutes, 46 seconds
> Phase 7:        12/06 10:50:28  12/06 10:50:29  1 second
> 
> Total run time: 14 minutes
> 
> Big win!
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dinode.c     | 49 +++++++++++++++++++++++++++++++++++--------------
>  repair/dinode.h     |  3 +++
>  repair/scan.c       |  7 +------
>  repair/xfs_repair.c |  2 ++
>  4 files changed, 41 insertions(+), 20 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 3115bd0..4953a56 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -32,6 +32,37 @@
>  #include "threads.h"
>  
>  /*
> + * gettext lookups for translations of strings use mutexes internally to
> + * the library. Hence when we come through here doing parallel scans in
> + * multiple AGs, then all do concurrent text conversions and serialise
Typo:		    they ?

Reviewed-by: Brian Foster <bfoster@redhat.com>

> + * on the translation string lookups. Let's avoid doing repeated lookups
> + * by making them static variables and only assigning the translation
> + * once.
> + */
> +static char	*forkname_data;
> +static char	*forkname_attr;
> +static char	*ftype_real_time;
> +static char	*ftype_regular;
> +
> +void
> +dinode_bmbt_translation_init(void)
> +{
> +	forkname_data = _("data");
> +	forkname_attr = _("attr");
> +	ftype_real_time = _("real-time");
> +	ftype_regular = _("regular");
> +}
> +
> +char *
> +get_forkname(int whichfork)
> +{
> +
> +	if (whichfork == XFS_DATA_FORK)
> +		return forkname_data;
> +	return forkname_attr;
> +}
> +
> +/*
>   * inode clearing routines
>   */
>  
> @@ -542,7 +573,7 @@ process_bmbt_reclist_int(
>  	xfs_dfiloff_t		op = 0;		/* prev offset */
>  	xfs_dfsbno_t		b;
>  	char			*ftype;
> -	char			*forkname;
> +	char			*forkname = get_forkname(whichfork);
>  	int			i;
>  	int			state;
>  	xfs_agnumber_t		agno;
> @@ -552,15 +583,10 @@ process_bmbt_reclist_int(
>  	xfs_agnumber_t		locked_agno = -1;
>  	int			error = 1;
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		forkname = _("data");
> -	else
> -		forkname = _("attr");
> -
>  	if (type == XR_INO_RTDATA)
> -		ftype = _("real-time");
> +		ftype = ftype_real_time;
>  	else
> -		ftype = _("regular");
> +		ftype = ftype_regular;
>  
>  	for (i = 0; i < *numrecs; i++) {
>  		libxfs_bmbt_disk_get_all(rp + i, &irec);
> @@ -1110,7 +1136,7 @@ process_btinode(
>  	xfs_ino_t		lino;
>  	xfs_bmbt_ptr_t		*pp;
>  	xfs_bmbt_key_t		*pkey;
> -	char			*forkname;
> +	char			*forkname = get_forkname(whichfork);
>  	int			i;
>  	int			level;
>  	int			numrecs;
> @@ -1122,11 +1148,6 @@ process_btinode(
>  	*tot = 0;
>  	*nex = 0;
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		forkname = _("data");
> -	else
> -		forkname = _("attr");
> -
>  	magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_BMAP_CRC_MAGIC
>  						 : XFS_BMAP_MAGIC;
>  
> diff --git a/repair/dinode.h b/repair/dinode.h
> index d9197c1..7521521 100644
> --- a/repair/dinode.h
> +++ b/repair/dinode.h
> @@ -127,4 +127,7 @@ get_bmapi(xfs_mount_t		*mp,
>  		xfs_dfiloff_t	bno,
>  		int             whichfork );
>  
> +void dinode_bmbt_translation_init(void);
> +char * get_forkname(int whichfork);
> +
>  #endif /* _XR_DINODE_H */
> diff --git a/repair/scan.c b/repair/scan.c
> index 73b4581..b12f48b 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -171,17 +171,12 @@ scan_bmapbt(
>  	xfs_bmbt_rec_t		*rp;
>  	xfs_dfiloff_t		first_key;
>  	xfs_dfiloff_t		last_key;
> -	char			*forkname;
> +	char			*forkname = get_forkname(whichfork);
>  	int			numrecs;
>  	xfs_agnumber_t		agno;
>  	xfs_agblock_t		agbno;
>  	int			state;
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		forkname = _("data");
> -	else
> -		forkname = _("attr");
> -
>  	/*
>  	 * unlike the ag freeblock btrees, if anything looks wrong
>  	 * in an inode bmap tree, just bail.  it's possible that
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9e0502a..bac334f 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -29,6 +29,7 @@
>  #include "prefetch.h"
>  #include "threads.h"
>  #include "progress.h"
> +#include "dinode.h"
>  
>  #define	rounddown(x, y)	(((x)/(y))*(y))
>  
> @@ -533,6 +534,7 @@ main(int argc, char **argv)
>  	setlocale(LC_ALL, "");
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
> +	dinode_bmbt_translation_init();
>  
>  	temp_mp = &xfs_m;
>  	setbuf(stdout, NULL);
> -- 
> 1.8.4.rc3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
