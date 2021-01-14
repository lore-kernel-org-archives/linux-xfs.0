Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFA9C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7545923A9D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbhANU5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbhANU5A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 15:57:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606D6238EC;
        Thu, 14 Jan 2021 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610657779;
        bh=yt/Rbp2ghAH9oExHCcvLK5hy3fwtJqv82de7HN1e/5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mZGzpDpy++Wfkdv2Z+AMXNs1H2gawpIiB98bDEAhTNgLy2oJhTEWdxvAGK3RdScAL
         ISVUeoRN6U+SRQj7dLDAMgZTMiZ+vnZpdhqwLe/ID4DwbqQDFYLJrUrrDqCvzdRE9d
         LLJlc+grVILg2UQlrI55mEJBq9ekwcDXWWl59kH0qFBC1WHOuxVjtUxiyTb1Ac8BiL
         HBMxnh6aoB/Vv92EKY/0/1jsBQzVhNSVn4dR8hBBo+t/arDyDBJohpB8MlnPWYimF4
         fFABB7HiCgtqQg7I/BLfjwd1/HINTK0Xi+HeNeTA12fD00Lz+TSlRdNM44GyadHIlX
         nXWOrieWsxEjA==
Date:   Thu, 14 Jan 2021 12:56:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] debian: new changelog entry
Message-ID: <20210114205618.GE1164246@magnolia>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210114183747.2507-7-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114183747.2507-7-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 07:37:47PM +0100, Bastian Germann wrote:
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

FWIW I've been carrying a patch[1] to bump the compat level to 11 so
that the xfs_scrub systemd services can take advantage of
dh_installsystemd.  I /think/ doing so will break builds on Debian
oldstable and oldoldstable and Ubuntu 16.04, but those are now 5+
years old so maybe I should send it for reals?

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=scrub-iscan-rebalance&id=d09bda8abc2c4ebcaedff4f21cbb79c79f572b0a
> ---
>  debian/changelog | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 5d46f0a3..ce4a224d 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,14 @@
> +xfsprogs (5.10.0-2) unstable; urgency=low
> +
> +  * Team upload
> +  * debian: cryptographically verify upstream tarball (Closes: #979644)
> +  * debian: remove dependency on essential util-linux
> +  * debian: remove "Priority: extra"
> +  * debian: use Package-Type over its predecessor
> +  * debian: add missing copyright info (Closes: #979653)
> +
> + -- Bastian Germann <bastiangermann@fishpost.de>  Thu, 14 Jan 2021 18:59:14 +0100
> +
>  xfsprogs (5.10.0-1) unstable; urgency=low
>  
>    * New upstream release
> -- 
> 2.30.0
> 
