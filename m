Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2976C61DA4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Feb 2023 12:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjBCMsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Feb 2023 07:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBCMsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2023 07:48:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582D899D7E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 04:48:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F21EB82AB4
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 12:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E567DC433D2;
        Fri,  3 Feb 2023 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675428517;
        bh=L6xDluixblyYgdSOHku6Xv3yFQwWwwV3FqswmOy6GD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZTenxC+JzIuXC7BDE4V/ak+3m3bQFjvFhI3ZKMYkpsK3Twh3vajeU+1PylS7aQH+
         lpQO2SnHmzjWVLcqLhocRSMamb3wnf5B9YKI+kh6uX9iI5nwQ0gYZnwGM2yd3rRqMI
         avKqBoAqqgAaWP7aEJmGwsdZAhVb6EW0kLEapYW7XngFFzmAnbx3HDWgv6JUMPPRe1
         JARvOJ0KJzkgnspNXXMN+jsFQthn0zYZLtFegOLW+xAU3gXkwrrLKfsbOp+AsX1MeY
         rgNv4eljp8iwtfawU/bkqS8uL8xbSyO/FzNS2+qbwmO9I3pfoFSwaRm10Oys601KID
         xSiMTylnL0izQ==
Date:   Fri, 3 Feb 2023 13:48:33 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs_admin: get/set label of mounted filesystem
Message-ID: <20230203124833.jpxggxui6ckfi6qn@andromeda>
References: <20230126003311.7736-1-catherine.hoang@oracle.com>
 <N_uUtA37-NG-A8IuiEoI9bWLMMZx67d9ykbvOXw6ol5OPJ_kBnPXTAUOFZevc0O3R5SSI6lMoZsDzTGulXqVow==@protonmail.internalid>
 <20230126003311.7736-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126003311.7736-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 25, 2023 at 04:33:11PM -0800, Catherine Hoang wrote:
> Adapt this tool to call xfs_io to get/set the label of a mounted filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks good, thanks!
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/xfs_admin.sh | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 3a7f44ea..cc650c42 100755
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
> --
> 2.34.1
> 

-- 
Carlos Maiolino
