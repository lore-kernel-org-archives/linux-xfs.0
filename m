Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C93AC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 00:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbhLKAZg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 19:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhLKAZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 19:25:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126DDC061714
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 16:22:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E031CE23DC
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 00:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D88BC00446;
        Sat, 11 Dec 2021 00:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639182116;
        bh=Cypc9oF7uVvHgoijRjxpxIWf40FbUf6TBJhbkpmUbTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yk8LkK+6mRCm19H8fLmyegsH6TV2xwfkIIVRVRvIMljJAJN862qo5W6hRS6ei6h/g
         XSV6ZvOwOayA3jiPer32dv6BH/oy/SWKHFK3O77YYw4xJdy7zPR0ptqMqFkQ2obAFI
         Q0PD3PwtFsosxaBkGFP+YUjqHHF0PJxKiGXRxaQb9YxfeVxKjAhP5g4u3/yE6pBxAz
         JXZbDE2/PpckGsKAXg69bohREp9n8Rs40A4aRkSzNrHB7LNzqG9mIHQ6772c+EWNKT
         vfGrzmOW7uUOHP8+18G9i2qXwm3BB6pySLWin9GnPBID+fGYWfSX6iADwpXIMQgZGG
         93leZZtcJ3Org==
Date:   Fri, 10 Dec 2021 16:21:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_quota: don't exit on
 fs_table_insert_project_path failure
Message-ID: <20211211002156.GC1218082@magnolia>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-4-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639167697-15392-4-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 02:21:36PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> If "project -p" fails in fs_table_insert_project_path, it
> calls exit() today which is quite unfriendly. Return an error
> and return to the command prompt as expected.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  libfrog/paths.c | 7 +++----
>  libfrog/paths.h | 2 +-
>  quota/project.c | 4 +++-
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index d679376..6c0fee2 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -546,7 +546,7 @@ out_error:
>  		progname, strerror(error));
>  }
>  
> -void
> +int
>  fs_table_insert_project_path(
>  	char		*dir,
>  	prid_t		prid)
> @@ -561,9 +561,8 @@ fs_table_insert_project_path(
>  	else
>  		error = ENOENT;
>  
> -	if (error) {
> +	if (error)
>  		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
>  				progname, dir, strerror(error));

Why not move this to the (sole) caller?  Libraries (even pseudolibraries
like libfrog) usually aren't supposed to go around fprintfing things.

--D

> -		exit(1);
> -	}
> +	return error;
>  }
> diff --git a/libfrog/paths.h b/libfrog/paths.h
> index c08e373..f20a2c3 100644
> --- a/libfrog/paths.h
> +++ b/libfrog/paths.h
> @@ -40,7 +40,7 @@ extern char *mtab_file;
>  extern void fs_table_initialise(int, char *[], int, char *[]);
>  extern void fs_table_destroy(void);
>  
> -extern void fs_table_insert_project_path(char *__dir, uint __projid);
> +extern int fs_table_insert_project_path(char *__dir, uint __projid);
>  
>  
>  extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
> diff --git a/quota/project.c b/quota/project.c
> index 03ae10d..bed0dc5 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -281,7 +281,9 @@ project_f(
>  			break;
>  		case 'p':
>  			ispath = 1;
> -			fs_table_insert_project_path(optarg, -1);
> +			/* fs_table_insert_project_path prints the failure */
> +			if (fs_table_insert_project_path(optarg, -1))
> +				return 0;
>  			break;
>  		case 's':
>  			type = SETUP_PROJECT;
> -- 
> 1.8.3.1
> 
