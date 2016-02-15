Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67BE97CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 09:33:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CE8C8F8039
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 07:33:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nxSchPuuK45kL0f5 for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 07:32:56 -0800 (PST)
Subject: Re: [PATCH v2] xfs_quota: modify commands which can't handle multiple
	types
References: <1455376388-4712-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C1EFA7.4090308@sandeen.net>
Date: Mon, 15 Feb 2016 09:32:55 -0600
MIME-Version: 1.0
In-Reply-To: <1455376388-4712-1-git-send-email-zlang@redhat.com>
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
Cc: Zorro Lang <zlang@redhat.com>



On 2/13/16 9:13 AM, Zorro Lang wrote:
> Some xfs_quota commands can't deal with multiple types together.
> For example, if we run "limit -ug ...", one type will overwrite
> the other. I find below commands can't handle multiple types:
> 
>   [quota, limit, timer, warn, dump, restore and quot]
> 
> (Although timer and warn command can't support -ugp types until
> now, it will in one day.)
> 
> For every single $command, I change their ${command}_f function,
> ${command}_cmd structure and man page.

For what it's worth,

+.BR "\-g | \-p | \-u"

doesn't make a lot of sense, it tells it to alternate bold and regular,
but you only have one term, the one in quotes, and so it is all bold.
Bold pipes "|" are a little weird, and not consistent with the rest
of the manpage.

Sorry to nitpick, but:

.BR \-g " | " \-p " | " \-u

might be better; " | " preserves the spaces around the options like
the rest of the manpage, and they are not bold, and this is consistent
with the rest of the file as well.

The rest of the patch looks good to me
Thanks,
-Eric

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  man/man8/xfs_quota.8 | 14 ++++++------
>  quota/edit.c         | 60 ++++++++++++++++++++++++++++++++++------------------
>  quota/quot.c         | 15 ++++++++-----
>  quota/quota.c        | 15 ++++++++-----
>  quota/report.c       | 20 ++++++++++++------
>  5 files changed, 81 insertions(+), 43 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 3bee145..70a2eb5 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -169,7 +169,7 @@ command.
>  .HP
>  .B quota
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ] [
>  .B \-bir
>  ] [
> @@ -398,7 +398,7 @@ option reports state on all filesystems and not just the current path.
>  .B
>  limit
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ]
>  .BI bsoft= N
>  |
> @@ -430,7 +430,7 @@ must be specified.
>  .HP
>  .B timer
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ] [
>  .B \-bir
>  ]
> @@ -446,7 +446,7 @@ command. The value argument is a number of seconds, but units of
>  .HP
>  .B warn
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ] [
>  .B \-bir
>  ]
> @@ -497,7 +497,7 @@ report an error.
>  .B
>  dump
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ] [
>  .B \-f
>  .I file
> @@ -510,7 +510,7 @@ This is only the limits, not the usage information, of course.
>  .HP
>  .B restore
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ] [
>  .B \-f
>  .I file
> @@ -525,7 +525,7 @@ command.
>  .B
>  quot
>  [
> -.B \-gpu
> +.BR "\-g | \-p | \-u"
>  ] [
>  .B \-bir
>  ] [
> diff --git a/quota/edit.c b/quota/edit.c
> index 6146f7e..e5ddc8c 100644
> --- a/quota/edit.c
> +++ b/quota/edit.c
> @@ -282,13 +282,13 @@ limit_f(
>  			flags |= DEFAULTS_FLAG;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		default:
>  			return command_usage(&limit_cmd);
> @@ -343,8 +343,13 @@ limit_f(
>  
>  	name = (flags & DEFAULTS_FLAG) ? "0" : argv[optind++];
>  
> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&limit_cmd);
> +	}
>  
>  	switch (type) {
>  	case XFS_USER_QUOTA:
> @@ -422,13 +427,13 @@ restore_f(
>  			fname = optarg;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		default:
>  			return command_usage(&restore_cmd);
> @@ -438,8 +443,13 @@ restore_f(
>  	if (argc < optind)
>  		return command_usage(&restore_cmd);
>  
> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&restore_cmd);
> +	}
>  
>  	if (fname) {
>  		if ((fp = fopen(fname, "r")) == NULL) {
> @@ -501,13 +511,13 @@ timer_f(
>  			mask |= FS_DQ_RTBTIMER;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		default:
>  			return command_usage(&timer_cmd);
> @@ -522,8 +532,13 @@ timer_f(
>  	if (!mask)
>  		mask = FS_DQ_TIMER_MASK;
>  
> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&timer_cmd);
> +	}
>  
>  	set_timer(type, mask, fs_path->fs_name, value);
>  	return 0;
> @@ -630,13 +645,13 @@ warn_f(
>  			mask |= FS_DQ_RTBWARNS;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		default:
>  			return command_usage(&warn_cmd);
> @@ -661,8 +676,13 @@ warn_f(
>  	if (!mask)
>  		mask = FS_DQ_WARNS_MASK;
>  
> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&warn_cmd);
> +	}
>  
>  	switch (type) {
>  	case XFS_USER_QUOTA:
> @@ -686,7 +706,7 @@ edit_init(void)
>  	limit_cmd.argmin = 2;
>  	limit_cmd.argmax = -1;
>  	limit_cmd.args = \
> -	_("[-gpu] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
> +	_("[-g|-p|-u] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
>  	limit_cmd.oneline = _("modify quota limits");
>  	limit_cmd.help = limit_help;
>  
> @@ -694,14 +714,14 @@ edit_init(void)
>  	restore_cmd.cfunc = restore_f;
>  	restore_cmd.argmin = 0;
>  	restore_cmd.argmax = -1;
> -	restore_cmd.args = _("[-gpu] [-f file]");
> +	restore_cmd.args = _("[-g|-p|-u] [-f file]");
>  	restore_cmd.oneline = _("restore quota limits from a backup file");
>  
>  	timer_cmd.name = "timer";
>  	timer_cmd.cfunc = timer_f;
>  	timer_cmd.argmin = 2;
>  	timer_cmd.argmax = -1;
> -	timer_cmd.args = _("[-bir] [-gpu] value");
> +	timer_cmd.args = _("[-bir] [-g|-p|-u] value");
>  	timer_cmd.oneline = _("set quota enforcement timeouts");
>  	timer_cmd.help = timer_help;
>  
> @@ -709,7 +729,7 @@ edit_init(void)
>  	warn_cmd.cfunc = warn_f;
>  	warn_cmd.argmin = 2;
>  	warn_cmd.argmax = -1;
> -	warn_cmd.args = _("[-bir] [-gpu] value -d|id|name");
> +	warn_cmd.args = _("[-bir] [-g|-p|-u] value -d|id|name");
>  	warn_cmd.oneline = _("get/set enforcement warning counter");
>  	warn_cmd.help = warn_help;
>  
> diff --git a/quota/quot.c b/quota/quot.c
> index 9116e48..2e583e5 100644
> --- a/quota/quot.c
> +++ b/quota/quot.c
> @@ -361,13 +361,13 @@ quot_f(
>  			form |= XFS_RTBLOCK_QUOTA;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		case 'a':
>  			flags |= ALL_MOUNTS_FLAG;
> @@ -389,8 +389,13 @@ quot_f(
>  	if (!form)
>  		form = XFS_BLOCK_QUOTA;
>  
> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&quot_cmd);
> +	}
>  
>  	if ((fp = fopen_write_secure(fname)) == NULL)
>  		return 0;
> @@ -416,7 +421,7 @@ quot_init(void)
>  	quot_cmd.cfunc = quot_f;
>  	quot_cmd.argmin = 0;
>  	quot_cmd.argmax = -1;
> -	quot_cmd.args = _("[-bir] [-gpu] [-acv] [-f file]");
> +	quot_cmd.args = _("[-bir] [-g|-p|-u] [-acv] [-f file]");
>  	quot_cmd.oneline = _("summarize filesystem ownership");
>  	quot_cmd.help = quot_help;
>  
> diff --git a/quota/quota.c b/quota/quota.c
> index f6b24c3..e0da7c0 100644
> --- a/quota/quota.c
> +++ b/quota/quota.c
> @@ -409,13 +409,13 @@ quota_f(
>  			form |= XFS_RTBLOCK_QUOTA;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		case 'h':
>  			flags |= HUMAN_FLAG;
> @@ -437,8 +437,13 @@ quota_f(
>  	if (!form)
>  		form = XFS_BLOCK_QUOTA;
>  
> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&quota_cmd);
> +	}
>  
>  	if ((fp = fopen_write_secure(fname)) == NULL)
>  		return 0;
> @@ -461,7 +466,7 @@ quota_init(void)
>  	quota_cmd.cfunc = quota_f;
>  	quota_cmd.argmin = 0;
>  	quota_cmd.argmax = -1;
> -	quota_cmd.args = _("[-bir] [-gpu] [-hnNv] [-f file] [id|name]...");
> +	quota_cmd.args = _("[-bir] [-g|-p|-u] [-hnNv] [-f file] [id|name]...");
>  	quota_cmd.oneline = _("show usage and limits");
>  	quota_cmd.help = quota_help;
>  
> diff --git a/quota/report.c b/quota/report.c
> index 8653134..48a3f29 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -30,7 +30,7 @@ static cmdinfo_t report_cmd;
>  static void
>  dump_help(void)
>  {
> -	dump_cmd.args = _("[-gpu] [-f file]");
> +	dump_cmd.args = _("[-g|-p|-u] [-f file]");
>  	dump_cmd.oneline = _("dump quota information for backup utilities");
>  	printf(_(
>  "\n"
> @@ -199,7 +199,7 @@ dump_f(
>  	FILE		*fp;
>  	char		*fname = NULL;
>  	uint		lower = 0, upper = 0;
> -	int		c, type = XFS_USER_QUOTA;
> +	int		c, type = 0;
>  
>  	while ((c = getopt(argc, argv, "f:gpuL:U:")) != EOF) {
>  		switch(c) {
> @@ -207,13 +207,13 @@ dump_f(
>  			fname = optarg;
>  			break;
>  		case 'g':
> -			type = XFS_GROUP_QUOTA;
> +			type |= XFS_GROUP_QUOTA;
>  			break;
>  		case 'p':
> -			type = XFS_PROJ_QUOTA;
> +			type |= XFS_PROJ_QUOTA;
>  			break;
>  		case 'u':
> -			type = XFS_USER_QUOTA;
> +			type |= XFS_USER_QUOTA;
>  			break;
>  		case 'L':
>  			lower = (uint)atoi(optarg);
> @@ -229,6 +229,14 @@ dump_f(
>  	if (argc != optind)
>  		return command_usage(&dump_cmd);
>  
> +	if (!type) {
> +		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&dump_cmd);
> +	}
> +
>  	if ((fp = fopen_write_secure(fname)) == NULL)
>  		return 0;
>  
> @@ -725,7 +733,7 @@ report_init(void)
>  	dump_cmd.cfunc = dump_f;
>  	dump_cmd.argmin = 0;
>  	dump_cmd.argmax = -1;
> -	dump_cmd.args = _("[-gpu] [-f file]");
> +	dump_cmd.args = _("[-g|-p|-u] [-f file]");
>  	dump_cmd.oneline = _("dump quota information for backup utilities");
>  	dump_cmd.help = dump_help;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
