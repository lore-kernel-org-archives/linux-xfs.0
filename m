Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958B8C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 18:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjEWSKC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 14:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEWSKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 14:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE81697
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 11:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A878611F0
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2022C433D2;
        Tue, 23 May 2023 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684865399;
        bh=NOTwyKM8JjnJF+VSZYQeA2uIB3e7CQEFFH8CzAK4vQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6j6A6godB43Tt7T6+16AQvUM4rWwvy2atGLE2u56pBNcm81zqkOtKYUVbPQZfcK6
         Z0tUFk0ZexRlT6dquSyDTkSO43WXSKk+UaF1ZPqgYN005wb2BFe51YMZedoGROEp3P
         yg4kJQzMXFVX4DzXMXJ+JJemtGM43TqBoEVCek0BtlmQhJ3URjnJP4AzPcqnLDT5JV
         Wjm6VDq4QLDtki73YZkbd1eWB7y9P2Il4AE8NKPuXoQHJecCo+Zv/vdpI1qFixDEFw
         0nBEcTZV4IiaybyPUhneOB4wLQNRjMrlVy0ZdmVLNPLxSfBWbNDDk4VgKVS2dEKxzQ
         vK0xVQyi4l2zA==
Date:   Tue, 23 May 2023 11:09:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/24] mdrestore: Add support for passing log device as
 an argument
Message-ID: <20230523180959.GC11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-24-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-24-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:49PM +0530, Chandan Babu R wrote:
> metadump v2 format allows dumping metadata from external log devices. This
> commit allows passing the device file to which log data must be restored from
> the corresponding metadump file.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 9e06d37dc..f5eff62ef 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -427,7 +427,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
>  static void
>  usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
> +		progname);
>  	exit(1);
>  }
>  
> @@ -453,7 +454,7 @@ main(
>  
>  	progname = basename(argv[0]);
>  
> -	while ((c = getopt(argc, argv, "giV")) != EOF) {
> +	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
>  		switch (c) {
>  			case 'g':
>  				mdrestore.show_progress = 1;
> @@ -461,6 +462,9 @@ main(
>  			case 'i':
>  				mdrestore.show_info = 1;
>  				break;
> +			case 'l':
> +				logdev = optarg;
> +				break;
>  			case 'V':
>  				printf("%s version %s\n", progname, VERSION);
>  				exit(0);
> @@ -493,6 +497,8 @@ main(
>  	}
>  
>  	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
> +		if (logdev != NULL)
> +			usage();
>  		mdrestore.mdrops = &mdrestore_ops_v1;
>  		header = &mb;
>  	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {

What if we have a v2 with XME_ADDR_LOG_DEVICE meta_extents but the
caller doesn't specify -l?  Do we proceed with the metadump, only to
fail midway through the restore?

--D

> -- 
> 2.39.1
> 
