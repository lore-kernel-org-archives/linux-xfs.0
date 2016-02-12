Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E861E7CB2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 14:56:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9FF58F8035
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 12:56:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xnDUmbn4cMtWHEQT for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 12:56:02 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A376663C5FF0
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 14:56:01 -0600 (CST)
Subject: Re: [PATCH] xfs_quota: modify commands which can't handle multiple
	types
References: <1455294538-31583-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BE46E1.5060902@sandeen.net>
Date: Fri, 12 Feb 2016 14:56:01 -0600
MIME-Version: 1.0
In-Reply-To: <1455294538-31583-1-git-send-email-zlang@redhat.com>
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

Hi Zorro -

On 2/12/16 10:28 AM, Zorro Lang wrote:
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
> ${command}_help() function, ${command}_cmd structure and man page.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  man/man8/xfs_quota.8 | 96 +++++++++++++++++++++++++++++++++++++++++++++-------
>  quota/edit.c         | 78 ++++++++++++++++++++++++++----------------
>  quota/quot.c         | 21 +++++++-----
>  quota/quota.c        | 21 +++++++-----
>  quota/report.c       | 26 +++++++++-----
>  5 files changed, 175 insertions(+), 67 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index 3bee145..4652dfe 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -169,7 +169,11 @@ command.
>  .HP
>  .B quota
>  [
> -.B \-gpu
> +.B \-g
> +|
> +.B \-p
> +|
> +.B \-u
>  ] [
>  .B \-bir
>  ] [

I had mentioned on IRC that this might be more compact:

.BR \-g | \-u | \-p

but actually yours may look better, with spaces.

So that looks good.

... snip ...

> @@ -442,11 +466,21 @@ be modified. The current timeout setting can be displayed using the
>  .B state
>  command. The value argument is a number of seconds, but units of
>  \&'minutes', 'hours', 'days', and 'weeks' are also understood
> -(as are their abbreviations 'm', 'h', 'd', and 'w').
> +(as are their abbreviations 'm', 'h', 'd', and 'w'). The
> +.B \-u
> +,
> +.B \-g
> +and
> +.B \-p
> +types can't be used together for this command.

If you present it as [-u|-g|-p] or "-u|-g|-p" I don't think you
need to re-state that they are exclusive.

(this is true for every command you've modified)

It's a standard that everyone should be aware of:
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html

...

> diff --git a/quota/edit.c b/quota/edit.c
> index 6146f7e..9dab4c3 100644
> --- a/quota/edit.c
> +++ b/quota/edit.c
> @@ -43,9 +43,9 @@ limit_help(void)
>  " block limits that are currently being used for the specified user, group,\n"
>  " or project.  The filesystem identified by the current path is modified.\n"
>  " -d -- set the default values, used the first time a file is created\n"
> -" -g -- modify group quota limits\n"
> -" -p -- modify project quota limits\n"
> -" -u -- modify user quota limits\n"
> +" -g -- modify group quota limits, can't coexist with -p, -u\n"
> +" -p -- modify project quota limits, can't coexist with -g, -u\n"
> +" -u -- modify user quota limits, can't coexist with -g, -p\n"
>  " The block limit values can be specified with a units suffix - accepted\n"
>  " units are: k (kilobytes), m (megabytes), g (gigabytes), and t (terabytes).\n"
>  " The user/group/project can be specified either by name or by number.\n"

Again, I think that if the help output specifies it as:

limit [-g|-p|-u] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name -- modify quota limits

then you don't need to add "can't coexist ..." to later lines.

(this is also true for every command you've modified)

...

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
> +	} else if (type != XFS_GROUP_QUOTA
> +	           && type != XFS_PROJ_QUOTA
> +	           && type != XFS_USER_QUOTA) {
> +		return command_usage(&limit_cmd);
> +	}

Nitpick, this would be a little cleaner as:

> -	if (!type)
> +	if (!type) {
>  		type = XFS_USER_QUOTA;
> +	} else if (type != XFS_GROUP_QUOTA &&
> +	           type != XFS_PROJ_QUOTA &&
> +	           type != XFS_USER_QUOTA) {
> +		return command_usage(&limit_cmd);
> +	}

... we often put the && or the || at the end like this.
It just makes things line up nicely.

...

> @@ -686,7 +706,7 @@ edit_init(void)
>  	limit_cmd.argmin = 2;
>  	limit_cmd.argmax = -1;
>  	limit_cmd.args = \
> -	_("[-gpu] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");
> +	_("[-g|-p|-u] bsoft|bhard|isoft|ihard|rtbsoft|rtbhard=N -d|id|name");

yes, [-g|-p|-u] looks good.

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
> index 9116e48..5588a25 100644
> --- a/quota/quot.c
> +++ b/quota/quot.c
> @@ -62,9 +62,9 @@ quot_help(void)
>  "       total of all files greater than 500 kilobytes.\n"
>  " -v -- display three columns containing the number of kilobytes not\n"
>  "       accessed in the last 30, 60, and 90 days.\n"
> -" -g -- display group summary\n"
> -" -p -- display project summary\n"
> -" -u -- display user summary\n"
> +" -g -- display group summary, can't coexist with -p, -u\n"
> +" -p -- display project summary, can't coexist with -g, -u\n"
> +" -u -- display user summary, can't coexist with -g, -p\n"

again no need to re-state if you change the synopsis to make it clear;
but please do change quot_cmd.args to show that they are exclusive:

-        quot_cmd.args = _("[-bir] [-gpu] [-acv] [-f file]");
+        quot_cmd.args = _("[-bir] [-g|-p|-u] [-acv] [-f file]");

I think every command you changed might need to have the args fixed
up like this, and then you do not have change the longer *_help text.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
