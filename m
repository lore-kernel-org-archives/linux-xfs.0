Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3753C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 16:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF3D61B3E
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 16:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhKOQ5r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 11:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhKOQ5j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Nov 2021 11:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A62E761B3E;
        Mon, 15 Nov 2021 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636995275;
        bh=95PrJVf0aDXk3Dv/alUTEDCHc36NzTsG7yoeoonAlrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ljUl9ftG8SHkJ0qnC8iPAVqdJZltPvl7/W17QZJ/bYSsvGUoroP69zn9ddcoVCPxF
         rWGsWtCnZ6nooPAsC8Z6HHO1BeNvJPp/KoIVAkUlHIh4gI2EGwBx4PmQ3VDqTRWYik
         JNlBFnqwJTcR04PEY+StTlt1d4fVHWtX+sL/SgKkwfsAqWuTuW0pWyuPGoJD8fHvY+
         UPjfF9we4jNz/kWt362Pc1KOxL7y9LP8xDVIhV/lmuTGT64fk4Ok2LA11H+szExsvH
         ArXRZz5G2GJ5gVXPBw4hy4Nd8hPJBl8HSEQmJ9S8H3Q4tXVXcxwKppIn5c+cYW756q
         ZOCdBwse00Omw==
Date:   Mon, 15 Nov 2021 08:54:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bage@debian.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] debian: Add changelog entry for 5.14.0-rc1-1
Message-ID: <20211115165435.GH24307@magnolia>
References: <20211114224339.20246-1-bage@debian.org>
 <20211114224339.20246-5-bage@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211114224339.20246-5-bage@debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 14, 2021 at 11:43:39PM +0100, Bastian Germann wrote:
> This holds all package changes since v5.13.0.
> Add Closes tags that will autoclose related bugs.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>

Thanks for cleaning up all FT*BFS problems!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/changelog | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 4f09e2ca..48a5ffa8 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,18 @@
> +xfsprogs (5.14.0-rc1-1) unstable; urgency=medium
> +
> +  [ Dave Chinner ]
> +  * New build dependency: liburcu-dev
> +
> +  [ Helmut Grohne ]
> +  * Fix FTCBFS (Closes: #794158)
> +    + Pass --build and --host to configure
> +
> +  [ Boian Bonev ]
> +  * Fix FTBFS (Closes: #997656)
> +    + Keep custom install-sh after autogen
> +
> + -- Bastian Germann <bage@debian.org>  Sun, 14 Nov 2021 23:18:22 +0100
> +
>  xfsprogs (5.13.0-1) unstable; urgency=medium
>  
>    * New upstream release
> -- 
> 2.33.1
> 
> 
