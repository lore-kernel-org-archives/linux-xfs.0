Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4DC77CA1
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 14:32:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B17418F8035
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 12:32:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4NmuutSOdqUK2UAz for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2016 12:32:57 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 45D004CDD2F
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 14:32:47 -0500 (CDT)
Subject: Re: [PATCH v2 3/3] xfs_quota: add case for foreign fs, disabled
	regardless of foreign_allowed
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
	<1473953386-10242-1-git-send-email-billodo@redhat.com>
	<1473953386-10242-4-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0f2f1d60-7d43-e7b2-f8db-26f14b9bd84d@sandeen.net>
Date: Thu, 15 Sep 2016 14:32:57 -0500
MIME-Version: 1.0
In-Reply-To: <1473953386-10242-4-git-send-email-billodo@redhat.com>
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

On 9/15/16 10:29 AM, Bill O'Donnell wrote:
> Some commands are disallowed for foreign filesystems,
> regardless of whether or not the -f flag is thrown.
> Add a case for this condition and improve commenting
> and output messaging accordingly in init_check_command.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

This looks good, though as I mentioned on IRC, 

# quota/xfs_quota -x /dev/sdb1 
xfs_quota> dump
dump: foreign filesystem. Use -f to enable.
xfs_quota> dump -f
dump: foreign filesystem. Use -f to enable.

that specific wording might be confusing.  :)

I think maybe:

-	fprintf(stderr, _("%s: foreign filesystem. Use -f to enable.\n"),
+	fprintf(stderr, _("%s: foreign filesystem. Invoke xfs_quota with -f to enable.\n"),

would be better - can you resend with that small change?

-Eric

> ---
>  quota/init.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/quota/init.c b/quota/init.c
> index 2c18c8b..7d69663 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -112,21 +112,28 @@ init_check_command(
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
> +	fprintf(stderr, _("%s: foreign filesystem. Use -f to enable.\n"),
>  		ct->name);
>  	return 0;
>  }
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
