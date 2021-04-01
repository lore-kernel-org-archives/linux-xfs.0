Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70946C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 18:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 451F061165
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 18:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhDASLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236817AbhDASDB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Apr 2021 14:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D452A61359;
        Thu,  1 Apr 2021 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617291213;
        bh=kGHDJioiCc9Fs272P6aEXWiCFsRtQE+nv4E9MqSyWyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MP7ZM31pqtzwOn7DFGQmZAcHMxpJFOGWny3aTveKgcJUNytanosGWHSnC0pJOmcJb
         xrfg2N3ThrIkhXxkgSPk3K0HBGKwBTMFNn7Qe4rp25Htpl3p4OKaOIa4fdxlV2als2
         Nf8OmsXTS7XuYTi3Ff5WuV7EuEau16f2sqb/8/HbwwFh3u47yiLuBB3sEPdlmWOJB8
         t+lKGwfib/d/Sa+BErC/OrQp8xo5QrFmw1uznFw0G3mQiYF3vHWTRHJqdK7LDUBYG1
         ExdSoA2+SUc2OmFXkBcckKaKEfZTWnRevmPlZoOvsMRjyAca1mt0RtoXLvvJ3AmXd1
         V6JfIvTgz6DNg==
Date:   Thu, 1 Apr 2021 08:33:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Add dax mount option to man xfs(5)
Message-ID: <20210401153333.GD4090233@magnolia>
References: <20210315150250.11870-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315150250.11870-1-cmaiolino@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 04:02:50PM +0100, Carlos Maiolino wrote:
> Details are already in kernel's documentation, but make dax mount option
> information accessible through xfs(5) manpage.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  man/man5/xfs.5 | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 7642662f..46b0558a 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -133,6 +133,24 @@ by the filesystem.
>  CRC enabled filesystems always use the attr2 format, and so
>  will reject the noattr2 mount option if it is set.
>  .TP
> +.BR dax=value
> +Set DAX behavior for the current filesystem. This mount option accepts the

It might be worth defining what DAX (the acronym) is...

"Set CPU direct access (DAX) behavior for regular files in the
filesystem."

> +following values:
> +
> +"dax=inode" DAX will be enabled only on files with FS_XFLAG_DAX applied.

"...enabled on regular files..."

> +
> +"dax=never" DAX will be disabled by the whole filesystem including files with
> +FS_XFLAG_DAX applied"

"DAX will not be enabled for any files.  FS_XFLAG_DAX will be ignored."

> +
> +"dax=always" DAX will be enabled to every file in the filesystem inclduing files

"DAX will be enabled for all regular files, regardless of the
FS_XFLAG_DAX state."

> +without FS_XFLAG_DAX applied"
> +
> +If no option is used when mounting a pmem device, dax=inode will be used as

"If no option is used when mounting a filesystem stored on a device
capable of DAX access modes, dax=inode...."

(DAX is a possibility with more than just persistent memory now...)

--D

> +default.
> +
> +For details regarding DAX behavior in kernel, please refer to kernel's
> +documentation at filesystems/dax.txt
> +.TP
>  .BR discard | nodiscard
>  Enable/disable the issuing of commands to let the block
>  device reclaim space freed by the filesystem.  This is
> -- 
> 2.29.2
> 
