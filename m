Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C33C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 03:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjARDyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 22:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjARDyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 22:54:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C9D53B11
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 19:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC321B81B07
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 03:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C35DC433D2;
        Wed, 18 Jan 2023 03:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674014061;
        bh=toa565IExT2w1NPXAeMA9VdIXMqyIK2ujtetHVwgxpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gv/i84oy7d2HBLF/3FCp3SqKdHdWnKd38G3Giie78W/xMo0wVgMBiuSLpUsADjm+e
         ozuxfayIO/wkmdH1xrQAfQ3UEdezKebpK9AzOzV4dbDUo2IpHEoksGH1OZUNdHXUoB
         Gg92trXhNCQUJOiRcL5Qbt2ntRZ0LsGs/cuY1S5F4j+3vHpPMFRNjQ6i6cCaWKvAwE
         +5ZjCQrgsxlXv7tkYJKYE3yCnTB+uCo/4DyEVujZ+65DN3OVXNp19GgK+midPrbWOA
         t3Bay/zNNy5H+0AciPfDPIMvYDYB0PqMrNAGJs1MMFgw056jF8dwF7vr8oQXoNHd0M
         44erxqAGMMuwQ==
Date:   Tue, 17 Jan 2023 19:54:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Message-ID: <Y8dtbCouIPhNT1Zw@magnolia>
References: <20230117223743.71899-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117223743.71899-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 02:37:43PM -0800, Catherine Hoang wrote:
> Adapt this tool to call xfs_io to get/set the label of a mounted filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  db/xfs_admin.sh | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index b73fb3ad..cc650c42 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -29,9 +29,11 @@ do
>  	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
>  		require_offline=1
>  		;;
> -	l)	DB_OPTS=$DB_OPTS" -r -c label";;
> +	l)	DB_OPTS=$DB_OPTS" -r -c label"
> +		IO_OPTS=$IO_OPTS" -r -c label"
> +		;;
>  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
> -		require_offline=1
> +		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
>  		;;
>  	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
>  		require_offline=1
> @@ -69,7 +71,8 @@ case $# in
>  			fi
>  
>  			if [ -n "$IO_OPTS" ]; then
> -				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
> +				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
> +				exit $?

I'm curious, why did this change from exec to eval+exit?

Otherwise, this looks good to me.

--D

>  			fi
>  		fi
>  
> -- 
> 2.25.1
> 
