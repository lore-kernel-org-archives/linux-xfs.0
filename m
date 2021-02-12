Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15CCC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D3FA64E2A
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhBLWvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:51:49 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42122 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232440AbhBLWqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 17:46:32 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7045D1040B2A;
        Sat, 13 Feb 2021 09:45:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lAhC2-001qTs-M6; Sat, 13 Feb 2021 09:45:42 +1100
Date:   Sat, 13 Feb 2021 09:45:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Markus Mayer <mmayer@broadcom.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Linux XFS <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at
 the very end
Message-ID: <20210212224542.GA4662@dread.disaster.area>
References: <20210212204849.1556406-1-mmayer@broadcom.com>
 <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net>
 <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=5xOlfOR4AAAA:8 a=7-415B0cAAAA:8
        a=2VbEWD2bQ-GDsp0Qo-YA:9 a=CjuIK1q_8ugA:10 a=SGlsW6VomvECssOqsvzv:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 01:55:06PM -0800, Markus Mayer wrote:
> On Fri, 12 Feb 2021 at 13:29, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > On 2/12/21 2:51 PM, Markus Mayer wrote:
> > >> To prevent issues when the ".o" extension appears in a directory path,
> > >> ensure that the ".o" -> ".lo" substitution is only performed for the
> > >> final file extension.
> > >
> > > If the subject should be "[PATCH] xfsprogs: ...", please let me know.
> >
> > Nah, that's fine, I noticed it.
> >
> > So did you have a path component that had ".o" in it that got substituted?
> > Is that what the bugfix is?
> 
> Yes and yes.
> 
> Specifically, I was asked to name the build directory in our build
> system "workspace.o" (or something else ending in .o) because that
> causes the automated backup to skip backing up temporary build
> directories, which is what we want. There is an existing exclusion
> pattern that skips .o files during backup runs, and they didn't want
> to create specialized rules for different projects. Hence the request
> for the oddly named directory to make it match the existing pattern.
> 
> We also have a symlink without the ".o" extension (workspace ->
> workspace.o) which is commonly used to access the work space, but
> symlinks  frequently get expanded when scripts run. In the end, the
> xfsprogs build system saw the full path without the symlink
> (".../workspace.o/.../xfsprogs-5.8.0/...") and started substituting
> workspace.o with workspace.lo. And then the build died.
> 
> Like this:
> 
> >>> xfsprogs 5.8.0 Building
> PATH="/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/host/bin:/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
>  /usr/bin/make -j33  -C
> /local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/build/xfsprogs-5.8.0/
>    [HEADERS] include
>    [HEADERS] libxfs
> Building include
>     [LN]     disk
> make[3]: Nothing to be done for 'include'.
> Building libfrog
>     [CC]     gen_crc32table
>     [GENERATE] crc32table.h
> make[4]: *** No rule to make target
> '/local/users/jenkins/workspace.lo/buildroot_linux-5.4_llvm/output/arm64/target/usr/include/uuid/uuid.h',
> needed by 'bitmap.lo'.  Stop.

So there's a rule like this generated:

bitmap.lo: bitmap.c ../include/xfs.h ../include/xfs/linux.h \
 ../include/xfs/xfs_types.h ../include/xfs/xfs_fs_compat.h \
 ../include/xfs/xfs_fs.h ../include/platform_defs.h avl64.h \
 ../include/list.h bitmap.h

The sed expression is:

$(SED) -e 's,^\([^:]*\)\.o,\1.lo,'

Which means it is supposed to match from the start of line to a ".o",
and store everything up to the ".o" in register 1.

And the problem is that it is matching a ".o" in the middle of a
string.

So existing behaviour:

$ echo "foo.o/bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o,\1.lo,'
foo.o/bitmap.lo: bitmap.c ../include/xfs.h ../include/xfs/linux.h
$

Looks correct until the dependency line is split and the first entry
in the split line is something like "foo.o/uuid.h"

Your modified version:

$ echo "bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o$$,\1.lo,'
bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h
$

Doesn't work for the case we actually need the substitution for.

So, really, I think we need to match against the full target
specification rather than just ".o".

Something like

$SED -e 's,^\([^:]*\)\.o: ,\1.lo: ,'

$ echo "foo.o/bitmap: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o: ,\1.lo: ,'
foo.o/bitmap: bitmap.c ../include/xfs.h ../include/xfs/linux.h
$ echo "foo.o/bitmap.o: bitmap.c ../include/xfs.h ../include/xfs/linux.h" | sed -e 's,^\([^:]*\)\.o: ,\1.lo: ,'
foo.o/bitmap.lo: bitmap.c ../include/xfs.h ../include/xfs/linux.h

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
