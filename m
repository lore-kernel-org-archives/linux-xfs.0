Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEF6C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 11:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbjFFLgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 07:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbjFFLg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 07:36:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA18E10D7
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 04:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F27C63111
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 11:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE00FC433EF;
        Tue,  6 Jun 2023 11:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686051380;
        bh=VTNWIXA4IduVlj1a5AEP7ar/MNZhe87H9hVotDAqIlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=etgyJyXmvHFbyjnQafFYPw6myld+ELNsYRc/SDHK2pZyB9CIy2tSdLShsCqZmbW87
         pTY4kRbxyFUmAQ7N6bG5/Mbwz/EYuOcU4vLNDEl/IZ97hxjHTPeB1Psl8p6RaIYolS
         9YP8IjNEIPwvjBvyFokqar7QGwK1cXqU57VSZ6F4akK4SuABQOzXlzQTR0shogiKUB
         DVMxTEfG02HfZmVta3zIEfKMQePRPrMp8lS49taiH932ZhOQ0kVpeJjuCFMPMgJzsC
         Y7NQxwGo9mF/xy6FUnDZ+EVAmpjJdqQAP3S3cLnIAOPqPspW1aHkQnpRzJDOUeWP8h
         v4sdsgIp/7QyQ==
Date:   Tue, 6 Jun 2023 13:36:16 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_db: make the hash command print the dirent hash
Message-ID: <20230606113616.d2dagrkpevp25wdw@andromeda>
References: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
 <q345I7M3P0LqhHKE5BxH7EgAL1LGpmOhvabdzG7ZRSSAHVmNN95kzbsRFy5NK81TURR4CeY4TIOcWgP4SAX3Tw==@protonmail.internalid>
 <168597943560.1226265.697249744236069044.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597943560.1226265.697249744236069044.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:37:15AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that the da and dir2 hashname functions are /not/ the same,
> at least not on ascii-ci filesystems.  Enhance this debugger command to
> support printing the dir2 hashname.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good, will test.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/hash.c         |   42 +++++++++++++++++++++++++++++++++++++-----
>  man/man8/xfs_db.8 |    8 +++++++-
>  2 files changed, 44 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/db/hash.c b/db/hash.c
> index 79a250526e9..716da88baf9 100644
> --- a/db/hash.c
> +++ b/db/hash.c
> @@ -18,9 +18,15 @@
>  static int hash_f(int argc, char **argv);
>  static void hash_help(void);
> 
> -static const cmdinfo_t hash_cmd =
> -	{ "hash", NULL, hash_f, 1, 1, 0, N_("string"),
> -	  N_("calculate hash value"), hash_help };
> +static const cmdinfo_t hash_cmd = {
> +	.name		= "hash",
> +	.cfunc		= hash_f,
> +	.argmin		= 1,
> +	.argmax		= -1,
> +	.args		= N_("string"),
> +	.oneline	= N_("calculate hash value"),
> +	.help		= hash_help,
> +};
> 
>  static void
>  hash_help(void)
> @@ -43,9 +49,35 @@ hash_f(
>  	char		**argv)
>  {
>  	xfs_dahash_t	hashval;
> +	bool		use_dir2_hash = false;
> +	int		c;
> +
> +	while ((c = getopt(argc, argv, "d")) != EOF) {
> +		switch (c) {
> +		case 'd':
> +			use_dir2_hash = true;
> +			break;
> +		default:
> +			exitcode = 1;
> +			hash_help();
> +			return 0;
> +		}
> +	}
> +
> +	for (c = optind; c < argc; c++) {
> +		if (use_dir2_hash) {
> +			struct xfs_name	xname = {
> +				.name	= (uint8_t *)argv[c],
> +				.len	= strlen(argv[c]),
> +			};
> +
> +			hashval = libxfs_dir2_hashname(mp, &xname);
> +		} else {
> +			hashval = libxfs_da_hashname(argv[c], strlen(argv[c]));
> +		}
> +		dbprintf("0x%x\n", hashval);
> +	}
> 
> -	hashval = libxfs_da_hashname((unsigned char *)argv[1], (int)strlen(argv[1]));
> -	dbprintf("0x%x\n", hashval);
>  	return 0;
>  }
> 
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index fde1c5c6c69..60dcdc52cba 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -763,10 +763,16 @@ Skip write verifiers but perform CRC recalculation; allows invalid data to be
>  written to disk to test detection of invalid data.
>  .RE
>  .TP
> -.BI hash " string
> +.BI hash [-d]" strings
>  Prints the hash value of
>  .I string
>  using the hash function of the XFS directory and attribute implementation.
> +
> +If the
> +.B \-d
> +option is specified, the directory-specific hash function is used.
> +This only makes a difference on filesystems with ascii case-insensitive
> +lookups enabled.
>  .TP
>  .BI "hashcoll [-a] [-s seed] [-n " nr "] [-p " path "] -i | " names...
>  Create directory entries or extended attributes names that all have the same
> 
