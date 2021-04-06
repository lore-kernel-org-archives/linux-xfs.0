Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B42C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB2D61279
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhDFN6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 09:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhDFN6D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Apr 2021 09:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D294F61260;
        Tue,  6 Apr 2021 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617717476;
        bh=XNKCPvVLjfevCpKBQ2M6oMRoqdFkRPO40Gxo3IMIG8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THvHR65gxDphRI9k/Om6s+h1rV5SxGlmXSb+6dh/zIyCzbeHf0RzzD+Sa0h4+2D2m
         70LKvpKOBO+XDVKprzzjqBeM8i2mVCU5nr99evSQzjmPY7S2Pt21hTTC8eyqpumAHY
         AiSajM1AzD25LX4n7+okDOyBrxM9tT+eU5zjmBCGAevV35nTGaoZgvXp7g9a/EbkCk
         S3tgSb/sB7tBBxGB6cnFn9ABSJvqEi7pygi0mnj2GNXX6+3jSFKoOQFoOJTEqskK3W
         yQfP3vloKnI1ko6Q8iXkOoxujona30UYdFz/RdcRI/XfOIjCDUzr7NuwYZLIf4/XVP
         bSAaun12e+2dg==
Date:   Tue, 6 Apr 2021 06:57:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] Add dax mount option to man xfs(5)
Message-ID: <20210406135756.GG3957620@magnolia>
References: <20210406115613.19211-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406115613.19211-1-cmaiolino@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 01:56:12PM +0200, Carlos Maiolino wrote:
> Details are already in kernel's documentation, but make dax mount option
> information accessible through xfs(5) manpage.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Yay!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Changelog:
> 	V2:
> 	 - Add changes suggested by Darrick on his review.
> 
>  man/man5/xfs.5 | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 7642662f..372dc08a 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -133,6 +133,23 @@ by the filesystem.
>  CRC enabled filesystems always use the attr2 format, and so
>  will reject the noattr2 mount option if it is set.
>  .TP
> +.BR dax=value
> +Set CPU direct access (DAX) behavior for the current filesystem. This mount
> +option accepts the following values:
> +
> +"dax=inode" DAX will be enabled only on regular files with FS_XFLAG_DAX applied.
> +
> +"dax=never" DAX will not be enabled for any files. FS_XFLAG_DAX will be ignored.
> +
> +"dax=always" DAX will be enabled for all regular files, regardless of the
> +FS_XFLAG_DAX state.
> +
> +If no option is used when mounting a filesystem stored on a DAX capable device,
> +dax=inode will be used as default.
> +
> +For details regarding DAX behavior in kernel, please refer to kernel's
> +documentation at filesystems/dax.txt
> +.TP
>  .BR discard | nodiscard
>  Enable/disable the issuing of commands to let the block
>  device reclaim space freed by the filesystem.  This is
> -- 
> 2.30.2
> 
