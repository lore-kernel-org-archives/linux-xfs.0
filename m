Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Jan 2007 09:39:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0HHcqqw002128
	for <xfs@oss.sgi.com>; Wed, 17 Jan 2007 09:38:53 -0800
Message-ID: <45AE5EF5.8050604@sandeen.net>
Date: Wed, 17 Jan 2007 11:37:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH 14/59] sysctl: C99 convert xfs ctl_tables
References: <m1ac0jc4no.fsf@ebiederm.dsl.xmission.com> <11689656301563-git-send-email-ebiederm@xmission.com>
In-Reply-To: <11689656301563-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: "<Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com> - unquoted
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/xfs/linux-2.6/xfs_sysctl.c |  258 ++++++++++++++++++++++++++++------------
>  1 files changed, 180 insertions(+), 78 deletions(-)

Oh no, 100 more XFS LOC! ;)

Minor nits below...

> +	{
> +		.ctl_name	= XFS_PANIC_MASK,
> +		.procname	= "panic_mask",
> +		.data		= &xfs_params.panic_mask.val,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	=  &proc_dointvec_minmax,

Extra space here

> +	{
> +		.ctl_name	= XFS_INHERIT_NODUMP,
> +		.procname	= "inherit_nodump",
> +		.data		= &xfs_params.inherit_nodump.val,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec, NULL,

don't think you want the NULL here

> +		.extra1		= &xfs_params.inherit_nodump.min,
> +		.extra2		= &xfs_params.inherit_nodump.max
> +	},
> +	{
> +		.ctl_name	= XFS_INHERIT_NOATIME,
> +		.procname	= "inherit_noatime",
> +		.data		= &xfs_params.inherit_noatim.val,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec, NULL,

or here

> +	{
> +		.ctl_name	= XFS_BUF_AGE,
> +		.procname	= "age_buffer_centisecs",
> +		.data		= &xfs_params.xfs_buf_age.val,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec, NULL,

or here

> +	{
> +		.ctl_name	= XFS_STATS_CLEAR,
> +		.procname	= "stats_clear",
> +		.data		= &xfs_params.stats_clear.val,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	=  &xfs_stats_clear_proc_handler,

extra space here

Thanks,
-Eric
