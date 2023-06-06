Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6523C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 15:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbjFFPRn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 11:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjFFPRn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 11:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C035196
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 08:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBE5C62E46
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 15:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376A9C433D2;
        Tue,  6 Jun 2023 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686064661;
        bh=Ospp+zOoZBARzxwl9m6ji5TQHOO5OQPgLYTl5H4QLK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cav0JmoMGKqWEteE8VvsTKwAqz0EsgtLiC1LzgFt7W1WnkXTqKvmC8At6SjUs3H85
         PU9Kq3FCPpplkv9cbjzqU79J2ME3v5Cb1lS2AvdNzG1Ro/jF2Rj5kePjL9OW8Q4GOq
         Ipc79gMbZK4Qukxzk0eBGzHm3ZnjhCQlDQnYLob9+dE23hHLYy5kUIvmRM45EYvYFb
         xzWbwGZQP7QWIO5hRNlCqwd7xQ6NvPz/ON0b6s4FQOmoi0bda4c6gbEShmlx2akx9E
         zUme0Q/WqFXTabVRfL0cTC+xS20hn6fGw+URGPbnKBnYJ53PjWDy9eDWoG6AobKlO6
         eb3Io+/09gAfQ==
Date:   Tue, 6 Jun 2023 08:17:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 03/23] metadump: Declare boolean variables with bool
 type
Message-ID: <20230606151740.GP1325469@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-4-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-4-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:46PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 6bcfd5bb..8b33fbfb 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -51,13 +51,13 @@ static int		cur_index;
>  
>  static xfs_ino_t	cur_ino;
>  
> -static int		show_progress = 0;
> -static int		stop_on_read_error = 0;
> +static bool		show_progress = false;
> +static bool		stop_on_read_error = false;
>  static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
> -static int		obfuscate = 1;
> -static int		zero_stale_data = 1;
> -static int		show_warnings = 0;
> -static int		progress_since_warning = 0;
> +static bool		obfuscate = true;
> +static bool		zero_stale_data = true;
> +static bool		show_warnings = false;
> +static bool		progress_since_warning = false;
>  static bool		stdout_metadump;
>  
>  void
> @@ -100,7 +100,7 @@ print_warning(const char *fmt, ...)
>  
>  	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
>  			progname, buf);
> -	progress_since_warning = 0;
> +	progress_since_warning = false;
>  }
>  
>  static void
> @@ -121,7 +121,7 @@ print_progress(const char *fmt, ...)
>  	f = stdout_metadump ? stderr : stdout;
>  	fprintf(f, "\r%-59s", buf);
>  	fflush(f);
> -	progress_since_warning = 1;
> +	progress_since_warning = true;
>  }
>  
>  /*
> @@ -2979,9 +2979,9 @@ metadump_f(
>  	char		*p;
>  
>  	exitcode = 1;
> -	show_progress = 0;
> -	show_warnings = 0;
> -	stop_on_read_error = 0;
> +	show_progress = false;
> +	show_warnings = false;
> +	stop_on_read_error = false;
>  
>  	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
>  		print_warning("bad superblock magic number %x, giving up",
> @@ -3002,13 +3002,13 @@ metadump_f(
>  	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
>  		switch (c) {
>  			case 'a':
> -				zero_stale_data = 0;
> +				zero_stale_data = false;
>  				break;
>  			case 'e':
> -				stop_on_read_error = 1;
> +				stop_on_read_error = true;
>  				break;
>  			case 'g':
> -				show_progress = 1;
> +				show_progress = true;
>  				break;
>  			case 'm':
>  				max_extent_size = (int)strtol(optarg, &p, 0);
> @@ -3019,10 +3019,10 @@ metadump_f(
>  				}
>  				break;
>  			case 'o':
> -				obfuscate = 0;
> +				obfuscate = false;
>  				break;
>  			case 'w':
> -				show_warnings = 1;
> +				show_warnings = true;
>  				break;
>  			default:
>  				print_warning("bad option for metadump command");
> -- 
> 2.39.1
> 
