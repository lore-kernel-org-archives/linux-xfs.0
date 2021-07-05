Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293EEC07E99
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDCC61964
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGEPXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 11:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhGEPXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 11:23:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483B7C061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 08:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/kIx/Gu6d8u0Mwi6Bj1TXRZMxSa200AUHpU/sdcex9Y=; b=KWQDWhLb5l3dXSFeGAvyuV/IWc
        IAeUtvyoURHjX/VQ2W1Nkb2CeqlSrip0cxCGG0XzQ4d/wv/YhML7zlgIOSJSA+jTbzGrkbT3yuBZB
        0SAI8yaLpSUM5rmzHVhGchiRVlay7jvcIeqjDFI+0+pHLSBC6vwctaVb6vgRRb2JI+h2DMHLfbIJ6
        EImxwno59NRL0FNmPiZF2R2p0qGM3eiuEz2mw562tT7MUt54Sr9xGsIExm7VOgeWSio8UKJsrq4Mp
        bjXJ54TyHUxKcK7ALkQrHrSZowkP4eiXlpDoROZBJqSMnFRA8asrwO4BuElahLwrT6Jn0glJL69rS
        cntkm1jw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0QOE-00AM2J-E6; Mon, 05 Jul 2021 15:20:14 +0000
Date:   Mon, 5 Jul 2021 16:20:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: clean up the funshare command a bit
Message-ID: <YOMjJmxA7WjO8kGq@infradead.org>
References: <162528107717.36401.11135745343336506049.stgit@locust>
 <162528108811.36401.13142861358282476701.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528108811.36401.13142861358282476701.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add proper argument parsing to the funshare command so that when you
> pass it nonexistent --help it will print the help instead of complaining
> that it can't convert that to a number.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  io/prealloc.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/io/prealloc.c b/io/prealloc.c
> index 2ae8afe9..94cf326f 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -346,16 +346,24 @@ funshare_f(
>  	char		**argv)
>  {
>  	xfs_flock64_t	segment;
> +	int		c;
>  	int		mode = FALLOC_FL_UNSHARE_RANGE;
> -	int		index = 1;
>  
> -	if (!offset_length(argv[index], argv[index + 1], &segment)) {
> +	while ((c = getopt(argc, argv, "")) != EOF) {
> +		switch (c) {
> +		default:
> +			command_usage(&funshare_cmd);
> +		}

Do we really need this switch boilerplate?

> +	}
> +        if (optind != argc - 2)
> +                return command_usage(&funshare_cmd);

Spaces instead of tabs here.
