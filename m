Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B21CEEAA5D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 18:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbjINS1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239368AbjINS1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 14:27:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC1E21BE5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694716004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WzxwnhcGtEZiX2sPyKVzRm6582v3BkqCcS4vaj+BKjE=;
        b=Go3wMkceUdBGaMWklkzuSdxy98xOYugitTvE+zCYZdM1M9upDD00YHzyLKyFfX45v0+PMt
        E6PLwNk4Vkcur39ZWwef6TlSGi51UxPvQvP30qzaw7ZBjyfdW8R82fT4hpeahdrgRJnTKr
        ZFYwR2N2GdCP8n7yhXZ4aQS+u7nyTFw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-5bEk2E-mPpiXC6162nmi3g-1; Thu, 14 Sep 2023 14:26:39 -0400
X-MC-Unique: 5bEk2E-mPpiXC6162nmi3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C356681B196;
        Thu, 14 Sep 2023 18:26:38 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8148E21B2413;
        Thu, 14 Sep 2023 18:26:38 +0000 (UTC)
Date:   Thu, 14 Sep 2023 13:26:37 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 6/6] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
Message-ID: <ZQNQXQrSdLWpvlLn@redhat.com>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <169454761010.3539425.13599600178844641233.stgit@frogsfrogsfrogs>
 <20230912194751.GB3415652@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912194751.GB3415652@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

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
> 

