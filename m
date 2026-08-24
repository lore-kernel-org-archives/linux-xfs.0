Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EB337F8D6;
	Mon, 24 Aug 2026 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787593227; cv=none; b=B+5UKDDTN/ozE6r/Mf7zWSk5BYSV9/KEz76yxM3T4O6aXhL6Xz5/CxMoIawZ0s520xmAkEFOdWFS2TWnYIamAd7iFcZun8eY4Ii9dxa248DjQLLX74/gs0zTDEe7ONA8m8HUTqCz/0EGfKbnZf/I3+yCoi6d9Jc1vyVttluxtIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787593227; c=relaxed/simple;
	bh=55kI32tDNrjHBaaaJ4tWRwTHm4/9/Rowh2ArkjVNKWY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZNfpGsJOUnKmBHsTOWx8nXoJaqh6GsGTJhuJ4/qhK+sh301XidlZ63sY9vOUjQjfSody6IeAa+ooFy4fUlrUDtXGXS8wi4OtQwP5VOwAbgfaykg0iSRkLEh5ml6APqrOrxe1rF8frx+nA7Lq/VQ0GxZioUU0DH9MGfUX7hSVms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUmD1Azl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUmD1Azl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 006B11F000E9;
	Mon, 24 Aug 2026 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787593210;
	bh=2ZyDA8O8zMvhHE3pKQeaf+/ce2DZP/bcSZSSN+nEib0=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=aUmD1AzlR0zkBoqfPEcIDD1iYm/NXsWbKPYBhTBmZTqDY3zM/ZVbjL7M0xcoB6Krd
	 ZEGMZNxZ5K3SsajwB3YQKdJua+XcEXeKrXLhh5yv6lV/GNkF0Do7iK9i9I9W7O96dn
	 qbqzGxjft4Ym/wm8gipLFDz8ttKthhc1IiX2llHMIzf4I9OGPpS7cB5WZAy6EVAqcd
	 YvcAGK0fhcqSFB7C50DNYjsayL4B5Nt9dVksf6Ci5OzTQMzzor28RufoW1MxBPh3FS
	 K0r1VA8oFtE3+8Jzvk5E3O9DfqQtYMlkumDZhEWHO2fEFvGXZDzAgfOA38nAkLFRcj
	 IYIK8eqYIUSFA==
Date: Mon, 24 Aug 2026 10:40:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: qsa@qualys.com, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic: regression test for refluxfs fixes
Message-ID: <20260824174009.GQ839663@frogsfrogsfrogs>
References: <20260821235155.GK839663@frogsfrogsfrogs>
 <aoxJrUoCCy5Kxgh8@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxJrUoCCy5Kxgh8@zlang-mailbox>

On Mon, Aug 24, 2026 at 10:05:25PM +0800, Zorro Lang wrote:
> On Fri, Aug 21, 2026 at 04:51:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Regression test for refluxfs as found by Qualys.
> > 
> > Reported-by: qsa@qualys.com
> > Co-developed-by: qsa@qualys.com
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> > v2: add co-author credits
> > ---
> 
> Hi Darrick,
> 
> I just gave this patch a try on linux v7.2+ which contains the commit
> 2f4acd0fcd862e, but the test still fails as shown below on both xfs
> and btrfs. Did I miss anything?
> 
> root@bogon:~/git/linux# git tag --contains 2f4acd0fcd862e
> v7.2
> v7.2-rc4
> v7.2-rc5
> v7.2-rc6
> v7.2-rc7
> 
> root@bogon:~/git/xfstests-dev# ./check generic/1956
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
> MKFS_OPTIONS  -- -f /dev/sdc1
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch
> 
> generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
>     --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
>     +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:41:51.884222239 +0800
>     @@ -1,2 +1,2 @@
>      QA output created by 1956
>     -corruption not observed
>     +unknown outcome 126
>     ...
>     (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
> 
> HINT: You _MAY_ be missing kernel fix:
>       2f4acd0fcd862e xfs: resample the data fork mapping after cycling ILOCK
> 
> Ran: generic/1956
> Failures: generic/1956
> Failed 1 of 1 tests
> 
> root@bogon:~/git/xfstests-dev# ./check generic/1956
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
> MKFS_OPTIONS  -- /dev/sdc1
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch
> 
> generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
>     --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
>     +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:44:35.654443414 +0800
>     @@ -1,2 +1,2 @@
>      QA output created by 1956
>     -corruption not observed
>     +unknown outcome 126
>     ...
>     (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
> Ran: generic/1956
> Failures: generic/1956
> Failed 1 of 1 tests
> 
> 
> >  .gitignore             |    1 
> >  src/Makefile           |    2 
> >  src/refluxfs.c         |  461 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1956     |   58 ++++++
> >  tests/generic/1956.out |    2 
> >  5 files changed, 523 insertions(+), 1 deletion(-)
> >  create mode 100644 src/refluxfs.c
> >  create mode 100755 tests/generic/1956
> >  create mode 100644 tests/generic/1956.out
> >
> 
> [snip]
> 
> > +#ifndef FICLONE
> > +#define FICLONE _IOW(0x94, 9, int)
> > +#endif
> > +#ifndef XFS_SUPER_MAGIC
> > +#define XFS_SUPER_MAGIC 0x58465342
> > +#endif
> > +
> > +#define BLK 4096
> 
> This's a hard code, what if the fs blocksize or pagesize isn't 4096?

It reproduced the problem on 1k and 64k fsblocks before I'd patched the
kernel.  AFAICT "BLK" really just means the application buffer size for
doing IO and doesn't actually have to match the fs blocksize.

> > +
> > +/* ---- configuration (overridable via CLI) --------------------------------- */
> > +static const char *target_path   = "/etc/passwd";
> > +static const char *clone_dir     = "/var/tmp";
> > +static int         nr_writers    = 32;
> > +static int         nr_pressure   = 8;
> > +static int         budget_s      = 300;
> > +
> 
> [snip]
> 
> > +
> > +#if 0
> > +static int is_xfs(const char *p)
> > +{
> > +    struct statfs s;
> > +    if (statfs(p, &s)) return -1;
> > +    return s.f_type == XFS_SUPER_MAGIC;
> > +}
> > +#endif
> 
> If this's useless, how about remove them?
> 
> > +
> > +/* FIEMAP: is the target's first extent already shared (refcount > 1)?
> > + * If so the race can never see refcount==1. */
> > +static int target_first_extent_shared(void)
> > +{
> 
> [snip]
> 
> > +#if 0
> > +    /* 2. target on XFS */
> > +    int x = is_xfs(target_path);
> > +    if (x < 0) die(1, "statfs target", NULL);
> > +    if (!x) {
> > +        BAD("target is not on XFS (f_type != XFS_SUPER_MAGIC).");
> > +        INFO("RefluXFS only affects XFS with reflink=1 (mkfs.xfs default since");
> > +        INFO("xfsprogs 5.1.0; backported by Red Hat for RHEL 8 GA).  Default root");
> > +        INFO("fs on RHEL/CentOS/Rocky/Alma/OL/CloudLinux 8+, Fedora Server 31+,");
> > +        INFO("Amazon Linux 2023.");
> > +        exit(1);
> > +    }
> > +    OK("target is on XFS");
> > +#endif
> 
> Same

Will remove both of these dead code sections.

> > +
> > +    /* 3. clone_dir on the same superblock */
> > +    if (access(clone_dir, W_OK)) die(1, "clone dir not writable",
> > +        "Need a writable directory on the SAME XFS filesystem as the target.");
> 
> [snip]
> 
> > +static void *pressure(void *arg)
> > +{
> > +    char p[600];
> > +    snprintf(p, sizeof p, "%s/press.%d", workdir, (int)(intptr_t)arg);
> > +    int fd = open(p, O_RDWR|O_CREAT|O_TRUNC, 0600);
> > +    if (fd < 0) return NULL;
> > +    char b = 0;
> > +    while (!atomic_load(&stop)) {
> > +        /* return values irrelevant -- goal is XFS log traffic, not the data */
> > +        (void)!pwrite(fd, &b, 1, 0);
> > +        (void)!ftruncate(fd, BLK);
> > +        fdatasync(fd);
> > +        (void)!ftruncate(fd, 0);
> 
> As this's a generic test case, the pressure() works for XFS CIL, does it work
> for other filesystems?

Neither of them (btrfs, ocfs2) are vulnerable to this problem because
they don't have the design flaw in the first place.  So I don't know how
to answer that question.

It's probably not necessary to run this testcase against other
filesystems but as there's nothing xfs-specific in the test case, why
not let them run on the others?

--D
