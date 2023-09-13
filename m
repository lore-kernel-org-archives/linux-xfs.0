Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E58EDEC4F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 13:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbjIMNA2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 09:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240680AbjIMNA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 09:00:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5D119BD
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 06:00:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB13C433C9;
        Wed, 13 Sep 2023 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694610023;
        bh=SDnwAgPWPsxHxXczmVQB6dstuqNC5ms1eun5i+lDF0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=evdvCJtNqAsH3Xgm26TJW4aU54gBuXGLI/qtRifiQ9TqIw9DbOrsA/QB+2hX6d2rd
         eJX1rsOVWOl2XcWlN8Wila4JdyE5TWAw5Byd8ga4LYy6hUKSyrw7TWelHeN1bhYFhv
         30wMO01sFf0zcS8AReYge7aQ0T1LpkwPAdKhEsp7jCo95lLCSGQTIjs1oSJbrB2+5R
         Na18Tglk4xDe/ZkEeNjpcdw6wcvtomXaDsExuKcUnAxtjLe3D0f8145askgxMy2PZY
         uaHnydrWLPyddZXSkShZs+9+2ipr+ILSEG/4sk0JpbEjP6XXYE8z22jU+h+NWokM6T
         3zezEltYkfXnQ==
Date:   Wed, 13 Sep 2023 15:00:19 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs_scrub: actually return errno from
 check_xattr_ns_names
Message-ID: <20230913130019.xdmdq576cblttps5@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <ihCtIfcTz4P2cRz_1GFts_rxAyipXLKDnZzKubjmFdPDet1gxhD0ohWByOtKiWFH7z4iKXvUbymCMgvbQSGRrg==@protonmail.internalid>
 <169454759865.3539425.15276862523138913713.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454759865.3539425.15276862523138913713.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Actually return the error code when extended attribute checks fail.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/phase5.c |    1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 1ef234bff68..31405709657 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -202,6 +202,7 @@ check_xattr_ns_names(
>  	if (error) {
>  		if (errno == ESTALE)
>  			errno = 0;
> +		error = errno;
>  		if (errno)
>  			str_errno(ctx, descr_render(dsc));
>  	}
> 
