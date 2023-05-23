Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1999C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbjEWRmv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjEWRmv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:42:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4423B5
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC6A62C62
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA32EC433D2;
        Tue, 23 May 2023 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863768;
        bh=piVZWzg8w+Cd+0A612xxaYMDqccraQUjUoA/I+eNmRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WdA/NhD8UXA7ykVmCalEW7DaOd6RkRz3erQcdhGB3RqyV/eHXIEGgmzI+Vvk7xj9A
         gq5w7BvZQF7ITYouc4gAXIv8BlHxDN05PfQXIsDsGh1Y5cTdGg799RWlHMfQ14HaYZ
         Hm/RmnKpwDK2uZUzew9oq4dNMgaSQEGL2qNR2sHpb29IMcwKUIwoD6GXNf5EYjDfgX
         B3yDppIJhdfaB1sZQf2F7X4osstxp/kh3QkOPG72S8rhq9xqlCWATZ4N43D5/LiDn4
         WzwgvedFOt2Fgkk+VA77/KWYCS2TbUs2TCH2cQTLmndsQrhUZaMO2NJIurZ/Z2Ilw5
         upIgrRqUT3Gsg==
Date:   Tue, 23 May 2023 10:42:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/24] mdrestore: Define and use struct mdrestore
Message-ID: <20230523174248.GW11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-17-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-17-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:42PM +0530, Chandan Babu R wrote:
> This commit collects all state tracking variables in a new "struct mdrestore"
> structure.

Same comment as patch 3.

--D

> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 481dd00c2..de9175a08 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -7,9 +7,11 @@
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
>  
> -static int	show_progress = 0;
> -static int	show_info = 0;
> -static int	progress_since_warning = 0;
> +static struct mdrestore {
> +	int	show_progress;
> +	int	show_info;
> +	int	progress_since_warning;
> +} mdrestore;
>  
>  static void
>  fatal(const char *msg, ...)
> @@ -35,7 +37,7 @@ print_progress(const char *fmt, ...)
>  
>  	printf("\r%-59s", buf);
>  	fflush(stdout);
> -	progress_since_warning = 1;
> +	mdrestore.progress_since_warning = 1;
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
> +	mdrestore.show_progress = 0;
> +	mdrestore.show_info = 0;
> +	mdrestore.progress_since_warning = 0;
> +
>  	progname = basename(argv[0]);
>  
>  	while ((c = getopt(argc, argv, "giV")) != EOF) {
>  		switch (c) {
>  			case 'g':
> -				show_progress = 1;
> +				mdrestore.show_progress = 1;
>  				break;
>  			case 'i':
> -				show_info = 1;
> +				mdrestore.show_info = 1;
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
