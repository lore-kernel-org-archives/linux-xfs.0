Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E59C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbjEWRlY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237715AbjEWRlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC96F8E
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6191B63538
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC742C433EF;
        Tue, 23 May 2023 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863681;
        bh=g9ZnFMcu+dBo/ijWyx0y5LKE5L0ZwOxKxbXlXthgPrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dvP9ci+ohaMr43eGFmILBXDoEKj1c8nDDGjC/qt4WMajSRmvCJAnIB4EthXjEp4vS
         j03mi76khbPPKAwM+wVZpNi+MYl9W1L53YheYWIpSjy77WL6xBi9BY0ch0Uhd5aebW
         Ge6T7Y5r/Y1Au9U9TC2QRsHC3wpskAswSQ89zxpQ3rVuQE4QEz23ELLPvInWuLnCVJ
         ur4f8RLXFPHUlwlQ+ObGrEVkuyhNK2Qquln3z1wSkrnt2XEyBYtIiSxHXR9JUrnKdt
         /8Ix23+LKueKsQZaqzsvuGXsjCZP+wdMhN0Rezol8vu/pwC0rcs9jbDtMUZ4aCaQug
         wpXnQavxN8Wrw==
Date:   Tue, 23 May 2023 10:41:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] metadump: Add support for passing version option
Message-ID: <20230523174121.GV11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-14-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:39PM +0530, Chandan Babu R wrote:
> The new option allows the user to explicitly specify the version of metadump
> to use. However, we will default to using the v1 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks fine,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 627436e68..df508b987 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -37,7 +37,7 @@ static void	metadump_help(void);
>  
>  static const cmdinfo_t	metadump_cmd =
>  	{ "metadump", NULL, metadump_f, 0, -1, 0,
> -		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
> +		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
>  		N_("dump metadata to a file"), metadump_help };
>  
>  struct metadump_ops {
> @@ -91,6 +91,7 @@ metadump_help(void)
>  "   -g -- Display dump progress\n"
>  "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
>  "   -o -- Don't obfuscate names and extended attributes\n"
> +"   -v -- Metadump version to be used\n"
>  "   -w -- Show warnings of bad metadata information\n"
>  "\n"), DEFAULT_MAX_EXT_SIZE);
>  }
> @@ -3112,6 +3113,7 @@ metadump_f(
>  	int		outfd = -1;
>  	int		ret;
>  	char		*p;
> +	bool		version_opt_set = false;
>  
>  	exitcode = 1;
>  
> @@ -3140,7 +3142,7 @@ metadump_f(
>  		return 0;
>  	}
>  
> -	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
> +	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
>  		switch (c) {
>  			case 'a':
>  				metadump.zero_stale_data = 0;
> @@ -3164,6 +3166,15 @@ metadump_f(
>  			case 'o':
>  				metadump.obfuscate = 0;
>  				break;
> +			case 'v':
> +				metadump.version = (int)strtol(optarg, &p, 0);
> +				if (*p != '\0' || (metadump.version != 1 && metadump.version != 2)) {
> +					print_warning("bad metadump version: %s",
> +						optarg);
> +					return 0;
> +				}
> +				version_opt_set = true;
> +				break;
>  			case 'w':
>  				metadump.show_warnings = 1;
>  				break;
> @@ -3178,6 +3189,9 @@ metadump_f(
>  		return 0;
>  	}
>  
> +	if (mp->m_logdev_targp != mp->m_ddev_targp && version_opt_set == false)
> +		metadump.version = 2;
> +
>  	/* If we'll copy the log, see if the log is dirty */
>  	if (mp->m_logdev_targp == mp->m_ddev_targp || metadump.version == 2) {
>  		log_type = TYP_LOG;
> -- 
> 2.39.1
> 
