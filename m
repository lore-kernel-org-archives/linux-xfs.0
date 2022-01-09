Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADDCC433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Jan 2022 04:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiAIENx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 23:13:53 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38502 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231218AbiAIENx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 23:13:53 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2094DeiB020170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 8 Jan 2022 23:13:41 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6F3AE15C33E5; Sat,  8 Jan 2022 23:13:40 -0500 (EST)
Date:   Sat, 8 Jan 2022 23:13:40 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: fix static build problems caused by liburcu
Message-ID: <Ydpg9H7t/hJq0Dz+@mit.edu>
References: <20220108195739.1212901-1-tytso@mit.edu>
 <20220108232338.GV656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108232338.GV656707@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 08, 2022 at 03:23:38PM -0800, Darrick J. Wong wrote:
> On Sat, Jan 08, 2022 at 02:57:39PM -0500, Theodore Ts'o wrote:
> > The liburcu library has a dependency on pthreads.  Hence, in order for
> > static builds of xfsprogs to work, $(LIBPTHREAD) needs to appear
> > *after* $(LUBURCU) in LLDLIBS.  Otherwise, static links of xfs_* will
> > fail due to undefined references of pthread_create, pthread_exit,
> > et. al.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Ugh, I keep forgetting that ld wants library dependencies in reverse
> order nowadays...

Actually, for static linking this has always been the case.  For
example if foo_init() in libfoo calls bar_init() from libbar, you have
to specify the order as "-lfoo -lbar".  That's because the static
linker processes the libraries once, in command-line order.  So when
the program uses (and thus pulls in foo_init), the linker searches
-lfoo to find foo_init, and then looks at what symbols it needs, and
then will start searching the rest of the libraries to find bar_init,
which it will find only if -lbar is specified after -lfoo.

The problem is we've gotten spoiled by ELF shared libraries, where the
symbols are resolved as they are needed, so when main() calls
foo_init() at runtime, only then will the shared linker look for
bar_init(), which it will find regardless of wheter the libraries are
specified as "-lfoo -lbar" or "-lbar -lfoo".

So in general, libraries which are used by other libraries, but which
have no dependenciees of their own, should be listed last.  This
includes libraries such as -lpthread, -lsocket on Solaris, -lnsl (if
you use NIS/Yellow Pages), etc. --- but you'll only notice if you try
static linking.

Cheers,

					- Ted
