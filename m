Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6A0EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 18:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbjGLSKk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjGLSKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 14:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE451FFD
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 11:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652136187A
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 18:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E29C433C8;
        Wed, 12 Jul 2023 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689185428;
        bh=FZxtLLfrXhC9H5G7ohwJoEjqPrYYV5P5BFYoekk4Jeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rgD9tKMUJ03WvwItZee5zKAvjUxSmvqsetHNVceXuwDRp/Dv6Zo+G7eVK1tDK2f3e
         Y6ScdSBCHitIFqDQLpPMNt0rfyZZZfEyaU/mdpW6Goaep/rUwFLqo0g31Xl/SCZW7O
         OUp6SQyauSE61IbGTPxt6mjWsPVIjeRSvK6wkotQIgOGSsMtQ3PZF9adafUvnTK85k
         WA7FSaWI+6AzUaieKi5JkqEFzQRXvuGIAJ7aTJyI6v7m6vc2fiqjVP4AKZiIv0XBou
         G59CBClKLrHMG8F57MjyX9hiXSLG1EFQ2xg5x/M2zS6K3h6WkF5izw4n57+7nA/8QN
         yrn2eoOTAdUNA==
Date:   Wed, 12 Jul 2023 11:10:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 23/23] mdrestore: Add support for passing log device
 as an argument
Message-ID: <20230712181028.GR108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-24-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-24-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:58:06PM +0530, Chandan Babu R wrote:
> metadump v2 format allows dumping metadata from external log devices. This
> commit allows passing the device file to which log data must be restored from
> the corresponding metadump file.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Woot, thanks for working on this!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  man/man8/xfs_mdrestore.8  |  8 ++++++++
>  mdrestore/xfs_mdrestore.c | 11 +++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
> index 72f3b297..6e7457c0 100644
> --- a/man/man8/xfs_mdrestore.8
> +++ b/man/man8/xfs_mdrestore.8
> @@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
>  .B xfs_mdrestore
>  [
>  .B \-gi
> +] [
> +.B \-l
> +.I logdev
>  ]
>  .I source
>  .I target
> @@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
>  is specified, exits after displaying information.  Older metadumps man not
>  include any descriptive information.
>  .TP
> +.B \-l " logdev"
> +Metadump in v2 format can contain metadata dumped from an external log.
> +In such a scenario, the user has to provide a device to which the log device
> +contents from the metadump file are copied.
> +.TP
>  .B \-V
>  Prints the version number and exits.
>  .SH DIAGNOSTICS
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 7b484071..7d7c22fe 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -460,7 +460,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
>  static void
>  usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
> +		progname);
>  	exit(1);
>  }
>  
> @@ -490,7 +491,7 @@ main(
>  
>  	progname = basename(argv[0]);
>  
> -	while ((c = getopt(argc, argv, "giV")) != EOF) {
> +	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
>  		switch (c) {
>  			case 'g':
>  				mdrestore.show_progress = true;
> @@ -498,6 +499,10 @@ main(
>  			case 'i':
>  				mdrestore.show_info = true;
>  				break;
> +			case 'l':
> +				logdev = optarg;
> +				mdrestore.external_log = true;
> +				break;
>  			case 'V':
>  				printf("%s version %s\n", progname, VERSION);
>  				exit(0);
> @@ -536,6 +541,8 @@ main(
>  
>  	switch (be32_to_cpu(magic)) {
>  	case XFS_MD_MAGIC_V1:
> +		if (logdev != NULL)
> +			usage();
>  		mdrestore.mdrops = &mdrestore_ops_v1;
>  		break;
>  
> -- 
> 2.39.1
> 
