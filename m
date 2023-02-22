Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402E9C61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 09:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjBVJD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 04:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjBVJDV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 04:03:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261B846A7
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 01:03:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C09FCE1D3F
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 09:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23B0C433EF;
        Wed, 22 Feb 2023 09:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677056587;
        bh=x6BsXSiOeinlLywQUVRyJmkvfVI5XvV4f1nSMTGa8tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZsOB2ujfTmpGrC3FZBep88BQ/Q1DmH+Rn2L9fuwt46fIhuDS8ZBD+v/CeMh/voAZo
         PVqzj+WJxVPnL5mZTh3guIcc5jAh4vjeszTumFhy8gGf/+Ox+RyEaM9kOpptYhFK1e
         OYiGiRVC0zZWSzZhunS3R5E2sg0urdSZl4Fwer6fJgjcRfZ1BPi1wOp8eQf/2MA4/s
         xhU0nteP6Na3yW72oeczx6jmxgRr9YgaoWhekuWtVhjauCLyJ/BRfCfg8sasOUdW21
         jyFIrMjAWrPUjpkHcYaDj0C/lH/QzeUZqaSInSpGTPCuKaQBgedwZtg5FSKBYryDzF
         WB1vdQSE1/UAQ==
Date:   Wed, 22 Feb 2023 10:03:03 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 5/5] mkfs: substitute slashes with spaces in protofiles
Message-ID: <20230222090303.h6tujm7y32gjhgal@andromeda>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <qZxM14CxXi0qImx6yvZqGUGk9ONznMyOXDa_zw1hzM3z5HY0Mlo-VdP5KLv2NxaKEvAe9qQn5RO-qFRMUKciAQ==@protonmail.internalid>
 <167658439591.3590000.1501103007888420501.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167658439591.3590000.1501103007888420501.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2023 at 01:53:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A user requested the ability to specify directory entry names in a
> protofile that have spaces in them.  The protofile format itself does
> not allow spaces (yay 1973-era protofiles!) but it does allow slashes.
> Slashes aren't allowed in directory entry names, so we'll permit this
> one gross hack.
> 
> /
> 0 0
> d--775 1000 1000
> : Descending path /code/t/fstests
>  get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
> $
> 
> Will produce "get isk.h" in the root directory.
> 

While I don't really mind this patch, it seems strange to me to simply replace a
slash with a space in lieu of failing the prototype with an 'invalid character'
error message, or something like that.
With this patch, an user could be mistakenly assuming the get/isk.sh path will
be created, and instead, what's gonna be created is a file with a space.
I don't really mind it, but I think we could be misleading users.


> Requested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/proto.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 68ecdbf3632..bf8de0189db 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -171,6 +171,27 @@ getstr(
>  	return NULL;
>  }
> 
> +/* Extract directory entry name from a protofile. */
> +static char *
> +getdirentname(
> +	char	**pp)
> +{
> +	char	*p = getstr(pp);
> +	char	*c = p;
> +
> +	if (!p)
> +		return NULL;
> +
> +	/* Replace slash with space because slashes aren't allowed. */
> +	while (*c) {
> +		if (*c == '/')
> +			*c = ' ';
> +		c++;
> +	}
> +
> +	return p;
> +}
> +
>  static void
>  rsvfile(
>  	xfs_mount_t	*mp,
> @@ -580,7 +601,7 @@ parseproto(
>  			rtinit(mp);
>  		tp = NULL;
>  		for (;;) {
> -			name = getstr(pp);
> +			name = getdirentname(pp);
>  			if (!name)
>  				break;
>  			if (strcmp(name, "$") == 0)
> 

-- 
Carlos Maiolino
