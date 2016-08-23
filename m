Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F0E47CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 11:54:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98C7AAC002
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 09:54:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HsGC0siccDPqDgU6 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2016 09:54:49 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3E1C651E305
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 11:54:49 -0500 (CDT)
Subject: Re: [PATCH v3 2/2] xfs_quota: additional changes to allow use on ext4
References: <1471970426-5509-1-git-send-email-billodo@redhat.com>
	<1471970426-5509-3-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <07c520b8-ead6-4ff9-cc8c-463cc2c33d47@sandeen.net>
Date: Tue, 23 Aug 2016 11:54:48 -0500
MIME-Version: 1.0
In-Reply-To: <1471970426-5509-3-git-send-email-billodo@redhat.com>
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



On 8/23/16 11:40 AM, Bill O'Donnell wrote:
> Further changes to allow xfs_quota to be used on foreign filesystem(s)
> (e.g. ext4) for project quota testing in xfstests.
> 
> Add CMD_SKIP_CHECK to enable "generic" xfs_quota commands (help and
> quit) when xfs_quota is run on foreign filesystems.
> Use CMD_FLAG_FOREIGN_OK on commands suitable for foreign filesystems.
> Refactor init_check_command in quota/init.c for clarity.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  libxcmd/help.c |  4 +++-
>  libxcmd/quit.c |  4 +++-
>  quota/init.c   | 29 ++++++++++++++++++++---------
>  quota/init.h   |  2 ++
>  4 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/libxcmd/help.c b/libxcmd/help.c
> index fad0ab9..d2e72a0 100644
> --- a/libxcmd/help.c
> +++ b/libxcmd/help.c
> @@ -18,6 +18,7 @@
>  
>  #include "platform_defs.h"
>  #include "command.h"
> +#include "../quota/init.h"
>  
>  static cmdinfo_t help_cmd;
>  static void help_onecmd(const char *cmd, const cmdinfo_t *ct);
> @@ -88,7 +89,8 @@ help_init(void)
>  	help_cmd.cfunc = help_f;
>  	help_cmd.argmin = 0;
>  	help_cmd.argmax = 1;
> -	help_cmd.flags = CMD_FLAG_GLOBAL;
> +	help_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK |
> +		CMD_SKIP_CHECK;

Nitpick, but no need to set both FOREIGN_OK and SKIP_CHECK, right?
If the first is set, the 2nd is never tested (below), I think?

>  	help_cmd.args = _("[command]");
>  	help_cmd.oneline = _("help for one or all commands");
>  
> diff --git a/libxcmd/quit.c b/libxcmd/quit.c
> index 0183b8f..9dbd29a 100644
> --- a/libxcmd/quit.c
> +++ b/libxcmd/quit.c
> @@ -18,6 +18,7 @@
>  
>  #include "platform_defs.h"
>  #include "command.h"
> +#include "../quota/init.h"
>  
>  static cmdinfo_t quit_cmd;
>  
> @@ -38,7 +39,8 @@ quit_init(void)
>  	quit_cmd.cfunc = quit_f;
>  	quit_cmd.argmin = -1;
>  	quit_cmd.argmax = -1;
> -	quit_cmd.flags = CMD_FLAG_GLOBAL;
> +	quit_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK |
> +		CMD_SKIP_CHECK;
>  	quit_cmd.oneline = _("exit the program");
>  
>  	add_command(&quit_cmd);
> diff --git a/quota/init.c b/quota/init.c
> index 137cd68..b487dd5 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -109,15 +109,26 @@ static int
>  init_check_command(
>  	const cmdinfo_t	*ct)
>  {
> -	if (fs_path &&
> -	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
> -	     (fs_path->fs_flags & FS_FOREIGN)) {
> -		fprintf(stderr,
> -	_("foreign mount active, %s command is for XFS filesystems only\n"),
> -			ct->name);
> -		return 0;
> -	}
> -	return 1;
> +	if (!fs_path)
> +		return 1;
> +
> +	/* Always run commands that we are told to skip here */
> +	if (ct->flags & CMD_SKIP_CHECK)
> +		return 1;
> +
> +	/* if it's an XFS filesystem, always run the command */
> +	if (!(fs_path->fs_flags & FS_FOREIGN))
> +		return 1;
> +
> +	/* If the user specified foreign filesysetms are ok, run it */
> +	if (foreign_allowed &&
> +	    (ct->flags & CMD_FLAG_FOREIGN_OK))
> +		return 1;
> +
> +	/* foreign filesystem and it's no a valid command! */

s/no/not/ while you're at it :)

> +	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
> +		ct->name);
> +	return 0;
>  }
>  
>  static void
> diff --git a/quota/init.h b/quota/init.h
> index 6879855..aa1cc51 100644
> --- a/quota/init.h
> +++ b/quota/init.h
> @@ -31,3 +31,5 @@ extern void	report_init(void);
>  extern void	state_init(void);
>  
>  extern void init_cvtnum(unsigned int *, unsigned int *);
> +
> +#define CMD_SKIP_CHECK	(1<<0) /* command is always run */

how about "always available" - it's not run unless it's invoked.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
