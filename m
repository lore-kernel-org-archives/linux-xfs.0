Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AF8EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jul 2023 22:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjG1WdM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjG1WdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2023 18:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0AB136
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 15:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7266220D
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 22:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E33C433C8;
        Fri, 28 Jul 2023 22:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690583590;
        bh=AI5J+CjWYZUtHNpMiBsJLUoY1YbDIYRnPU/xDg/dTuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=As7p0CR+QSjmpqTgyjHuQBnazMiJDyRfNjD0AwjAEEwEn9u2mwHmlF5NnJg5cfEH7
         NchYNxicYj/LCHSoMmJJ/9lSeR1W2gy0OV64p7UNGDnV69Zlglp3oo5TWyIxaW5i5T
         c8RvqHpRgPwwV0HpAplDtzU5posPmjFL7076dtwtiKC3j7heiBTFqRKnh7xfjjxQvy
         Cf5b1HsEnq33oXknlLXS7btCFMy+2/G+vHVn0ax8vit4MBOWpVZO+tktKkVrxZPuvN
         KZcUurg41aNPUTzPHiMoHOvhrFgb5cdp8x+4kau1yyXShTA/PYDkh3HJK7jigtSW6p
         Sd4rPk3ZYNiYg==
Date:   Fri, 28 Jul 2023 15:33:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bill O'Donnell <bodonnel@redhat.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] mkfs.xfs.8: correction on mkfs.xfs manpage since reflink
 and dax are compatible
Message-ID: <20230728223309.GH11352@frogsfrogsfrogs>
References: <20230728222017.178599-1-bodonnel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728222017.178599-1-bodonnel@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 28, 2023 at 05:20:17PM -0500, Bill O'Donnell wrote:
> Merged early in 2023: Commit 480017957d638 xfs: remove restrictions for fsdax
> and reflink. There needs to be a corresponding change to the mkfs.xfs manpage
> to remove the incompatiblity statement.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  man/man8/mkfs.xfs.8.in | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index ce6f1e2d..08bb92f6 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -323,13 +323,6 @@ option set. When the option
>  .B \-m crc=0
>  is used, the reference count btree feature is not supported and reflink is
>  disabled.
> -.IP
> -Note: the filesystem DAX mount option (
> -.B \-o dax
> -) is incompatible with
> -reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
> -.B \-m reflink=0
> -option to mkfs.xfs to disable the reflink feature.

D'oh, we forgot to remove that.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  .RE
>  .PP
>  .PD 0
> -- 
> 2.41.0
> 
