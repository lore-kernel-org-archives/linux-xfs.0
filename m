Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F07EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49EB723877
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbhANUvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbhANUvu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 15:51:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B4BA2310A;
        Thu, 14 Jan 2021 20:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610657470;
        bh=yxGtVnaC0O7iPzQpsYjPU8Cv0/G3BuXbD7LaXAkfkgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLgGwqXigs/yckQRBvkddS0B1xHzKdGqmgHs/DEYGyJOQnV1LKgPFjtAidnIue9WD
         6yikGVisIn8g2W89BAO9kdLUGpCpDPAbOcKDhAKens/WuU5cix2uWLsvbL4B56gDOU
         yRdAHdmy024xfaUjSNWz8KqztcqYiOK+AkJCNNO11WmfTBiSr6aZkF45RTbHj94zBD
         s5FA96M3yK+bpGMViHTLkA6BunASHB8YBwbUB5Tpi0nLWnBjAuWGtRV8pbVWrMz5Qn
         RBW4KAUNwpSysRWQra1uDMFAtsB4nEp/c7PP8xEepGZ/OGOjM8YTOtb+ezciVUuUkw
         c3QBw69jybbdQ==
Date:   Thu, 14 Jan 2021 12:51:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] debian: use Package-Type over its predecessor
Message-ID: <20210114205109.GD1164246@magnolia>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210114183747.2507-5-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114183747.2507-5-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 07:37:45PM +0100, Bastian Germann wrote:
> The debian/control file contains an XC-Package-Type field.
> As of dpkg-dev 1.15.7, the dpkg development utilities recognize
> Package-Type as an official field name.
> 
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 64e01f93..ceda0241 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -47,7 +47,7 @@ Description: XFS filesystem-specific static libraries and headers
>   for complete details.
>  
>  Package: xfsprogs-udeb
> -XC-Package-Type: udeb
> +Package-Type: udeb
>  Section: debian-installer
>  Architecture: any
>  Depends: ${shlibs:Depends}, ${misc:Depends}
> -- 
> 2.30.0
> 
