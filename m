Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4270C07E9D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 18:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJDS2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJDS2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 14:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22335467F
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 11:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED516141C
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 18:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFE6C433C1;
        Tue,  4 Oct 2022 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664908102;
        bh=OWjwiCmezqshfIfQeqCn0jP0fV3cQDlMZb/Xj1158QA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FFTg1Gz6v93kfJE8FP/sPpaiU3+X8o9rFp8svmQMfZn/McyOWXckopZPKBXp9QZ5s
         QY8rBVA4wCb07I3MZneN1W2qkibYmWJtRbEHQMRkKacRgVTbHaG/igYaRS80muQdOT
         PIE31RTidvVjT95IByWU2nl5Yt54Lh5r6Ld97cYPA2gV5srGvPKQWZ34Ly5+XhWYwm
         H7pFI1zVLB2D0fNzJ1FgT9mNr67qZp0Yq6tga9cdjersdHN8s4L9V6O/xxuRIYKmUd
         QcxVScvnmC/yjyyt9l9/qHe11NvhS1YpbDch3S2KIjBEOEZIerESKSyFeM/Jd4wtWB
         Jpvx6rdKV9ULA==
Date:   Tue, 4 Oct 2022 11:28:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: fix warnings/errors due to missing include
Message-ID: <Yzx7RrC1v2LQ6wSf@magnolia>
References: <865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 04, 2022 at 08:11:05PM +0200, Holger Hoffstätte wrote:
> 
> Gentoo is currently trying to rebuild the world with clang-16, uncovering exciting
> new errors in many packages since several warnings have been turned into errors,
> among them missing prototypes, as documented at:
> https://discourse.llvm.org/t/clang-16-notice-of-potentially-breaking-changes/65562
> 
> xfsprogs came up, with details at https://bugs.gentoo.org/875050.
> 
> The problem was easy to find: a missing include for the u_init/u_cleanup
> prototypes. The error:
> 
> Building scrub
>     [CC]     unicrash.o
> unicrash.c:746:2: error: call to undeclared function 'u_init'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>         u_init(&uerr);
>         ^
> unicrash.c:746:2: note: did you mean 'u_digit'?
> /usr/include/unicode/uchar.h:4073:1: note: 'u_digit' declared here
> u_digit(UChar32 ch, int8_t radix);
> ^
> unicrash.c:754:2: error: call to undeclared function 'u_cleanup'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>         u_cleanup();
>         ^
> 2 errors generated.
> 
> The complaint is valid and the fix is easy enough: just add the missing include.
> 
> Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Aha, that explains why I kept hearing reports about this but could never
get gcc to spit out this error.  Thanks for fixing this.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> -- xfsprogs-5.18.0/scrub/unicrash.c	2021-12-13 21:02:19.000000000 +0100
> +++ xfsprogs-5.18.0-nowarn/scrub/unicrash.c	2022-10-04 19:46:28.869402900 +0200
> @@ -10,6 +10,7 @@
>  #include <sys/types.h>
>  #include <sys/statvfs.h>
>  #include <strings.h>
> +#include <unicode/uclean.h>
>  #include <unicode/ustring.h>
>  #include <unicode/unorm2.h>
>  #include <unicode/uspoof.h>
> 
