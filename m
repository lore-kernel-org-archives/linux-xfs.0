Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCA0C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B686422DCC
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbhALBWg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbhALBWf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 20:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7966E22DCC;
        Tue, 12 Jan 2021 01:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610414514;
        bh=37xzC9F7U+5iQRsOcZGjmk/8SDa/wsdUDQ41xZaZANQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ndl3qvoxQlwOkUg1P7+qA4WUHaK92rzUBG6+t8+a4wVS5hciAs4zEZV3zlurQIeC1
         V9QXTm+QHSDPAdiCqZxHFpWLJ1ltDsGOhx/4TeVZbPKIVXvEjDZG8dOT3JHS6p1UQN
         n8L5mQkupu2seXXCufVA9QOPum8ZZn2OD8EbwuenefyEwPjj8pjOGPcKg9MynCtIbu
         f89XldwFNNrRs/OM3Y3pvKE8eKIRJt4YghY8aKGB81bHYrXh0OUhZG0DFjpMRXldO8
         mYrjy9SPaHmG2yKsvC4c9T6kxgkcWZjYxaHXz1NdK7hMXoKTMIwxsfRZatvI4A89VZ
         3PZUqWUJEK/pA==
Date:   Mon, 11 Jan 2021 17:21:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: load and unload libicu properly
Message-ID: <20210112012152.GG1164246@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
 <161017372698.1142776.3985444129678928114.stgit@magnolia>
 <87zh1fo8zw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh1fo8zw.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 07:45:15PM +0530, Chandan Babu R wrote:
> 
> On 09 Jan 2021 at 11:58, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Make sure we actually load and unload libicu properly.  This isn't
> > strictly required since the library can bootstrap itself, but unloading
> > means fewer things for valgrind to complain about.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  scrub/unicrash.c  |   17 +++++++++++++++++
> >  scrub/unicrash.h  |    4 ++++
> >  scrub/xfs_scrub.c |    6 ++++++
> >  3 files changed, 27 insertions(+)
> >
> >
> > diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> > index d5d2cf20..de3217c2 100644
> > --- a/scrub/unicrash.c
> > +++ b/scrub/unicrash.c
> > @@ -722,3 +722,20 @@ unicrash_check_fs_label(
> >  	return __unicrash_check_name(uc, dsc, _("filesystem label"),
> >  			label, 0);
> >  }
> > +
> > +/* Load libicu and initialize it. */
> > +bool
> > +unicrash_load(void)
> > +{
> > +	UErrorCode		uerr = U_ZERO_ERROR;
> > +
> > +	u_init(&uerr);
> > +	return U_FAILURE(uerr);
> > +}
> > +
> > +/* Unload libicu once we're done with it. */
> > +void
> > +unicrash_unload(void)
> > +{
> > +	u_cleanup();
> > +}
> > diff --git a/scrub/unicrash.h b/scrub/unicrash.h
> > index c3a7f385..32cae3d4 100644
> > --- a/scrub/unicrash.h
> > +++ b/scrub/unicrash.h
> > @@ -25,6 +25,8 @@ int unicrash_check_xattr_name(struct unicrash *uc, struct descr *dsc,
> >  		const char *attrname);
> >  int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
> >  		const char *label);
> > +bool unicrash_load(void);
> > +void unicrash_unload(void);
> >  #else
> >  # define unicrash_dir_init(u, c, b)		(0)
> >  # define unicrash_xattr_init(u, c, b)		(0)
> > @@ -33,6 +35,8 @@ int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
> >  # define unicrash_check_dir_name(u, d, n)	(0)
> >  # define unicrash_check_xattr_name(u, d, n)	(0)
> >  # define unicrash_check_fs_label(u, d, n)	(0)
> > +# define unicrash_init()			(0)
> 
> The above should probably be defining unicrash_load().

Yep, thanks for catching that.

--D

> > +# define unicrash_unload()			do { } while (0)
> >  #endif /* HAVE_LIBICU */
> >  
> >  #endif /* XFS_SCRUB_UNICRASH_H_ */
> > diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> > index 1edeb150..6b202912 100644
> > --- a/scrub/xfs_scrub.c
> > +++ b/scrub/xfs_scrub.c
> > @@ -603,6 +603,11 @@ main(
> >  	setlocale(LC_ALL, "");
> >  	bindtextdomain(PACKAGE, LOCALEDIR);
> >  	textdomain(PACKAGE);
> > +	if (unicrash_load()) {
> > +		fprintf(stderr,
> > +			_("%s: could initialize Unicode library.\n"), progname);
> > +		goto out;
> > +	}
> >  
> >  	pthread_mutex_init(&ctx.lock, NULL);
> >  	ctx.mode = SCRUB_MODE_REPAIR;
> > @@ -788,6 +793,7 @@ main(
> >  	phase_end(&all_pi, 0);
> >  	if (progress_fp)
> >  		fclose(progress_fp);
> > +	unicrash_unload();
> >  
> >  	/*
> >  	 * If we're being run as a service, the return code must fit the LSB
> 
> 
> -- 
> chandan
