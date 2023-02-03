Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA20C61DA4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Feb 2023 12:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjBCMoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Feb 2023 07:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBCMof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2023 07:44:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD4E9AFEA
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 04:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B8AF61F1A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2023 12:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2477C4339B;
        Fri,  3 Feb 2023 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675428273;
        bh=zGUzCJPL+Evp5Vo/taiagXYEGUV060cCVxSXN6W14Bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHNGashRrNgF0w64Ad02s/fAZtPw0QVc5182ilYTi1cQtAKOJkrobpOF08zcju0+R
         m84dbm0KG+kr5Uo8cvo8RwiZ0EWMXrAXEOiMInAFdeo73ziaV3mUkd5wKnteisIWKF
         JCwL+nIFUVxHSAJPVE4AsCUYnkC61Mqu5tsAIEPQ5xUFJfYsQWHKB/48ClelVUYQww
         IZXuQW8Cwsjhp9L36Z/vbzQhw+7DVL8QWbCqKyzvEBXJ+nm7arfUoXX1GEmouP3Rev
         /ZynMfblCYGGnIZ3oK5e5EYfNcwYeG6JLYOQS2CrDyOSZpgLff88yIyfDdmhoVBH5L
         f1mnFuNG+F9jw==
Date:   Fri, 3 Feb 2023 13:44:29 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs_admin: correctly parse IO_OPTS parameters
Message-ID: <20230203124429.nzinzylbrorrj7nx@andromeda>
References: <20230126003311.7736-1-catherine.hoang@oracle.com>
 <QyBbOMOz_fVic4M9qi-bl4mjMCiYt-qLR7OtOgDzsaqdPtRy0SezgLV2hIe3gN4GyzE25yvzSqFoEQMkrJVUoA==@protonmail.internalid>
 <20230126003311.7736-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126003311.7736-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 25, 2023 at 04:33:10PM -0800, Catherine Hoang wrote:
> Change exec to eval so that the IO_OPTS parameters are parsed correctly
> when the parameters contain quotations.
> 
> Fixes: e7cd89b2da72 ("xfs_admin: get UUID of mounted filesystem")
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks good, thanks Catherine..

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/xfs_admin.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index b73fb3ad..3a7f44ea 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -69,7 +69,8 @@ case $# in
>  			fi
> 
>  			if [ -n "$IO_OPTS" ]; then
> -				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
> +				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
> +				exit $?
>  			fi
>  		fi
> 
> --
> 2.34.1
> 

-- 
Carlos Maiolino
