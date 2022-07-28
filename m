Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3F7C19F2B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 03:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiG1DyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 23:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiG1DyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 23:54:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50F1F620;
        Wed, 27 Jul 2022 20:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3B91B82320;
        Thu, 28 Jul 2022 03:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66CEC433C1;
        Thu, 28 Jul 2022 03:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658980459;
        bh=8gq0l4djNDFgoFnSfWHUfp0KklnFGoiHo5nPlftD+Cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H3HFOg1r192m/ag/uCu6bnWAQvhrLWkFGoQ1I+YVBlweFzRiEEeiw2Xcnk5ShRLli
         1GYSlbooYztobrvhb4EMvL9HKqBZ04G1RfsmUTltfWRF3jFf05mKYRsx7z6wA3YLvh
         kDWXtCqfEzzbmNOc5lfZNrzjth530v5Kyz9I02tRw4vTLq47cO4ngRBDgc7KfrV8os
         NuuL5Wfep73Pt4r1W0VVNf5LnZYx1QasKnAhZXrPsBmbAthwFGLYiRu0J3AcPcDHtl
         kZ5NVlKkfo0f0Rz6XyyB1A8ASerNwEy6yXTz+TaquEX9Ke9BSuN7eiWzJRVMmKufWs
         4X3n99cI7d7/w==
Date:   Wed, 27 Jul 2022 20:54:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "liuyd.fnst@fujitsu.com" <liuyd.fnst@fujitsu.com>
Cc:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Message-ID: <YuIIa2EboQGTeNo1@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768327.1045534.10420155448662856970.stgit@magnolia>
 <3f63e720-c252-a836-b700-7a5739312b1b@fujitsu.com>
 <YuH2h1DiRm8r3p2j@magnolia>
 <45012000-087a-e98d-7322-4f1079bbb1d8@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45012000-087a-e98d-7322-4f1079bbb1d8@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 03:38:38AM +0000, liuyd.fnst@fujitsu.com wrote:
> Hi, Darrick.
> 
> 
> On 7/28/22 10:37, Darrick J. Wong wrote:
> > Does this patch fix NFS for you?
> 
> It works for me. Thanks.
> BTW. It has conflict during "git am". Looks like your branch are ahead 
> of master.

Yes, I base my development branch off of for-next nowadays.  Thanks for
the report, I'll add a tested-by if that's ok and send it out as a bug
fix.

--D

> > 
> > --D
> > ---
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > seek_sanity_test: use XFS ioctls to determine file allocation unit size
> > 
> > liuyd.fnst@fujitsu.com reported that my recent change to the seek sanity
> > test broke NFS.  I foolishly thought that st_blksize was sufficient to
> > find the file allocation unit size so that applications could figure out
> > the SEEK_HOLE granularity.  Replace that with an explicit callout to XFS
> > ioctls so that xfs realtime will work again.
> > 
> > Fixes: e861a302 ("seek_sanity_test: fix allocation unit detection on XFS realtime")
> > Reported-by: liuyd.fnst@fujitsu.com
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   src/Makefile           |    4 ++++
> >   src/seek_sanity_test.c |   40 +++++++++++++++++++++++++++++++---------
> >   2 files changed, 35 insertions(+), 9 deletions(-)
> > 
> > diff --git a/src/Makefile b/src/Makefile
> > index 38628a22..b89a7a5e 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -82,6 +82,10 @@ ifeq ($(HAVE_LIBCAP), true)
> >   LLDLIBS += -lcap
> >   endif
> >   
> > +ifeq ($(HAVE_FSXATTR_XFLAG_HASATTR), yes)
> > +LCFLAGS += -DHAVE_FSXATTR_XFLAG_HASATTR
> > +endif
> > +
> >   ifeq ($(HAVE_SEEK_DATA), yes)
> >    ifeq ($(HAVE_FSXATTR_XFLAG_HASATTR), yes)
> >     ifeq ($(HAVE_NFTW), yes)
> > diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> > index 1030d0c5..b53f4862 100644
> > --- a/src/seek_sanity_test.c
> > +++ b/src/seek_sanity_test.c
> > @@ -40,6 +40,32 @@ static void get_file_system(int fd)
> >   	}
> >   }
> >   
> > +#ifdef HAVE_FSXATTR_XFLAG_HASATTR
> > +/* Compute the file allocation unit size for an XFS file. */
> > +static int detect_xfs_alloc_unit(int fd)
> > +{
> > +	struct fsxattr fsx;
> > +	struct xfs_fsop_geom fsgeom;
> > +	int ret;
> > +
> > +	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, &fsgeom);
> > +	if (ret)
> > +		return -1;
> > +
> > +	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fsx);
> > +	if (ret)
> > +		return -1;
> > +
> > +	alloc_size = fsgeom.blocksize;
> > +	if (fsx.fsx_xflags & FS_XFLAG_REALTIME)
> > +		alloc_size *= fsgeom.rtextsize;
> > +
> > +	return 0;
> > +}
> > +#else
> > +# define detect_xfs_alloc_unit(fd) (-1)
> > +#endif
> > +
> >   static int get_io_sizes(int fd)
> >   {
> >   	off_t pos = 0, offset = 1;
> > @@ -47,6 +73,10 @@ static int get_io_sizes(int fd)
> >   	int shift, ret;
> >   	int pagesz = sysconf(_SC_PAGE_SIZE);
> >   
> > +	ret = detect_xfs_alloc_unit(fd);
> > +	if (!ret)
> > +		goto done;
> > +
> >   	ret = fstat(fd, &buf);
> >   	if (ret) {
> >   		fprintf(stderr, "  ERROR %d: Failed to find io blocksize\n",
> > @@ -54,16 +84,8 @@ static int get_io_sizes(int fd)
> >   		return ret;
> >   	}
> >   
> > -	/*
> > -	 * st_blksize is typically also the allocation size.  However, XFS
> > -	 * rounds this up to the page size, so if the stat blocksize is exactly
> > -	 * one page, use this iterative algorithm to see if SEEK_DATA will hint
> > -	 * at a more precise answer based on the filesystem's (pre)allocation
> > -	 * decisions.
> > -	 */
> > +	/* st_blksize is typically also the allocation size */
> >   	alloc_size = buf.st_blksize;
> > -	if (alloc_size != pagesz)
> > -		goto done;
> >   
> >   	/* try to discover the actual alloc size */
> >   	while (pos == 0 && offset < alloc_size) {
