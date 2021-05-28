Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC59C47089
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C44A613C9
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE1Aga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhE1Ag2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 20:36:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FF6561009;
        Fri, 28 May 2021 00:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622162095;
        bh=u521y9Dn4EjCIPrDU4D5uqqyIIZhFY+Q4oQG1+EkBLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jIjWj0lfpx9kixZniklLqkQcmSD9jF72+NGEKIsr/r09ity1Vabmlmp8PIG6DoUD5
         ot9Y939GEBUwuX/X5eOHS2Eb21Kbil0kxtYaDBQxHjrXQa2hn3OCt3fBgyY56mKb5+
         JhmqP13mXUFC+ihUtaIatwFcRKAUMeOUGgiFGlbTwmeyqU9cISYo6Wei9lAQo2MSrX
         +e/QcMMR1p3xrcUFOTwSRiByhakMalIpsCwkpfOwofTDgumENZqmtIZyZcAtyP2zDg
         0e/P/H3irU0R0tVc5bzwtLwW/Weu7sK7Pupq2QVFNkeHzq+rLPlDNnwB2WaNwDtU6d
         Hlze69uyD9ZBQ==
Date:   Thu, 27 May 2021 17:34:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
Message-ID: <20210528003454.GN2402049@locust>
References: <20210420230652.GA70650@embeddedor>
 <20210420233850.GQ3122264@magnolia>
 <62895e8c-800d-fa7b-15f6-480179d552be@embeddedor.com>
 <bcae9d46-644c-d6f6-3df5-e8f7c50a673d@embeddedor.com>
 <20210526211624.GB202121@locust>
 <202105271358.22E0E2BFD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202105271358.22E0E2BFD@keescook>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 02:31:12PM -0700, Kees Cook wrote:
> On Wed, May 26, 2021 at 02:16:24PM -0700, Darrick J. Wong wrote:
> > On Wed, May 26, 2021 at 01:21:06PM -0500, Gustavo A. R. Silva wrote:
> > > 
> > > 
> > > On 4/20/21 18:56, Gustavo A. R. Silva wrote:
> > > > 
> > > > 
> > > > On 4/20/21 18:38, Darrick J. Wong wrote:
> > > >> On Tue, Apr 20, 2021 at 06:06:52PM -0500, Gustavo A. R. Silva wrote:
> > > >>> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> > > >>> the following warnings by replacing /* fall through */ comments,
> > > >>> and its variants, with the new pseudo-keyword macro fallthrough:
> > > >>>
> > > >>> fs/xfs/libxfs/xfs_alloc.c:3167:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/libxfs/xfs_da_btree.c:286:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/libxfs/xfs_ag_resv.c:346:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/libxfs/xfs_ag_resv.c:388:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_bmap_util.c:246:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_export.c:88:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_export.c:96:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_file.c:867:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_ioctl.c:562:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_ioctl.c:1548:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_iomap.c:1040:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_inode.c:852:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_log.c:2627:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/xfs_trans_buf.c:298:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/bmap.c:275:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/btree.c:48:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/common.c:85:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/common.c:138:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/common.c:698:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/dabtree.c:51:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>> fs/xfs/scrub/repair.c:951:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
> > > >>>
> > > >>> Notice that Clang doesn't recognize /* fall through */ comments as
> > > >>> implicit fall-through markings, so in order to globally enable
> > > >>> -Wimplicit-fallthrough for Clang, these comments need to be
> > > >>> replaced with fallthrough; in the whole codebase.
> > > >>>
> > > >>> Link: https://github.com/KSPP/linux/issues/115
> > > >>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > > >>
> > > >> I've already NAKd this twice, so I guess I'll NAK it a third time.
> > > > 
> > > > Darrick,
> > > > 
> > > > The adoption of fallthrough; has been already accepted and in use since Linux v5.7:
> > > > 
> > > > https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> > > > 
> > > > This change is needed, and I would really prefer if this goes upstream through your tree.
> > > > 
> > > > Linus has taken these patches directly for a while, now.
> > > > 
> > > > Could you consider taking it this time? :)
> > > > 
> > > 
> > > Hi Darrick,
> > > 
> > > If you don't mind, I will take this in my -next[1] branch for v5.14, so we can globally enable
> > > -Wimplicit-fallthrough for Clang in that release.
> > > 
> > > We had thousands of these warnings and now we are down to 47 in next-20210526,
> > > 22 of which are fixed with this patch.
> > 
> > I guess we're all required to kowtow to a bunch of effing bots now.
> > Hooray for having to have a macro to code-switch for the sake of
> > stupid compiler writers who refuse to give the rest of us a single
> > workable way to signal "this switch code block should not end here":
> > 
> > /* fall through */
> > __attribute__((fallthrough));
> > do { } while (0) /* fall through */
> > 
> > and soon the ISO geniuses will make it worse by adding to C2x:
> > 
> > [[fallthrough]];
> > 
> > Hooray!  Macros to abstractify stupidity!!!!
> > 
> > Dave and I have told you and Miaohe several[1] times[2] to fix[3] the
> > compiler, but clearly you don't care what we think and have decided to
> > ram this in through Linus anyway.
> 
> To clarify, we certainly _do_ care what you think. It's just that
> when faced with the difficulties of the compiler's implementations of
> handling this, the kernel had to get creative and pick the least-bad of
> many bad choices.

The choices are bad, so **turn it off** in fs/xfs/Makefile and don't go
making us clutter up shared library code that will then have to be
ported to userspace.

--D

> We're trying to make the kernel safer for everyone,
> and this particular C language weakness has caused us a significant
> number of bugs. Eradicating it is worth the effort.
> All that said, as you pointed out, you _have_ asked before[1] to just
> have Linus take it without bothering you directly, so okay, that can be
> done. Generally maintainers have wanted these changes to go through their
> trees so it doesn't cause them merge pain, but it seems you'd prefer it
> the other way around.
> 
> -Kees
> 
> [1] https://lore.kernel.org/linux-xfs/20200820191237.GK6096@magnolia/
> "If you feel really passionate about ramming a bunch of pointless churn
>  into the kernel tree to make my life more painful, send this to Linus
>  and let him make the change."
> 
> > Since that is what you choose, do not send me email again.
> > 
> > NAKed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> > [1] https://lore.kernel.org/linux-xfs/20200820191237.GK6096@magnolia/
> > [2] https://lore.kernel.org/linux-xfs/20210420230652.GA70650@embeddedor/
> > [3] https://lore.kernel.org/linux-xfs/20200708065512.GN2005@dread.disaster.area/
> > 
> > > 
> > > Thanks
> > > --
> > > Gustavo
> > > 
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp
> 
> -- 
> Kees Cook
