Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D26C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9247C23428
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 18:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388731AbhATSpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:45:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387710AbhATRjr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 12:39:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5C872070A;
        Wed, 20 Jan 2021 17:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611164346;
        bh=o6ayQgk+I4RGpW8DPAJHrUbUv9ou5WB2+43toSTtSIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oi3oWApa9ysreerizFoiZ/Ps4ndskMk9e6I9yX1rolhzv8REp9AqO7dOleHndkQPn
         FC6W5FeedbhX/EfUt3221mOTPP1dJVz2pxzbYFHGJ9Hhx3vTfFdzIrzFWAlONlXNeu
         Et6cDmxjlI5dnScH+/Y+AbX5oqjs2HJ/iG4nU7counoHalyxMSVWdUERSGO4m0zEOg
         RG0q+JKayJgjZGaxso4N7ztSsgcPTkBwOZnEwK7LcqroKkSZjGrYuwUvurUfFj3+J3
         bWvjG7bqHxlAdA66v/7Gs0xBF6Fn/mmGDd58Sjyr9j/S+gmsXkxiwpNJnPoGvJkEsc
         +alL8fomDtGYg==
Date:   Wed, 20 Jan 2021 09:39:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
Message-ID: <20210120173905.GA3134581@magnolia>
References: <161076026570.3386403.8299786881687962135.stgit@magnolia>
 <161076027195.3386403.12700317703299129248.stgit@magnolia>
 <87k0s723c8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0s723c8.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 20, 2021 at 06:05:35PM +0530, Chandan Babu R wrote:
> 
> On 16 Jan 2021 at 06:54, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Add a command to xfs_db so that we can navigate to inodes by path.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  db/Makefile       |    3 -
> >  db/command.c      |    1
> >  db/command.h      |    1
> >  db/namei.c        |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  man/man8/xfs_db.8 |    4 +
> >  5 files changed, 231 insertions(+), 1 deletion(-)
> >  create mode 100644 db/namei.c
> >
> >
> > diff --git a/db/Makefile b/db/Makefile
> > index 9d502bf0..beafb105 100644
> > --- a/db/Makefile
> > +++ b/db/Makefile
> > @@ -14,7 +14,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
> >  	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
> >  	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
> >  	fuzz.h
> > -CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c timelimit.c
> > +CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
> > +	timelimit.c
> >  LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
> >
> >  LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> > diff --git a/db/command.c b/db/command.c
> > index 43828369..02f778b9 100644
> > --- a/db/command.c
> > +++ b/db/command.c
> > @@ -131,6 +131,7 @@ init_commands(void)
> >  	logformat_init();
> >  	io_init();
> >  	metadump_init();
> > +	namei_init();
> >  	output_init();
> >  	print_init();
> >  	quit_init();
> > diff --git a/db/command.h b/db/command.h
> > index 6913c817..498983ff 100644
> > --- a/db/command.h
> > +++ b/db/command.h
> > @@ -33,3 +33,4 @@ extern void		btdump_init(void);
> >  extern void		info_init(void);
> >  extern void		btheight_init(void);
> >  extern void		timelimit_init(void);
> > +extern void		namei_init(void);
> > diff --git a/db/namei.c b/db/namei.c
> > new file mode 100644
> > index 00000000..eebebe15
> > --- /dev/null
> > +++ b/db/namei.c
> > @@ -0,0 +1,223 @@

<snip some of this out>

> > +/* Walk a directory path to an inode and set the io cursor to that inode. */
> > +static int
> > +path_walk(
> > +	char		*path)
> > +{
> > +	struct dirpath	*dirpath;
> > +	char		*p = path;
> > +	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
> > +	int		error = 0;
> > +
> > +	if (*p == '/') {
> > +		/* Absolute path, start from the root inode. */
> > +		p++;
> > +	} else {
> > +		/* Relative path, start from current dir. */
> > +		if (iocur_top->typ != &typtab[TYP_INODE] ||
> > +		    !S_ISDIR(iocur_top->mode))
> > +			return ENOTDIR;
> > +
> > +		rootino = iocur_top->ino;
> > +	}
> > +
> > +	dirpath = path_parse(p);
> > +	if (!dirpath)
> > +		return ENOMEM;
> > +
> > +	error = path_navigate(mp, rootino, dirpath);
> > +	if (error)
> > +		return error;
> 
> Memory pointed by dirpath (and its members) is not freed if the call to
> path_navigate() returns a non-zero error value.

Good catch, thanks!

--D
