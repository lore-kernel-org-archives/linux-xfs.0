Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81483C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Dec 2021 17:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhLESAb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Dec 2021 13:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbhLESAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Dec 2021 13:00:30 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72136C061714
        for <linux-xfs@vger.kernel.org>; Sun,  5 Dec 2021 09:57:03 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mtvl0-0008Kx-Ln; Sun, 05 Dec 2021 17:57:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1000974: copy_move_algo.hpp:1083:10: error: =?UTF-8?Q?=E2=80=98=5F=5Ffallthrough=5F=5F=E2=80=99?= was not declared in this scope; did you mean =?UTF-8?Q?=E2=80=98fallthrough=E2=80=99=3F?=
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1000974@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: 
References: <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch> <9b9bda73-9554-0c75-824d-f8d1b9b98e19@debian.org> <7686ac7e-0df1-a98c-27ce-51dc5e46c55e@debian.org> <c7ccff50-c177-7f96-2d99-2077f77374ad@debian.org> <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch> <86067ed6-28c5-2591-b27a-80957166a9a9@debian.org> <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1000974-submit@bugs.debian.org id=B1000974.163872674629910
          (code B ref 1000974); Sun, 05 Dec 2021 17:57:01 +0000
Received: (at 1000974) by bugs.debian.org; 5 Dec 2021 17:52:26 +0000
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1]:48072)
        by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <djwong@kernel.org>)
        id 1mtvgY-0007mC-71
        for 1000974@bugs.debian.org; Sun, 05 Dec 2021 17:52:26 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B588EB80ED1;
        Sun,  5 Dec 2021 17:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66998C00446;
        Sun,  5 Dec 2021 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638726313;
        bh=XnEkihhBHsHU/H89++HoQl4EDEob1fdM9NDWZGz+Nac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsP4pkUriueUXJABFbRRttxuxw8mKEjS1FQMDWt01vQK1v1SKiyPpUGF4EYr/r1ZF
         bagmAhhr2N3Z2vYNnUKosYQrDZszvIiriEGMiaT19cUgMlRtMwteLZ9dXLqE4ShGeZ
         bobtrzEyuPHrNmrs12D82HiGoUswtn8p/eQSPS2U2KsVsL7zl2p1Xj4ClGjL55EPhR
         4UNN4J/vCyKcbstxuIV4IdWJ0r5Ack94URLH1Q+9tsDQMbtGtnBifI5a1tcZ5R5Pgd
         enPCQmVSBOpOtHOxkFH+oF+zHAUnCG3x2jfj7ff085t3nbvxpwwyaMxh3oxkHeuEvf
         RvdTXECQfjqEQ==
Date:   Sun, 5 Dec 2021 09:45:12 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Thomas Goirand <zigo@debian.org>, 1000974@bugs.debian.org
Cc:     Giovanni Mascellani <gio@debian.org>,
        xfslibs-dev@packages.debian.org
Message-ID: <20211205174512.GP8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86067ed6-28c5-2591-b27a-80957166a9a9@debian.org>
X-Greylist: delayed 426 seconds by postgrey-1.36 at buxtehude; Sun, 05 Dec 2021 17:52:25 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 05, 2021 at 06:33:40PM +0100, Thomas Goirand wrote:
> On 12/5/21 4:50 PM, Giovanni Mascellani wrote:
> > reassign 1000974 xfslibs-dev
> > severity 1000974 important
> > retitle 1000974 xfs/linux.h defines common word "fallthrough" breaking
> > unrelated headers
> > thanks
> > 
> > Hi,
> > 
> > On 04/12/21 23:36, Thomas Goirand wrote:
> >> On 12/4/21 5:11 PM, Giovanni Mascellani wrote:
> >>> Could you try running that compilation command with g++ -E, so you can
> >>> see what BOOST_FALLTHROUGH is actually begin replaced with?
> >>
> >> Oh, sorry, now I get what you meant (did a c++ --help to understand what
> >> -E was doing). Here's the result in
> >> CMakeFiles/seastar.dir/src/core/file.cc.o:
> >>
> >> __attribute__((__attribute__((__fallthrough__))));
> >>
> >> Probably, there's a mistake, and it should really be:
> >>
> >> __attribute__((__fallthrough__));
> >>
> >> instead, which is the source of the trouble?
> > 
> > It seems that the problem goes this way:
> > 
> >  * Boost defines in /usr/include/boost/config/compiler/gcc.hpp:
> > 
> > #define BOOST_FALLTHROUGH __attribute__((fallthrough))
> > 
> >  * But /usr/include/xfs/linux.h defines:
> > 
> > #define fallthrough __attribute__((__fallthrough__))
> > 
> > So the "fallthrough" in Boost's definition is expanded again and causes
> > the problem.
> > 
> > I think xfs/linux.h is at fault here, because it aggressively defines a
> > common word (while Boost namespaces all its definitions with a BOOST_
> > prefix). Unfortunately the C/C++ preprocessor makes it easy to break
> > other headers if you define stuff too liberally. This wold also, for
> > example, break any program that use the name "fallthrough" for a
> > variable, which is a completely reasonable name to use. A simple example
> > could be:
> > ---
> > #include <xfs/linux.h>
> > 
> > int main() {
> >     int fallthrough = 0;
> >     return fallthrough;
> > }
> > ---
> > which fails compilation with:
> > ---
> > $ LANG=C gcc test.c
> > test.c: In function 'main':
> > test.c:4:5: warning: 'fallthrough' attribute not followed by ';'
> > [-Wattributes]
> >     4 |     int fallthrough = 0;
> >       |     ^~~
> > test.c:4:21: error: expected identifier or '(' before '=' token
> >     4 |     int fallthrough = 0;
> >       |                     ^
> > In file included from test.c:1:
> > test.c:5:12: error: expected expression before '__attribute__'
> >     5 |     return fallthrough;
> >       |            ^~~~~~~~~~~
> > ---
> > 
> > You can probably work around this problem by undefining "fallthrough"
> > just after the xfs/linux.h header. In the meantime I am reassigning this
> > bug to xfslibs-dev.

Yeah, sorry.  This is braindamage from the Linux kernel (because hey, we
share libxfs between kernel and userspace) that I mistakenly let escape
because the authors of the kernel patch didn't try to help us when they
forced this stupid mess on us.  All this BS because some compiler
writers didn't like their static checkers to have to use regular
expressions for compatibility with existing codebases, and the language
standard people decided to introduce a breaking change to "standardize"
it.

Will fix ASAP.

--D

> > 
> > Giovanni.
> 
> 
> Hi,
> 
> I can confirm that commenting away line 373 to 381 of xfs/linux.h solve
> the troubles when building Ceph. Downgrading to 5.13.0-1 (using
> snapshot.d.o) also solved the trouble, showing that 5.14.0 really is the
> trouble here.
> 
> Thanks Giovanni for finding this out.
> 
> Cheers,
> 
> Thomas Goirand (zigo)
