Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265F3EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 18:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjGLSM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjGLSM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 14:12:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291F01FE3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 11:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3905618A8
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 18:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096D9C433C8;
        Wed, 12 Jul 2023 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689185542;
        bh=RoDf+kyFcYb6zEowK82tfWfHZ3onfuRTeXDBI2+jsfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N1+WpACDhM80ppfi7Bbpgp1M7XlMYd9EdtQH3Ki8mR1zOx3epi14LxOJU0X11ifIA
         v6QOpJxBAcb0G+P+g7huAtD1Mqc0OjF2bl2nD1xISkSTJROemmF9pt7uDwVN0Yu+sY
         k855IpHxzi7D6BOWgRIzqcf8mBNwxEuLcxdyoqy1dixtmG7kT7P7wUS/gPESYgVAMG
         X/AT1FbVfh6ZX/WWSDGxj/egvnc6e/31jeMTjc4PdHwQLkrrWV3ey4a9wui41mDg+6
         JqJvFlSBCGM9ey+iow2+vFtWvkyVU1HNwuFo8txOkuP/ojnJbcG9d1r1UiuLBBH9b3
         9Dk2umXNRhB1A==
Date:   Wed, 12 Jul 2023 11:12:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 15/23] mdrestore: Define and use struct mdrestore
Message-ID: <20230712181221.GT108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-16-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:58PM +0530, Chandan Babu R wrote:
> This commit collects all state tracking variables in a new "struct mdrestore"
> structure. This is done to collect all the global variables in one place
> rather than having them spread across the file. A new structure member of type
> "struct mdrestore_ops *" will be added by a future commit to support the two
> versions of metadump.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Same comments as patch 4.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index ca28c48e..564630f7 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -7,9 +7,11 @@
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
>  
> -static bool	show_progress = false;
> -static bool	show_info = false;
> -static bool	progress_since_warning = false;
> +static struct mdrestore {
> +	bool	show_progress;
> +	bool	show_info;
> +	bool	progress_since_warning;
> +} mdrestore;
>  
>  static void
>  fatal(const char *msg, ...)
> @@ -35,7 +37,7 @@ print_progress(const char *fmt, ...)
>  
>  	printf("\r%-59s", buf);
>  	fflush(stdout);
> -	progress_since_warning = true;
> +	mdrestore.progress_since_warning = true;
>  }
>  
>  /*
> @@ -127,7 +129,8 @@ perform_restore(
>  	bytes_read = 0;
>  
>  	for (;;) {
> -		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
> +		if (mdrestore.show_progress &&
> +			(bytes_read & ((1 << 20) - 1)) == 0)
>  			print_progress("%lld MB read", bytes_read >> 20);
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
> @@ -158,7 +161,7 @@ perform_restore(
>  		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
>  	}
>  
> -	if (progress_since_warning)
> +	if (mdrestore.progress_since_warning)
>  		putchar('\n');
>  
>  	memset(block_buffer, 0, sb.sb_sectsize);
> @@ -197,15 +200,19 @@ main(
>  	int		is_target_file;
>  	struct xfs_metablock	mb;
>  
> +	mdrestore.show_progress = false;
> +	mdrestore.show_info = false;
> +	mdrestore.progress_since_warning = false;
> +
>  	progname = basename(argv[0]);
>  
>  	while ((c = getopt(argc, argv, "giV")) != EOF) {
>  		switch (c) {
>  			case 'g':
> -				show_progress = true;
> +				mdrestore.show_progress = true;
>  				break;
>  			case 'i':
> -				show_info = true;
> +				mdrestore.show_info = true;
>  				break;
>  			case 'V':
>  				printf("%s version %s\n", progname, VERSION);
> @@ -219,7 +226,7 @@ main(
>  		usage();
>  
>  	/* show_info without a target is ok */
> -	if (!show_info && argc - optind != 2)
> +	if (!mdrestore.show_info && argc - optind != 2)
>  		usage();
>  
>  	/*
> @@ -243,7 +250,7 @@ main(
>  	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
>  		fatal("specified file is not a metadata dump\n");
>  
> -	if (show_info) {
> +	if (mdrestore.show_info) {
>  		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
>  			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>  			argv[optind],
> -- 
> 2.39.1
> 
