Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16F6EE14A8
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Sep 2023 15:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242443AbjIFPUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Sep 2023 11:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242441AbjIFPT7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2023 11:19:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786241717
        for <linux-xfs@vger.kernel.org>; Wed,  6 Sep 2023 08:19:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 34FF322430;
        Wed,  6 Sep 2023 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694013593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tJZEAiR0QsymgjBhF1Qm86Umi96cI7YPNL5miQ+w2Rg=;
        b=LkH398Ihug0qRpiC15f7pKPbm7AbtAEzDLf1EX2pI6Hl4tfwx4a5hY/ApvLKXVJ/vvHhyo
        2/KQK6EiMZx0xHqeFrngiu2DmQgPFngr/Xi0m1b9to3cA6Uh5jd7vxkBwwx1G4MkXVjavc
        TMa8ZnvdnIaHYKdEcKKyK95EzaOYpQo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E7A161333E;
        Wed,  6 Sep 2023 15:19:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D3ExNZiY+GRCXQAAMHmgww
        (envelope-from <ailiop@suse.com>); Wed, 06 Sep 2023 15:19:52 +0000
Date:   Wed, 6 Sep 2023 17:19:52 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
Message-ID: <ZPiYmHsqEV45DUzY@technoir>
References: <20230905084623.24865-1-ailiop@suse.com>
 <20230905164250.GV28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905164250.GV28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 05, 2023 at 09:42:50AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 05, 2023 at 10:46:23AM +0200, Anthony Iliopoulos wrote:
> > xfsprogs during compilation tries to detect if liburcu supports atomic
> > 64-bit ops on the platform it is being compiled on, and if not it falls
> > back to using pthread mutex locks.
> > 
> > The detection logic for that fallback relies on _uatomic_link_error()
> > which is a link-time trick used by liburcu that will cause compilation
> > errors on archs that lack the required support. That only works for the
> > generic liburcu code though, and it is not implemented for the
> > x86-specific code.
> > 
> > In practice this means that when xfsprogs is compiled on 32-bit x86
> > archs will successfully link to liburcu for atomic ops, but liburcu does
> > not support atomic64_t on those archs. It indicates this during runtime
> > by generating an illegal instruction that aborts execution, and thus
> > causes various xfsprogs utils to be segfaulting.
> > 
> > Fix this by executing the liburcu atomic64_t detection code during
> > configure instead of only relying on the linker error, so that
> > compilation will properly fall back to pthread mutexes on those archs.
> > 
> > Fixes: 7448af588a2e ("libxfs: fix atomic64_t poorly for 32-bit architectures")
> > 
> > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> > ---
> >  m4/package_urcu.m4 | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> > index ef116e0cda76..f26494a69718 100644
> > --- a/m4/package_urcu.m4
> > +++ b/m4/package_urcu.m4
> > @@ -26,11 +26,15 @@ rcu_init();
> >  #
> >  # Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
> >  # error on _uatomic_link_error, which is how liburcu signals that it doesn't
> > -# support atomic operations on 64-bit data types.
> > +# support atomic operations on 64-bit data types for its generic
> > +# implementation (which relies on compiler builtins). For certain archs
> > +# where liburcu carries its own implementation (such as x86_32), it
> > +# signals lack of support during runtime by emitting an illegal
> > +# instruction, so we also need to execute here to detect that.
> >  #
> >  AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
> >    [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
> > -    AC_LINK_IFELSE(
> > +    AC_RUN_IFELSE(
> 
> Unfortunately, this change breaks cross compiling:

Of course.. I completely forgot about that.

> checking for umode_t... no
> checking for atomic64_t support in liburcu... configure: error: in
> 	`.../xfsprogs/build-aarch64':
> configure: error: cannot run test program while cross compiling
> See `config.log' for more details
> 
> (Note that this is an x64 host building aarch64)
> 
> Seeing as we /do/ have a (slow) workaround for 32-bit machines, perhaps
> we should use it any time a long isn't 64-bits wide:
> 
> diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> index ef116e0cda7..2ad4179aca2 100644
> --- a/m4/package_urcu.m4
> +++ b/m4/package_urcu.m4
> @@ -34,8 +34,11 @@ AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
>      [  AC_LANG_PROGRAM([[
>  #define _GNU_SOURCE
>  #include <urcu.h>
> +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>         ]], [[
>  long long f = 3;
> +
> +BUILD_BUG_ON(CAA_BITS_PER_LONG < 64);
>  uatomic_inc(&f);
>         ]])
>      ], have_liburcu_atomic64=yes
> 
> This will cause suboptimal performance on any 32-bit cpu that /does/
> support atomic operations on a u64, but oh well.

I am not sure there is atomic u64 liburcu support for any 32-bit cpu
(even if that cpu does actually support it). Everything is fenced behind
the same conditional (#if CAA_BITS_PER_LONG == 64) in urcu headers
already (e.g. ppc.h or pretty much anything else that falls back to
uatomic/generic.h). So your patch may be the best way forward.

Honestly I am not sure why this isn't implemented at least for x86 (e.g.
via cmpxchg8b). There's a configure option enable-compiler-atomic-builtins
that makes this work, but it doesn't seem to be enabled in distros
(looks fairly new, liburcu commit 3afcf5a0407c).

Regards,
Anthony
