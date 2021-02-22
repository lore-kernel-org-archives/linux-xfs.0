Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FC3C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 19:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387CA64E15
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 19:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhBVToA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232728AbhBVTny (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 14:43:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB36764E02;
        Mon, 22 Feb 2021 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614022994;
        bh=usSU2oBkZGnp1Mz/IUNaysLAP3xhl6Ersv3SVqy26Jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GG6JU+48jsGavyrv80rmaFi0ZqsPflJofEAnLBKa7qo7+r8TDCEOPs40B7fWXE0sA
         2xhT3ViIYvSyOeWcpRWjkudJgqCN9tZTj2hvdSwWJ593Xwc5lD+9lmAYwFVoaCzl1G
         i3TdsOK4VBkvjQxKjJ7CS8TBqg8jfx+c3G19fW9YB2/Q9jEXkuLG9GPk+x3Noc3PEb
         1Azb5LwG3B2jbqo47p2te8AnSl1asLIXNz/h23JbN+V7LYvWAsVMbcZtyKo+oYdkT9
         FNhSaExM45y9BjQCXrTDHecDewJnoFhfTbT3PDp9B4R+jEdkK/blAJZoblFgfj0f8f
         E3DwjYl9KFXqw==
Date:   Mon, 22 Feb 2021 11:43:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org,
        Steve Langasek <steve.langasek@ubuntu.com>
Subject: Re: [PATCH v2 1/2] debian: Regenerate config.guess using debhelper
Message-ID: <20210222194313.GA7267@magnolia>
References: <20210221093946.3473-1-bastiangermann@fishpost.de>
 <20210221093946.3473-2-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221093946.3473-2-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 21, 2021 at 10:39:45AM +0100, Bastian Germann wrote:
> This is a change introduced in 5.10.0-2ubuntu2 with the changelog:
> 
> > xfsprogs upstream has regressed config.guess, so use
> > dh_update_autotools_config.
> 
> The 5.10.0 tarball has a config.guess that breaks builds on RISC-V:
> ...
> UNAME_MACHINE = riscv64
> UNAME_RELEASE = 5.0.0+
> UNAME_SYSTEM  = Linux
> UNAME_VERSION = #2 SMP Sat Mar 9 22:34:53 UTC 2019
> configure: error: cannot guess build type; you must specify one
> make[1]: *** [Makefile:131: include/builddefs] Error 1
> ...
> 
> Reported-by: Steve Langasek <steve.langasek@ubuntu.com>
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
> ---
>  debian/changelog | 7 +++++++
>  debian/rules     | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 5421aed6..679fbf03 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,10 @@
> +xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
> +
> +  [ Steve Langasek ]
> +  * Regenerate config.guess using debhelper
> +
> + -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
> +
>  xfsprogs (5.10.0-3) unstable; urgency=medium
>  
>    * Drop unused dh-python from Build-Depends (Closes: #981361)
> diff --git a/debian/rules b/debian/rules
> index c6ca5491..fe9a1c3a 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -43,6 +43,7 @@ config: .census
>  	@echo "== dpkg-buildpackage: configure" 1>&2
>  	$(checkdir)
>  	AUTOHEADER=/bin/true dh_autoreconf
> +	dh_update_autotools_config

Hm.  The manual page says "dh_update_autotools_config replaces all
occurrences of config.sub and config.guess in the source tree by the
up-to-date versions found in the autotools-dev package."

autoreconf does not itself examine config.{guess,sub}.  automake can
override those files if someone passes it --force --add-missing, but
nobody does.  The build then kicks off with an ancient config.guess.

Hence this patch forcibly overrides config.guess (and config.sub) after
autoreconf, but before debuild gets to ./configure, thereby solving the
build failure on riscv.

Eric could also not to ship config.guess files at all, but that would
break the age-old "download and unpack tarball, ./configure && make"
workflow.  Overriding the files also works, though I have not focused
on repercussions for reproducible builds while examining this patch.

----------

As for the question of why the config.guess file versions keep
changing in the .orig and kernel.org tarballs--

[1] is a tarball with a 2013 era config.guess and files owned by
'sandeen', which I guess means that Eric generates the config.guess file
on a machine with fairly old devel packages before uploading to
kernel.org.

[2] is a tarball with a 2016 era config.guess and files owned by
'nathans'.  I suspect this means that Nathan Scott generated his own
.orig tarball when creating the 5.6.0 package, and as part of that
generated config.guess from a (somewhat more up to date) system?

[3] is a tarball with a 2013 era config.guess and files owned by
'sandeen', which I guess means that four releases later, Eric still
generates the config.guess file on a machine with fairly old devel
packages before uploading to kernel.org.  Though weirdly now he's doing
this as root (or I really hope fakeroot?)

[4] appears to be the same tarball as [3].

So reading between the lines here, I speculate that Eric runs 'make
xfsprogs-5.6.0.tar.xz' on (who are we kidding here, RHEL) and so that
tarball gets the 2013 era config.guess.  Nathan ran 'make
xfsprogs-5.6.0.tar.gz' on Debian and uploaded that to Debian, whereas
Bastian is pulling tarballs straight from kernel.org?  Then Ubuntu
pulled the Debian sources, found that riscv regressed, hence this patch
to reset config.guess?

(And the reason I never noticed is that I build from git on Ubuntu
20.04.  There's no config.guess in the build directory so the build
scripts install config.guess from autotools-dev; the one I get is from
2018 or so...)

Insofar as I avoid have strong opinions about packaging, I don't think
it's unreasonable for a distro to override autotools files with the
versions that they're shipping in that distro.  Who knows what kinds of
adjustments Debian makes to autotools, and it's certainly their right to
do that.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

<flame>
Personally I also think the upstream tarball should not ship with any of
those autotools files at all because they are not revision-controlled in
upstream git.  Anyone building from source ought to have autotools and
can generate their own.
</flame>

--D

[1] https://mirrors.edge.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.6.0.tar.gz
[2] http://archive.ubuntu.com/ubuntu/pool/main/x/xfsprogs/xfsprogs_5.6.0.orig.tar.gz

[3] https://mirrors.edge.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.10.0.tar.xz
[4] http://deb.debian.org/debian/pool/main/x/xfsprogs/xfsprogs_5.10.0.orig.tar.xz

>  	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
>  	touch .census
>  
> -- 
> 2.30.1
> 
