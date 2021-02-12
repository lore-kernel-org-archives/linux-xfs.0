Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23706C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E126861606
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBLWVr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhBLWVq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Feb 2021 17:21:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FAA764E8E;
        Fri, 12 Feb 2021 22:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613168466;
        bh=PhCOHn/NXBAvGPcQVCw8T7mSZYy6VOtVBWKuq3j6UZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PnTmtCxQmBSc90C0iv7faWo3nN/R1Rxtii8ipPXz4lLEalvly6l99imluzdlmyzHh
         UUwr9XcOqrn/VCoP9WTjx6Fhgu3FOdPP0BmoOP7C4PrPpauk58Lq2m8cUzih9Azhs2
         zaSmLIYkt0RTtJKUvMwED4FtYQvBfClnqfgv7LV8OD0YAEBHdUBhqty/lH20oG5efQ
         xaKMQ9xn1Qhe14ICiNqAXmolgKgzMtMiaENvMhj+klgQzKWtwNtuiNhPHky7yyj3xH
         2+cTfVtDoV+Q7Wu+zer9sy8ZLRI/bTJXUZbnaUmWt2xSJEe9ch+Pmm9TRvMvGkr18i
         pHoSuNr7GzLsA==
Date:   Fri, 12 Feb 2021 14:21:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Markus Mayer <mmayer@broadcom.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Linux XFS <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at
 the very end
Message-ID: <20210212222105.GO7193@magnolia>
References: <20210212204849.1556406-1-mmayer@broadcom.com>
 <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
 <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net>
 <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGt4E5uA6futY0+AySLJTHsmoUp7OceNca=7ReXAg-o8mw0=7Q@mail.gmail.com>
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

Does the backup not know about the NODUMP flag, aka chattr +d ?

--D

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
> make[4]: *** Waiting for unfinished jobs....
>     [CC]     avl64.lo
> include/buildrules:35: recipe for target 'libfrog' failed
> make[3]: *** [libfrog] Error 2
> Makefile:91: recipe for target 'default' failed
> make[2]: *** [default] Error 2
> package/pkg-generic.mk:247: recipe for target
> '/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/build/xfsprogs-5.8.0/.stamp_built'
> failed
> make[1]: *** [/local/users/jenkins/workspace.o/buildroot_linux-5.4_llvm/output/arm64/build/xfsprogs-5.8.0/.stamp_built]
> Error 2
> 
> Regards,
> -Markus
