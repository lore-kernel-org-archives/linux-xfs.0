Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5580BC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0172064DD6
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbhBBTTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239635AbhBBTRC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 14:17:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21AEF60295;
        Tue,  2 Feb 2021 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612293375;
        bh=wcYpcNwxPG02BIthbCoOUZiZb5sHrJqEm87kKbP1N6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jo5ievj3bX4aItfFQ95V0/fXXG6tozea+JpdFxQ7Lq9Cf5pAcQy3I1m4d3iievK8B
         LgKrnp6ZhiDD7+nn+fqrdmPqjxLv0XFxkHrPvUGOyZit6y1fi1h2bt9cD/E4XZfYQM
         vZzBiS5QD/0gXfbuNxC+xQF140DSHvI4UkP9Y9iP/tB9oN1duWUHUdKeI4Aa5mgF6m
         oNvmo6xQx26SlI0akv+1TlCNPPm31znfVrqw6sx6JlhY1tY9MMj6XSxEfCyBU3SK9R
         RSNdOUoSoU3qeCdfAxSjwujwbWc6msK+oixYhc5XMTSv4U+qcVmsp2qtrIhmF17RlA
         RLqLDpgr2tbNA==
Date:   Tue, 2 Feb 2021 11:16:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_quota: drop pointless qsort cmp casting
Message-ID: <20210202191614.GN7193@magnolia>
References: <85f43472-5341-b979-3c7b-7e49a6ba0ce4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85f43472-5341-b979-3c7b-7e49a6ba0ce4@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 01:08:31PM -0600, Eric Sandeen wrote:
> The function cast in this call to qsort is odd - we don't do it
> anywhere else, and it doesn't gain us anything or help in any
> way.
> 
> So remove it; since we are now passing void *p pointers in, locally
> use du_t *d pointers to refer to the du_t's in the compare function.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks simple enough,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> diff --git a/quota/quot.c b/quota/quot.c
> index 8544aef6..9e8086c4 100644
> --- a/quota/quot.c
> +++ b/quota/quot.c
> @@ -173,16 +173,19 @@ quot_bulkstat_mount(
>  
>  static int
>  qcompare(
> -	du_t		*p1,
> -	du_t		*p2)
> +	const void	*p1,
> +	const void	*p2)
>  {
> -	if (p1->blocks > p2->blocks)
> +	du_t		*d1 = (struct du *)p1;
> +	du_t		*d2 = (struct du *)p2;
> +
> +	if (d1->blocks > d2->blocks)
>  		return -1;
> -	if (p1->blocks < p2->blocks)
> +	if (d1->blocks < d2->blocks)
>  		return 1;
> -	if (p1->id > p2->id)
> +	if (d1->id > d2->id)
>  		return 1;
> -	else if (p1->id < p2->id)
> +	else if (d1->id < d2->id)
>  		return -1;
>  	return 0;
>  }
> @@ -204,8 +207,7 @@ quot_report_mount_any_type(
>  
>  	fprintf(fp, _("%s (%s) %s:\n"),
>  		mount->fs_name, mount->fs_dir, type_to_string(type));
> -	qsort(dp, count, sizeof(dp[0]),
> -		(int (*)(const void *, const void *))qcompare);
> +	qsort(dp, count, sizeof(dp[0]), qcompare);
>  	for (; dp < &dp[count]; dp++) {
>  		if (dp->blocks == 0)
>  			return;
> 
