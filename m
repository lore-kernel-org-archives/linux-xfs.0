Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27BDC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A341122CBE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbhANUs4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbhANUs4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 15:48:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22CB221FF;
        Thu, 14 Jan 2021 20:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610657295;
        bh=UEFidhb5Ayyy3n6dBVnc/bh7byI/2UpgsD0S4eqVteU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N3vXu6OF5V03L2YIbXaE0kGm3UlSGyE4QpW8xIp85L2v5fBnAI1Q5Gdywk+ziYA2e
         q7Hnt9MGy+o+kU5wDlhXaqqZyImVtO8dcMaLQIw/AWqArYs5wWh/LXFI/0bhNogJ1e
         P0vEvhukv7c1kGfAL5MDjq4L86Ti70tUkiwfVptRSXhfHuFj4MivyCUD+Txh2PUjvC
         lfY5sI4SE9ApTc8OaIhso0iDaipcXZIZsXgQ9/foAHZiIepD6KtWckNxcsQgIW5WhR
         KZeRCkyibRyXDLZjQMkGxzPXpYdU2ywje0ArHBMYzmfOYkLSaaBQfHzfgM7arPPorm
         T2ACr6Pu8/7dg==
Date:   Thu, 14 Jan 2021 12:48:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] debian: remove dependency on essential util-linux
Message-ID: <20210114204815.GB1164246@magnolia>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210114183747.2507-3-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114183747.2507-3-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 07:37:43PM +0100, Bastian Germann wrote:
> Essential packages must not be part of Depends.
> 
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

/me wonders what section of the debian packaging manuals say that, but
Lintian certain complains about the unversioned dependency and I guess
we should get ourselves off the bad list[1].  IOWs, good enough for me.
:)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

[1] https://lintian.debian.org/tags/depends-on-essential-package-without-using-version.html

--D

> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 49ffd340..34dce4d5 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -8,7 +8,7 @@ Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
>  Package: xfsprogs
> -Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any, util-linux
> +Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any
>  Provides: fsck-backend
>  Suggests: xfsdump, acl, attr, quota
>  Breaks: xfsdump (<< 3.0.0)
> -- 
> 2.30.0
> 
