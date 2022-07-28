Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C5FC3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 02:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiG1Cb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 22:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiG1Cb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 22:31:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3DB15FF6;
        Wed, 27 Jul 2022 19:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF00EB8227A;
        Thu, 28 Jul 2022 02:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5CFC433D6;
        Thu, 28 Jul 2022 02:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658975485;
        bh=bRMeE0TklgTUE7q2nGmRq1aC/prqp9QkICTceSUswXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fO3DBLi9ucvIw6mP9rEEEwpNYXGoQhHtlMtB5ZhEeGh6CfQMIjbl/HGwe3mY+gfnL
         PWHTGDamcXp6ReOOlhVsopZhcRQpQIF4f5VCT40KJYiKDOgab5IljDZ1PuL/q96JRY
         Rxqp1YZsYFOB0rY/hZ/8llEuTu6jbjszGlG4keR83wN1EX7aZWS/lxGW1RxcMGb6jg
         ztrOjO391LxaDfJ3DMtpUVZprLmaj20px1WEqwlRE5VaxPzWTrIUY7Wbr2jGPjYEns
         i4NKusCqDEe8dD+DZxTC708tokKc1Al0EFvc6ysEHP7YOGa2qWdta9WC7njOigVxRj
         rvUdi+vJ8wHKw==
Date:   Wed, 27 Jul 2022 19:31:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "liuyd.fnst@fujitsu.com" <liuyd.fnst@fujitsu.com>
Cc:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Message-ID: <YuH0/H23l6jGsuNd@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768327.1045534.10420155448662856970.stgit@magnolia>
 <3f63e720-c252-a836-b700-7a5739312b1b@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f63e720-c252-a836-b700-7a5739312b1b@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 01:37:08AM +0000, liuyd.fnst@fujitsu.com wrote:
> Hi, guys.
> 
> Recently I hit a regression during test xfstest. Reverting this commit 
> could fix that error.
> 
> Reproduce steps (only nfs4.2 has this error):
> ```
> # cat local.config
> 
> export TEST_DEV=127.0.0.1:/home/nfs/share0
> 
> export TEST_DIR=/mnt/test
> 
> export SCRATCH_DEV=127.0.0.1:/home/nfs/share1

ahahaaaa, NFS.  I forgot that it sets st_blksize == 1048576, which will
trip this up.

Let me work on a fix to seek_sanity_test.c to make this work for xfs
realtime without breaking NFS.  I /think/ the solution is to replace the
"if (...) goto done;" bit with something that queries FS_IOC_GETXATTR
and XFS_IOC_FSGEOMETRY to figure out if the file being tested is a
realtime file on an XFS filesystem, and set alloc_size to the rt extent
size.

/* Compute the file allocation unit size for an XFS file. */
static int detect_xfs_alloc_unit(int fd)
{
	struct fsxattr fsx;
	struct xfs_fsop_geom fsgeom;
	int ret;

	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, &fsgeom);
	if (ret)
		return -1;

	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fsx);
	if (ret)
		return -1;

	alloc_size = fsgeom.blocksize;
	if (fsx.fsx_xflags & FS_XFLAG_REALTIME)
		alloc_size *= fsgeom.rtextsize;

	return 0;
}

should suffice to fix these testcase on xfs realtime without messing up
nfs.

--D

> export SCRATCH_MNT=/mnt/scratch
> 
> export FSX_AVOID="-E"
> 
> export NFS_MOUNT_OPTIONS="-o rw,relatime,vers=4.2"
> 
> 
> # ./check -nfs generic/285
> 
> FSTYP         -- nfs
> 
> PLATFORM      -- Linux/aarch64 hpe-apollo80-01-n00 
> 5.14.0-131.el9.aarch64 #1 SMP PREEMPT_DYNAMIC Mon Jul 18 16:13:44 EDT 2022
> 
> MKFS_OPTIONS  -- 127.0.0.1:/home/nfs/share1
> 
> MOUNT_OPTIONS -- -o rw,relatime,vers=4.2 -o 
> context=system_u:object_r:root_t:s0 127.0.0.1:/home/nfs/share1 /mnt/scratch
> 
> 
> 
> generic/285 2s ... [failed, exit status 1]- output mismatch (see 
> /root/xfstests/results//generic/285.out.bad)
> 
>      --- tests/generic/285.out	2022-07-27 21:07:43.160268552 -0400
> 
>      +++ /root/xfstests/results//generic/285.out.bad	2022-07-27 
> 21:31:27.887090532 -0400
> 
>      @@ -1 +1,3 @@
> 
>       QA output created by 285
> 
>      +seek sanity check failed!
> 
>      +(see /root/xfstests/results//generic/285.full for details)
> 
>      ...
> 
>      (Run 'diff -u /root/xfstests/tests/generic/285.out 
> /root/xfstests/results//generic/285.out.bad'  to see the entire diff)
> 
> Ran: generic/285
> 
> Failures: generic/285
> 
> Failed 1 of 1 tests
> 
> 
> ```
> 
> Reverting this commit then test pass.
> ```
> # git revert e861a30255c9780425ee5193325d30882fbe7410
> # make -j && make install -j
> ---snip---
> # ./check -nfs generic/285
> 
> FSTYP         -- nfs
> 
> PLATFORM      -- Linux/aarch64 hpe-apollo80-01-n00 
> 5.14.0-131.el9.aarch64 #1 SMP PREEMPT_DYNAMIC Mon Jul 18 16:13:44 EDT 2022
> 
> MKFS_OPTIONS  -- 127.0.0.1:/home/nfs/share1
> 
> MOUNT_OPTIONS -- -o rw,relatime,vers=4.2 -o 
> context=system_u:object_r:root_t:s0 127.0.0.1:/home/nfs/share1 /mnt/scratch
> 
> 
> 
> generic/285 1s ...  1s
> 
> Ran: generic/285
> 
> Passed all 1 tests
> 
> ```
> 
> On 6/29/22 04:21, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The seek sanity test tries to figure out a file space allocation unit by
> > calling stat and then using an iterative SEEK_DATA method to try to
> > detect a smaller blocksize based on SEEK_DATA's consultation of the
> > filesystem's internal block mapping.  This was put in (AFAICT) because
> > XFS' stat implementation returns max(filesystem blocksize, PAGESIZE) for
> > most regular files.
> > 
> > Unfortunately, for a realtime file with an extent size larger than a
> > single filesystem block this doesn't work at all because block mappings
> > still work at filesystem block granularity, but allocation units do not.
> > To fix this, detect the specific case where st_blksize != PAGE_SIZE and
> > trust the fstat results.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   src/seek_sanity_test.c |   12 +++++++++++-
> >   1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> > index 76587b7f..1030d0c5 100644
> > --- a/src/seek_sanity_test.c
> > +++ b/src/seek_sanity_test.c
> > @@ -45,6 +45,7 @@ static int get_io_sizes(int fd)
> >   	off_t pos = 0, offset = 1;
> >   	struct stat buf;
> >   	int shift, ret;
> > +	int pagesz = sysconf(_SC_PAGE_SIZE);
> >   
> >   	ret = fstat(fd, &buf);
> >   	if (ret) {
> > @@ -53,8 +54,16 @@ static int get_io_sizes(int fd)
> >   		return ret;
> >   	}
> >   
> > -	/* st_blksize is typically also the allocation size */
> > +	/*
> > +	 * st_blksize is typically also the allocation size.  However, XFS
> > +	 * rounds this up to the page size, so if the stat blocksize is exactly
> > +	 * one page, use this iterative algorithm to see if SEEK_DATA will hint
> > +	 * at a more precise answer based on the filesystem's (pre)allocation
> > +	 * decisions.
> > +	 */
> >   	alloc_size = buf.st_blksize;
> > +	if (alloc_size != pagesz)
> > +		goto done;
> >   
> >   	/* try to discover the actual alloc size */
> >   	while (pos == 0 && offset < alloc_size) {
> > @@ -80,6 +89,7 @@ static int get_io_sizes(int fd)
> >   	if (!shift)
> >   		offset += pos ? 0 : 1;
> >   	alloc_size = offset;
> > +done:
> >   	fprintf(stdout, "Allocation size: %ld\n", alloc_size);
> >   	return 0;
> >   
> > 
