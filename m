Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55184 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbfDDQtu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:49:50 -0400
Subject: Re: [PATCH 47/36] xfs_scrub: remove xfs_ prefixes from structure
 names
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320200513.GK1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3585ddd1-6670-71da-3f17-ed10a4673437@sandeen.net>
Date: Thu, 4 Apr 2019 11:49:49 -0500
MIME-Version: 1.0
In-Reply-To: <20190320200513.GK1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 3:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Drop the xfs_ prefix from scrub's struct definitions since they're
> private to the program.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/phase5.c |    8 +++----
>  scrub/phase7.c |   66 ++++++++++++++++++++++++++++----------------------------
>  2 files changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 49886e6f..1743119d 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -119,12 +119,12 @@ xfs_scrub_scan_dirents(
>  
>  #ifdef HAVE_LIBATTR
>  /* Routines to scan all of an inode's xattrs for name problems. */
> -struct xfs_attr_ns {
> +struct attrns_decode {
>  	int			flags;
>  	const char		*name;
>  };
>  
> -static const struct xfs_attr_ns attr_ns[] = {
> +static const struct attrns_decode attr_ns[] = {
>  	{0,			"user"},
>  	{ATTR_ROOT,		"system"},
>  	{ATTR_SECURE,		"secure"},
> @@ -141,7 +141,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
>  	const char			*descr,
>  	struct xfs_handle		*handle,
>  	struct xfs_bstat		*bstat,
> -	const struct xfs_attr_ns	*attr_ns)
> +	const struct attrns_decode	*attr_ns)
>  {
>  	struct attrlist_cursor		cur;
>  	char				attrbuf[XFS_XATTR_LIST_MAX];
> @@ -202,7 +202,7 @@ xfs_scrub_scan_fhandle_xattrs(
>  	struct xfs_handle		*handle,
>  	struct xfs_bstat		*bstat)
>  {
> -	const struct xfs_attr_ns	*ns;
> +	const struct attrns_decode	*ns;
>  	bool				moveon = true;
>  
>  	for (ns = attr_ns; ns->name; ns++) {
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index 504a6927..0c3202e4 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -16,7 +16,7 @@
>  
>  /* Phase 7: Check summary counters. */
>  
> -struct xfs_summary_counts {
> +struct summary_counts {
>  	unsigned long long	dbytes;		/* data dev bytes */
>  	unsigned long long	rbytes;		/* rt dev bytes */
>  	unsigned long long	next_phys;	/* next phys bytes we see? */
> @@ -26,13 +26,13 @@ struct xfs_summary_counts {
>  /* Record block usage. */
>  static bool
>  xfs_record_block_summary(
> -	struct scrub_ctx		*ctx,
> -	const char			*descr,
> -	struct fsmap			*fsmap,
> -	void				*arg)
> +	struct scrub_ctx	*ctx,
> +	const char		*descr,
> +	struct fsmap		*fsmap,
> +	void			*arg)
>  {
> -	struct xfs_summary_counts	*counts;
> -	unsigned long long		len;
> +	struct summary_counts	*counts;
> +	unsigned long long	len;
>  
>  	counts = ptvar_get((struct ptvar *)arg);
>  	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
> @@ -67,12 +67,12 @@ xfs_record_block_summary(
>  /* Add all the summaries in the per-thread counter */
>  static bool
>  xfs_add_summaries(
> -	struct ptvar			*ptv,
> -	void				*data,
> -	void				*arg)
> +	struct ptvar		*ptv,
> +	void			*data,
> +	void			*arg)
>  {
> -	struct xfs_summary_counts	*total = arg;
> -	struct xfs_summary_counts	*item = data;
> +	struct summary_counts	*total = arg;
> +	struct summary_counts	*item = data;
>  
>  	total->dbytes += item->dbytes;
>  	total->rbytes += item->rbytes;
> @@ -88,27 +88,27 @@ xfs_add_summaries(
>   */
>  bool
>  xfs_scan_summary(
> -	struct scrub_ctx		*ctx)
> +	struct scrub_ctx	*ctx)
>  {
> -	struct xfs_summary_counts	totalcount = {0};
> -	struct ptvar			*ptvar;
> -	unsigned long long		used_data;
> -	unsigned long long		used_rt;
> -	unsigned long long		used_files;
> -	unsigned long long		stat_data;
> -	unsigned long long		stat_rt;
> -	uint64_t			counted_inodes = 0;
> -	unsigned long long		absdiff;
> -	unsigned long long		d_blocks;
> -	unsigned long long		d_bfree;
> -	unsigned long long		r_blocks;
> -	unsigned long long		r_bfree;
> -	unsigned long long		f_files;
> -	unsigned long long		f_free;
> -	bool				moveon;
> -	bool				complain;
> -	int				ip;
> -	int				error;
> +	struct summary_counts	totalcount = {0};
> +	struct ptvar		*ptvar;
> +	unsigned long long	used_data;
> +	unsigned long long	used_rt;
> +	unsigned long long	used_files;
> +	unsigned long long	stat_data;
> +	unsigned long long	stat_rt;
> +	uint64_t		counted_inodes = 0;
> +	unsigned long long	absdiff;
> +	unsigned long long	d_blocks;
> +	unsigned long long	d_bfree;
> +	unsigned long long	r_blocks;
> +	unsigned long long	r_bfree;
> +	unsigned long long	f_files;
> +	unsigned long long	f_free;
> +	bool			moveon;
> +	bool			complain;
> +	int			ip;
> +	int			error;
>  
>  	/* Flush everything out to disk before we start counting. */
>  	error = syncfs(ctx->mnt_fd);
> @@ -117,7 +117,7 @@ xfs_scan_summary(
>  		return false;
>  	}
>  
> -	ptvar = ptvar_init(scrub_nproc(ctx), sizeof(struct xfs_summary_counts));
> +	ptvar = ptvar_init(scrub_nproc(ctx), sizeof(struct summary_counts));
>  	if (!ptvar) {
>  		str_errno(ctx, ctx->mntpoint);
>  		return false;
> 
