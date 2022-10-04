Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E87C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 18:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJDSlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJDSlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 14:41:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6176566A
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 11:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C632B614CE
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 18:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD7AC433D6;
        Tue,  4 Oct 2022 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664908859;
        bh=x34F6IYI4R9aZxmRGQrBDpm5W4PqI9tXgpYRsmezSio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uGlVSGmW/9lHdLzaeqmRVc4eZpkqZfzt9IbN2d5yQf+pX8z3c+HjQegb+sP2uumxA
         Yn9Mqp+N72wLfaO+qI2HczaVCIS504W8YbbjiMNnfJGwQL+vHffw7zbhZ9eMIUaU1W
         7JfU0gWUF2GINM5sI/5SZs67ZBRf8ColkpncLPMKmuYOXj0obrd7Mc2ugcb3xBDOuA
         NN/YgxxaiYVkAt3Ua2PMVfM0IeLUc537g/bpQaCa+XT+AuvNMFHQL73Lkyy4npbbsv
         XNdliu+xdvCa/o1j+KqRsBr0f0pRZ5Uv5Pte4Fuzq9GyMOKoU4Pj31Tch5nD0aprWX
         nPfylT+pO82Dw==
Date:   Tue, 4 Oct 2022 11:40:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: fix warnings/errors due to missing include
Message-ID: <Yzx+Omrqs3Q16O57@magnolia>
References: <865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com>
 <Yzx7RrC1v2LQ6wSf@magnolia>
 <e1df04bf-866d-1dc8-9653-7612cce96fe0@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1df04bf-866d-1dc8-9653-7612cce96fe0@applied-asynchrony.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 04, 2022 at 08:34:23PM +0200, Holger Hoffstätte wrote:
> On 2022-10-04 20:28, Darrick J. Wong wrote:
> > On Tue, Oct 04, 2022 at 08:11:05PM +0200, Holger Hoffstätte wrote:
> > > 
> > > Gentoo is currently trying to rebuild the world with clang-16, uncovering exciting
> > > new errors in many packages since several warnings have been turned into errors,
> > > among them missing prototypes, as documented at:
> > > https://discourse.llvm.org/t/clang-16-notice-of-potentially-breaking-changes/65562
> > > 
> > > xfsprogs came up, with details at https://bugs.gentoo.org/875050.
> > > 
> > > The problem was easy to find: a missing include for the u_init/u_cleanup
> > > prototypes. The error:
> > > 
> > > Building scrub
> > >      [CC]     unicrash.o
> > > unicrash.c:746:2: error: call to undeclared function 'u_init'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
> > >          u_init(&uerr);
> > >          ^
> > > unicrash.c:746:2: note: did you mean 'u_digit'?
> > > /usr/include/unicode/uchar.h:4073:1: note: 'u_digit' declared here
> > > u_digit(UChar32 ch, int8_t radix);
> > > ^
> > > unicrash.c:754:2: error: call to undeclared function 'u_cleanup'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
> > >          u_cleanup();
> > >          ^
> > > 2 errors generated.
> > > 
> > > The complaint is valid and the fix is easy enough: just add the missing include.
> > > 
> > > Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> > 
> > Aha, that explains why I kept hearing reports about this but could never
> > get gcc to spit out this error.  Thanks for fixing this.
> 
> You're welcome. This reproduces with gcc when explicitly enabled:
> 
> $CFLAGS="-Werror=implicit-function-declaration -Werror=implicit-int" ./configure

Huh.  I don't know why my system won't complain.

$ gcc --version
gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

$ gcc -Wall -g -O3 -fstack-protector --param=ssp-buffer-size=4
-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3 -D_FILE_OFFSET_BITS=64
-Wno-address-of-packed-member -femit-struct-debug-detailed=any
-Wno-error=unused-but-set-variable -Wuninitialized -Wno-pointer-sign
-Wall -Wextra -Wno-unused-parameter -fstack-usage -Werror
-Wno-sign-compare -Wno-missing-field-initializers -Wmaybe-uninitialized
-Wno-error=unused-function -Wno-error=unused-variable
-Wno-error=maybe-uninitialized -Werror=implicit-function-declaration
-Werror=implicit-int   -g -O2 -DDEBUG
-DVERSION=\"6.1.0-rc0~WIP-2022-10-03\" -DLOCALEDIR=\"/usr/share/locale\"
-DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -I.. -D_LGPL_SOURCE
-D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -Werror -Wextra
-Wno-unused-parameter -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID
-DHAVE_GETFSMAP -DHAVE_GETFSREFCOUNTS -DHAVE_FALLOCATE
-DHAVE_LIBURCU_ATOMIC64 -DHAVE_MALLINFO -DHAVE_MALLINFO2 -DHAVE_SYNCFS
-DHAVE_LIBATTR -DHAVE_LIBICU  -DHAVE_SG_IO -DHAVE_HDIO_GETGEO -c
unicrash.c
$

--D
> 
> cheers,
> Holger
