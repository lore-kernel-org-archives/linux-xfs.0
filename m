Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KN5pwR090970 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 18:05:51 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE2EE160781B
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 16:11:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5VrVpara4cCoQP6y for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 16:11:10 -0700 (PDT)
Date: Wed, 21 Sep 2011 09:05:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: fix some printf() warnings that show up for ia64 builds
Message-ID: <20110920230546.GK15688@dastard>
References: <20110814201239.GA26453@infradead.org>
	<20110829083852.GA31515@infradead.org>
	<20110830052226.GM3162@dastard>
	<20110830085737.GA24793@infradead.org>
	<1316544193.2912.34.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316544193.2912.34.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 20, 2011 at 01:43:13PM -0500, Alex Elder wrote:
> This applies on top of Christoph Hellwig's recent "xfs_repair: add
> printf format checking and fix the fallout" patch.  It extends the
> fixes for warnings beyond just xfs_repair and across everything in
> xfsprogs.
> 
> It builds cleanly on ia64 and x86_64, and builds without any
> printf() format-related warnings on i386.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  io/parent.c              |   28 ++++++++++++++++------------
>  logprint/log_misc.c      |   34 ++++++++++++++++++++--------------
>  logprint/log_print_all.c |   16 ++++++++++------
>  repair/dinode.c          |   20 ++++++++++++--------
>  repair/scan.c            |   14 +++++++++-----
>  5 files changed, 67 insertions(+), 45 deletions(-)
> 
> Index: b/io/parent.c
> ===================================================================
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -52,12 +52,12 @@ check_parent_entry(xfs_bstat_t *bstatp,
>         if (sts != 0) {
>                 fprintf(stderr,
>                         _("inode-path for inode: %llu is incorrect - path \"%s\" non-existent\n"),
> -                       bstatp->bs_ino, fullpath);
> +                       (unsigned long long) bstatp->bs_ino, fullpath);

Hmmm, didn't Christoph fix these inode number warnings by changing
the format specifier to PRIU64, not by adding casts? bs_ino is
defined as:

	__u64		bs_ino;

So PRIu64 is the right thing to do, isn't it?

Either way would work, but being consistent would be good. ;)

....

> ===================================================================
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -307,12 +307,14 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr
>                          */
>                         memmove(&x, *ptr, sizeof(__be64));
>                         memmove(&y, *ptr+8, sizeof(__be64));
> -                       printf(_("icount: %lld  ifree: %lld  "),
> -                               be64_to_cpu(x), be64_to_cpu(y));
> +                       printf(_("icount: %llu  ifree: %llu  "),
> +                               (unsigned long long) be64_to_cpu(x),
> +                               (unsigned long long) be64_to_cpu(y));

Same for al the be64_to_cpu() functions - their return type is
__u64, too.

>                                         forkname);
> @@ -1374,7 +1376,7 @@ process_lclinode(
>                                                 XFS_DFORK_DSIZE(dip, mp)) {
>                 do_warn(
>         _("local inode %" PRIu64 " data fork is too large (size = %lld, max = %d)\n"),
> -                       lino, be64_to_cpu(dip->di_size),
> +                       lino, (unsigned long long) be64_to_cpu(dip->di_size),

That format specifier is wrong - it is %lld. Should be %llu, or
PRIu64 as previously mentioned without the cast.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
