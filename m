Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42902 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbcIOUnV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 16:43:21 -0400
Subject: Re: [PATCH v3 3/3] xfs_quota: add case for foreign fs, disabled
 regardless of foreign_allowed
References: <1473953386-10242-4-git-send-email-billodo@redhat.com>
 <1473969469-27354-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e01db6be-d444-da1c-4f93-9d3aeeca1dd6@sandeen.net>
Date: Thu, 15 Sep 2016 15:43:19 -0500
MIME-Version: 1.0
In-Reply-To: <1473969469-27354-1-git-send-email-billodo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

On 9/15/16 2:57 PM, Bill O'Donnell wrote:
> Some commands are disallowed for foreign filesystems,
> regardless of whether or not the -f flag is thrown.
> Add a case for this condition and improve commenting
> and output messaging accordingly in init_check_command.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Thanks, Bill.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> history:
> v3: clarify foreign filesystem user output message.
> v2: no change
> v1: http://www.spinics.net/lists/linux-xfs/msg00685.html
> 
>  quota/init.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/quota/init.c b/quota/init.c
> index 2c18c8b..3bebbb8 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -112,21 +112,29 @@ init_check_command(
>  	if (!fs_path)
>  		return 1;
>  
> -	/* Always run commands that we are told to skip here */
> +	/* Always run commands that are valid for all fs types. */
>  	if (ct->flags & CMD_ALL_FSTYPES)
>  		return 1;
>  
> -	/* if it's an XFS filesystem, always run the command */
> +	/* If it's an XFS filesystem, always run the command. */
>  	if (!(fs_path->fs_flags & FS_FOREIGN))
>  		return 1;
>  
> -	/* If the user specified foreign filesysetms are ok, run it */
> +	/* If the user specified foreign filesystems are ok (-f), run cmd. */
>  	if (foreign_allowed &&
>  	    (ct->flags & CMD_FLAG_FOREIGN_OK))
>  		return 1;
>  
> -	/* foreign filesystem and it's not a valid command! */
> -	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
> +	/* If cmd not allowed on foreign fs, regardless of -f flag, skip it. */
> +	if (!(ct->flags & CMD_FLAG_FOREIGN_OK)) {
> +		fprintf(stderr, _("%s: command is for XFS filesystems only\n"),
> +			ct->name);
> +		return 0;
> +	}
> +
> +	/* foreign fs, but cmd only allowed via -f flag. Skip it. */
> +	fprintf(stderr,
> +		_("%s: foreign filesystem. Invoke xfs_quota with -f to enable.\n"),
>  		ct->name);
>  	return 0;
>  }
> 
