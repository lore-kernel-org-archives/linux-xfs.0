Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD071CA0FE2
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 17:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbjIERTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 13:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353488AbjIERNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 13:13:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B0B30F3
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 09:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4360460A54
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 16:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26CBC433C8;
        Tue,  5 Sep 2023 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693932170;
        bh=btj3Z3ijdJyE48oomLKulblGMPvbu4l9GJtQ08N0lbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SGi0ZDwq8zIkgcJPJDrRfXlmOy7N2e7oiS3xCUINLZcwvC25jPIzHUoGtzmRCOlPF
         3dpNBo0MNEP2a53fMBuZDmKAfWiBfHj1YqNmcjyvtCEyOsOKGSUmdngiGkI7pV8Eie
         nRUOtN86KuGDnku78rje4uO/hQ+kl3lnL5taXTTN+rbhOywF4Zoy15yW/6M3IN1rFY
         ngMj6rmugAzH9vfj4L8PHBGDkCchpxLi7AqZngWuSjgQuQJ7LBdDrAtGgoRh0KELsT
         tcI4gHVCYi7yFSHcwlHYD1BT0sZE5JdLI644e9sh6VtBDzXlBnuiZdpE2+KXP6dK6o
         5Sy4cMMCd7jVQ==
Date:   Tue, 5 Sep 2023 09:42:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
Message-ID: <20230905164250.GV28186@frogsfrogsfrogs>
References: <20230905084623.24865-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905084623.24865-1-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 05, 2023 at 10:46:23AM +0200, Anthony Iliopoulos wrote:
> xfsprogs during compilation tries to detect if liburcu supports atomic
> 64-bit ops on the platform it is being compiled on, and if not it falls
> back to using pthread mutex locks.
> 
> The detection logic for that fallback relies on _uatomic_link_error()
> which is a link-time trick used by liburcu that will cause compilation
> errors on archs that lack the required support. That only works for the
> generic liburcu code though, and it is not implemented for the
> x86-specific code.
> 
> In practice this means that when xfsprogs is compiled on 32-bit x86
> archs will successfully link to liburcu for atomic ops, but liburcu does
> not support atomic64_t on those archs. It indicates this during runtime
> by generating an illegal instruction that aborts execution, and thus
> causes various xfsprogs utils to be segfaulting.
> 
> Fix this by executing the liburcu atomic64_t detection code during
> configure instead of only relying on the linker error, so that
> compilation will properly fall back to pthread mutexes on those archs.
> 
> Fixes: 7448af588a2e ("libxfs: fix atomic64_t poorly for 32-bit architectures")
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
>  m4/package_urcu.m4 | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> index ef116e0cda76..f26494a69718 100644
> --- a/m4/package_urcu.m4
> +++ b/m4/package_urcu.m4
> @@ -26,11 +26,15 @@ rcu_init();
>  #
>  # Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
>  # error on _uatomic_link_error, which is how liburcu signals that it doesn't
> -# support atomic operations on 64-bit data types.
> +# support atomic operations on 64-bit data types for its generic
> +# implementation (which relies on compiler builtins). For certain archs
> +# where liburcu carries its own implementation (such as x86_32), it
> +# signals lack of support during runtime by emitting an illegal
> +# instruction, so we also need to execute here to detect that.
>  #
>  AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
>    [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
> -    AC_LINK_IFELSE(
> +    AC_RUN_IFELSE(

Unfortunately, this change breaks cross compiling:

checking for umode_t... no
checking for atomic64_t support in liburcu... configure: error: in
	`.../xfsprogs/build-aarch64':
configure: error: cannot run test program while cross compiling
See `config.log' for more details

(Note that this is an x64 host building aarch64)

Seeing as we /do/ have a (slow) workaround for 32-bit machines, perhaps
we should use it any time a long isn't 64-bits wide:

diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
index ef116e0cda7..2ad4179aca2 100644
--- a/m4/package_urcu.m4
+++ b/m4/package_urcu.m4
@@ -34,8 +34,11 @@ AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
     [  AC_LANG_PROGRAM([[
 #define _GNU_SOURCE
 #include <urcu.h>
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
        ]], [[
 long long f = 3;
+
+BUILD_BUG_ON(CAA_BITS_PER_LONG < 64);
 uatomic_inc(&f);
        ]])
     ], have_liburcu_atomic64=yes

This will cause suboptimal performance on any 32-bit cpu that /does/
support atomic operations on a u64, but oh well.

--D

>      [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <urcu.h>
> -- 
> 2.42.0
> 
