Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 547A97F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:30:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FFC2304048
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 08:30:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gucOSBkvpDyqayNt for <xfs@oss.sgi.com>;
	Mon, 28 Sep 2015 08:30:35 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3366F70F6B09
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:30:35 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 7/7] xfs: per-filesystem stats counter implementation
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
	<1443223380-18870-8-git-send-email-billodo@redhat.com>
Message-ID: <56095D1A.60809@sandeen.net>
Date: Mon, 28 Sep 2015 10:30:34 -0500
MIME-Version: 1.0
In-Reply-To: <1443223380-18870-8-git-send-email-billodo@redhat.com>
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
To: xfs@oss.sgi.com

On 9/25/15 6:23 PM, Bill O'Donnell wrote:
> This patch modifies the stats counting macros and the callers
> to those macros to properly increment, decrement, and add-to
> the xfs stats counts. The counts for global and per-fs stats
> are correctly advanced, and cleared by writing a "1" to the
> corresponding clear file.
> 
> global counts: /sys/fs/xfs/stats/stats
> per-fs counts: /sys/fs/xfs/sda*/stats/stats
> 
> global clear:  /sys/fs/xfs/stats/stats_clear
> per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---

<big snip>

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 8f18bab..e42d969 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -84,22 +84,23 @@ union xfs_btree_rec {
>  /*
>   * Generic stats interface
>   */
> -#define __XFS_BTREE_STATS_INC(type, stat) \
> -	XFS_STATS_INC(xs_ ## type ## _2_ ## stat)
> -#define XFS_BTREE_STATS_INC(cur, stat)  \
> +#define __XFS_BTREE_STATS_INC(mp, type, stat)		\
> +	XFS_STATS_INC(mp, xs_ ## type ## _2_ ## stat)
> +#define XFS_BTREE_STATS_INC(cur, stat)	\
>  do {    \
> +	struct xfs_mount *mp = cur->bc_mp; \
>  	switch (cur->bc_btnum) {  \
> -	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(abtb, stat); break;	\
> -	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
> -	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
> -	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
> -	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
> +	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(mp, abtb, stat); break; \
> +	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(mp, abtc, stat); break; \
> +	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(mp, bmbt, stat); break; \
> +	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(mp, ibt, stat); break; \
> +	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(mp, fibt, stat); break; \
>  	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
>  	}       \
>  } while (0)
>  
>  #define __XFS_BTREE_STATS_ADD(type, stat, val) \
> -	XFS_STATS_ADD(xs_ ## type ## _2_ ## stat, val)
> +	XFS_STATS_ADD(cur->bc_mp, xs_ ## type ## _2_ ## stat, val)

Where does "cur" come from?  XFS_BTREE_STATS_ADD should grab mp from
cur & pass it to __XFS_BTREE_STATS_ADD like XFS_BTREE_STATS_INC did,
otherwise you're relying on the macro being called from somewhere with
a local variable named "cur" - macros referencing local vars @ the callpoint
are a bad idea.

>  #define XFS_BTREE_STATS_ADD(cur, stat, val)  \
>  do {    \
>  	switch (cur->bc_btnum) {  \
> @@ -108,7 +109,7 @@ do {    \
>  	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
> -	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
> +	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
>  	}       \
>  } while (0)
>  

<snip>

> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index d5b3704..d3c8da3 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -122,11 +122,9 @@ static int xqm_proc_show(struct seq_file *m, void *v)
>  {
>  	/* maximum; incore; ratio free to inuse; freelist */
>  	seq_printf(m, "%d\t%d\t%d\t%u\n",
> -			0,
> -			counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
> -			0,
> -			counter_val(xfsstats.xs_stats,
> -				XFSSTAT_END_XQMSTAT + 1));
> +		       0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
> +		       0, counter_val(xfsstats.xs_stats,
> +		       XFSSTAT_END_XQMSTAT + 1));

unrelated whitespace stuff; if it needs to be reformatted, do it in the
patch that introduced the formatting you don't like.

>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 00afc13..7e84702 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -224,10 +224,25 @@ struct xfs_mount;
>   * We don't disable preempt, not too worried about poking the
>   * wrong CPU's stat for now (also aggregated before reporting).
>   */
> -#define XFS_STATS_INC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v++)
> -#define XFS_STATS_DEC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v--)
> -#define XFS_STATS_ADD(v, inc)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v \
> -				+= (inc))
> +#define XFS_STATS_INC(mp, v)		{ per_cpu_ptr(xfsstats.xs_stats, \
> +							current_cpu())->v++; \
> +							per_cpu_ptr( \
> +							mp->m_stats.xs_stats, \
> +							current_cpu())->v++; }
> +

kind of odd style here; I'd do:

+#define XFS_STATS_INC(mp, v)					\
+do { 								\
+	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v++;	\
+	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v++;	\
+} while (0)

(that do { } while (0) idiom is odd, and I think it has fallen out of favor,
but it's how the other multiline stats macros work - see XFS_BTREE_STATS_ADD
for example)

But honestly, maybe this should turn into a static inline.  I guess we have
plenty of multiline  macros already...

and really, those per_cpu()'s should have been made per_cpu_ptr's in the patch
which introduced the xfsstats.xs_stats usage.

> +#define XFS_STATS_DEC(mp, v)		{ per_cpu_ptr(xfsstats.xs_stats, \
> +							current_cpu())->v++; \
> +							per_cpu_ptr( \
> +							mp->m_stats.xs_stats, \
> +							current_cpu())->v--; }
> +
> +#define XFS_STATS_ADD(mp, v, inc)	{ per_cpu_ptr(xfsstats.xs_stats, \
> +							current_cpu())->v \
> +							+= (inc); \
> +							per_cpu_ptr( \
> +							mp->m_stats.xs_stats, \
> +							current_cpu())->v \
> +							+= (inc); }

(here too of course)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
