Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07808EDEC4D
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 13:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjIMNWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 09:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjIMNWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 09:22:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CACA19B1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 06:22:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFACC433C7;
        Wed, 13 Sep 2023 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694611330;
        bh=JfkkNsuAiRNa4cxX4Dg/XdNG5+mkhmaICnpUvuk+jRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V55uvF7cv1cO3EdG8tyqiT/C9iNGyct4DZfZzgqLM5y3M1sCIA2BwdXfld8zNperH
         MswKI0lIGzqT16crDQW38ZkWTbJ4eZzdRLYVJl+52hDF9oblPhvTQVRV4hmgFn6Hcn
         xRX3XO+blpSNnRQHR3ml8Dy7DKoo5K5snk97818EtK12xqn2i5Qnd0ivcDECeGi9hD
         gJbsGZQA6PLAzm1JzE1tyB1M/4Tm1w+tiknSfzuoCdVkz1Tzwx7kXP9av9H9fQj8vy
         pRwqFCvJcQnDU6HKh0EYcKPCn1kHCY2sfSWaUS9dwHDKc8zYobpYT20Bz8zyK1dOfR
         iSQIIamJXOc8A==
Date:   Wed, 13 Sep 2023 15:22:06 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 6/6] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
Message-ID: <20230913132206.3ixylu3qc5wgtpyt@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <169454761010.3539425.13599600178844641233.stgit@frogsfrogsfrogs>
 <ub8kRv81g-HpbM3_wrwF0n1yJgSTxGCDW2TMp03cXXpwUZJKxqNkjYscvho3WpTodI-grFYtPtvGS05-moG1PQ==@protonmail.internalid>
 <20230912194751.GB3415652@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912194751.GB3415652@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:47:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
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
> Fix this by requiring that unsigned longs are at least 64 bits in size,
> which /usually/ means that 64-bit atomic counters are supported.  We
> can't simply execute the liburcu atomic64_t detection code during
> configure instead of only relying on the linker error because that
> doesn't work for cross-compiled packages.
> 
> Fixes: 7448af588a2e ("libxfs: fix atomic64_t poorly for 32-bit architectures")
> Reported-by: Anthony Iliopoulos <ailiop@suse.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> v1.1: This time with correct commit message.
> ---
>  m4/package_urcu.m4 |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> index ef116e0cda7..4bb2b886f06 100644
> --- a/m4/package_urcu.m4
> +++ b/m4/package_urcu.m4
> @@ -26,7 +26,11 @@ rcu_init();
>  #
>  # Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
>  # error on _uatomic_link_error, which is how liburcu signals that it doesn't
> -# support atomic operations on 64-bit data types.
> +# support atomic operations on 64-bit data types for its generic
> +# implementation (which relies on compiler builtins). For certain archs
> +# where liburcu carries its own implementation (such as x86_32), it
> +# signals lack of support during runtime by emitting an illegal
> +# instruction, so we also need to check CAA_BITS_PER_LONG to detect that.
>  #
>  AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
>    [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
> @@ -34,8 +38,11 @@ AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
>      [	AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <urcu.h>
> +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  	]], [[
>  long long f = 3;
> +
> +BUILD_BUG_ON(CAA_BITS_PER_LONG < 64);
>  uatomic_inc(&f);
>  	]])
>      ], have_liburcu_atomic64=yes
