Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58559C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D0322CBE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 20:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbhANUte (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbhANUte (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 15:49:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E81AE22A84;
        Thu, 14 Jan 2021 20:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610657334;
        bh=ZW5rOiofadz0EErSCWAw4F+1I/XgCpkHSF7UxI1Jd8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1ZxyWHsWSRYrlnXbW/57QYy6ZG1DnOSobPu2no4BvCpvLIf1+n5xsGYpgSewoM8C
         snswefQ7z6ThOptYtbLDqeTjhZFH2VQHdJ9eZkgCbblvcVhZZK194Q0SN8unD1eOKn
         YhixHhFdMiJT0j7h3lneOFY173c0V9ACbB2WvVrHSlTpw2drl/ODpR8zJ8x+hkeZ7v
         GKXxZuqAVkto5mf1Lp8Ltu28DP1jlAwmKb1JdQXcS/UAhMOihBr1boEMWPPr2jfU9V
         VQSaSqm1vaYsJGBIvrHrc4WojdgwXT4rbCbEC40iB/NictnForHacY0XwbtsFpOrzN
         2wexAlBM0ckpA==
Date:   Thu, 14 Jan 2021 12:48:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] debian: remove "Priority: extra"
Message-ID: <20210114204853.GC1164246@magnolia>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210114183747.2507-4-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114183747.2507-4-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 07:37:44PM +0100, Bastian Germann wrote:
> Priority "extra" was replaced by "optional" which is already used by the
> package in general. There is one Priority extra left, so remove it.
> 
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/control | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 34dce4d5..64e01f93 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -29,7 +29,6 @@ Description: Utilities for managing the XFS filesystem
>  
>  Package: xfslibs-dev
>  Section: libdevel
> -Priority: extra
>  Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
>  Breaks: xfsprogs (<< 3.0.0)
>  Architecture: any
> -- 
> 2.30.0
> 
