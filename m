Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1D7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 18:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDBA61350
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 18:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhJDSUU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Oct 2021 14:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233716AbhJDSUT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Oct 2021 14:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B7F61164;
        Mon,  4 Oct 2021 18:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633371510;
        bh=P0vyfewWCTBP4ZJ5QIRAPmd6kPMMKX+R5d+mmGqdTFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lEOyRAMp6ixQ3rCbxWETX2/mZSvthQT7b0WgkeNLdBm6DMx63Apao8Ts8yCL9x1bn
         YjNko3fkNyC8Px5aW7ewW7yzCd2GuRDhucjZOjppn31KlO2UJzxaB4UXuC28N1ibVP
         tq/p6wZ08z7ZNTv3njjv4tI2OsCZHCxtlNz8yeFqq/OqTbhjrQ3dRj1v5KTjIFJ4nf
         StN56UFM34EDI7sNQBfVrhDXENvP1b9elBKkyelVgIHi6KrOsy3+7ptUDG87nQ6teP
         MRB1igyEl1OL4/Jv7L3dk1VxpQIa5cOb9AWLh+Wxj5BGAv8DB93oOq484avm95B1C1
         H9i1FuHbyIeBw==
Date:   Mon, 4 Oct 2021 11:18:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org, Bastian Germann <bage@debian.org>
Subject: Re: [PATCH 1/3] debian: Update Uploaders list
Message-ID: <20211004181830.GB24307@magnolia>
References: <20210928002552.10517-1-bage@debian.org>
 <20210928002552.10517-2-bage@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928002552.10517-2-bage@debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 28, 2021 at 02:25:50AM +0200, Bastian Germann wrote:
> Set Bastian's debian.org email address.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index e4ec897c..57131bb4 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -2,7 +2,7 @@ Source: xfsprogs
>  Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
> -Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
> +Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
>  Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
> -- 
> 2.33.0
> 
