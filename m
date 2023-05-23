Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A2DC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbjEWRje (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjEWRjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:39:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F8FDD
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D14062C4F
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8341DC4339B;
        Tue, 23 May 2023 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863571;
        bh=9L0BXE3xZEnGAA/elpJ0149wfTApcXaidpJ//giM3uY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aQVTY6lWX0Ru89VWAQa4gkG97M2o5cRxKwTLgU2jmnCY/wNRPujsppprVKxvPoSEY
         3S3RIAxi4sn1ziNugQHsVctnpSrwdfRiHX9ibywyTGCY3P8NFDPRy3wTmDrzem8JQS
         ZxDhmef+54KQhkKT6pUFDX2omNGbUs+U/tgc8tFlpBxek9JyRWwzeZTIVW+491U6tK
         3Oj6mXHc97P4dfoK0+Jnzyvu8HJYoll2PsRjT0NShLVh9WVFid6u4BElPgbd9wGnM2
         r8XPi+T5GPNLQfcGTVDsJEwEXcHmxc+xGTnMf/tO3nnmCrp3XLIgU/vTZ8tRlT7D/O
         XZO2wN47zoqtg==
Date:   Tue, 23 May 2023 10:39:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs_metadump.sh: Add support for passing version
 option
Message-ID: <20230523173930.GT11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-15-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:40PM +0530, Chandan Babu R wrote:
> The new option allows the user to explicitly specify which version of
> metadump to use. However, we will default to using the v1 format.

Needs SOB tag.

--D

> ---
>  db/xfs_metadump.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
> index 9852a5bc2..9e8f86e53 100755
> --- a/db/xfs_metadump.sh
> +++ b/db/xfs_metadump.sh
> @@ -8,7 +8,7 @@ OPTS=" "
>  DBOPTS=" "
>  USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
>  
> -while getopts "aefgl:m:owFV" c
> +while getopts "aefgl:m:owFv:V" c
>  do
>  	case $c in
>  	a)	OPTS=$OPTS"-a ";;
> @@ -20,6 +20,7 @@ do
>  	f)	DBOPTS=$DBOPTS" -f";;
>  	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
>  	F)	DBOPTS=$DBOPTS" -F";;
> +	v)	OPTS=$OPTS"-v "$OPTARG" ";;
>  	V)	xfs_db -p xfs_metadump -V
>  		status=$?
>  		exit $status
> -- 
> 2.39.1
> 
