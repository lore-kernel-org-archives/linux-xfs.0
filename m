Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8BB3876DE;
	Mon, 24 Aug 2026 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787598915; cv=none; b=Njnu5VPtCdZyQyu05zviz5TdXPKxnQfz+yu21OsrP8dQHS8xDsPImLppKf/+jVRabvTGvpzqkyoVjIPiISkiIEpLd3YER6vgLPHOMUaajriTQezd1FJ47l26AS1VQDV9hLwwJnWbT+npQbuY1w7f/+3qKZXSj7shMxe/MnGFu/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787598915; c=relaxed/simple;
	bh=XZF7N1jFJFTNOW1+CS4UfpWeS59jrU81jgKDsAnXusM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYYwBqTQSwl1OpPkKHK+Ztiu17YHUquLg/umHVKUvxylqcHWfXrPeLoUsl9DNd5JLqzz55mEstnXvXEokHtJKmN8mi48TtAidiTJkmm6CpMldJ47C+tV1AkBTfZ1hYdN3WgGYJoQee8XcYQINbWIMya7r34EJTfy45n1rseUYvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MR+50KeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MR+50KeM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B09611F000E9;
	Mon, 24 Aug 2026 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787598913;
	bh=V1RprWgGZ5QINkw1UKt/X6Gm7lRJn3ds8skj2erkq2M=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=MR+50KeMBNtqx/nym1782Mz107ifViKCDE99yA4i3yiyhvELBcSeYMUgDs4afXcqH
	 MGR+znIjIMtEOmnkj++W/Jtc0GgtG4HVsHY3CwjLpmySXkmYRrkPHvwNtE/SIrudfu
	 Gh+Dfhdx2AYkwe31CdWNLL9k4dwVLN1xYhQK54oGC7fyP2MyB+7wGYD46Y2XI7u9xp
	 u8PJF1FtJsl/GfOgIlUTNCMeqx/Ty+Qzo8r4VXKui1cF5AZ97cUenNbst2cl4wr/sh
	 uUhvhnElIckZ3zyFmFNC87Efh4fwGKDpTTaIXqD5ZaoeX0NrOJqSXZToOdVrJOu2VM
	 zdOSa+3zUVCNA==
Date: Mon, 24 Aug 2026 12:15:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: qsa@qualys.com, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic: regression test for refluxfs fixes
Message-ID: <20260824191513.GS839663@frogsfrogsfrogs>
References: <20260821235155.GK839663@frogsfrogsfrogs>
 <aoxJrUoCCy5Kxgh8@zlang-mailbox>
 <20260824164516.GF6110@frogsfrogsfrogs>
 <aoyH0JUd6Bh8Oj8t@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoyH0JUd6Bh8Oj8t@zlang-mailbox>

On Tue, Aug 25, 2026 at 02:15:31AM +0800, Zorro Lang wrote:
> On Mon, Aug 24, 2026 at 09:45:16AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 24, 2026 at 10:05:25PM +0800, Zorro Lang wrote:
> > > On Fri, Aug 21, 2026 at 04:51:55PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Regression test for refluxfs as found by Qualys.
> > > > 
> > > > Reported-by: qsa@qualys.com
> > > > Co-developed-by: qsa@qualys.com
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > > v2: add co-author credits
> > > > ---
> > > 
> > > Hi Darrick,
> > > 
> > > I just gave this patch a try on linux v7.2+ which contains the commit
> > > 2f4acd0fcd862e, but the test still fails as shown below on both xfs
> > > and btrfs. Did I miss anything?
> > > 
> > > root@bogon:~/git/linux# git tag --contains 2f4acd0fcd862e
> > > v7.2
> > > v7.2-rc4
> > > v7.2-rc5
> > > v7.2-rc6
> > > v7.2-rc7
> > > 
> > > root@bogon:~/git/xfstests-dev# ./check generic/1956
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
> > > MKFS_OPTIONS  -- -f /dev/sdc1
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch
> > > 
> > > generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
> > >     --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
> > >     +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:41:51.884222239 +0800
> > >     @@ -1,2 +1,2 @@
> > >      QA output created by 1956
> > >     -corruption not observed
> > >     +unknown outcome 126
> > 
> > 126 is probably su trying to communicate that it couldn't actually run
> > refluxfs.  _require_test_program should have _notrun if the binary
> > didn't build, so ... I don't know what's going on here.  Does
> > $seqres.full have anything interesting to say?  Or does su'ing to fsgqa
> > not work?
> 
> Wow, you reminded me! The /root/ directory doesn't has 'x' permission for others,
> so this $qa_user can't run /root/git/xfstests-dev/src/refluxfs . My bad, now
> it works :)

Oh.

> > 
> > (FWIW it works fine on my system even with large block size)
> 
> It's fine with large block size? In my review comments below, I questioned
> the hardcoded "BLK=4096". While it might not fail on an XFS with a non-4k
> block size, it probably won't trigger the bug either on an unfixed kernel,
> right?

It should on a 1k fsblock filesystem the kernel will just mash
four blocks.  Though I guess for a 64k fsblock filesystem it'll fall
back to pagecache writes and fail to trigger it.

I dunno.  Changing BLK to 65536 seems to make it reproduce reliably here
on every fsblock size between 1k and 64k so I'll make that modification
and resend it.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > >     ...
> > >     (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
> > > 
> > > HINT: You _MAY_ be missing kernel fix:
> > >       2f4acd0fcd862e xfs: resample the data fork mapping after cycling ILOCK
> > > 
> > > Ran: generic/1956
> > > Failures: generic/1956
> > > Failed 1 of 1 tests
> > > 
> > > root@bogon:~/git/xfstests-dev# ./check generic/1956
> > > FSTYP         -- btrfs
> > > PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
> > > MKFS_OPTIONS  -- /dev/sdc1
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch
> > > 
> > > generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
> > >     --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
> > >     +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:44:35.654443414 +0800
> > >     @@ -1,2 +1,2 @@
> > >      QA output created by 1956
> > >     -corruption not observed
> > >     +unknown outcome 126
> > >     ...
> > >     (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
> > > Ran: generic/1956
> > > Failures: generic/1956
> > > Failed 1 of 1 tests
> > > 
> > > 
> > > >  .gitignore             |    1 
> > > >  src/Makefile           |    2 
> > > >  src/refluxfs.c         |  461 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/1956     |   58 ++++++
> > > >  tests/generic/1956.out |    2 
> > > >  5 files changed, 523 insertions(+), 1 deletion(-)
> > > >  create mode 100644 src/refluxfs.c
> > > >  create mode 100755 tests/generic/1956
> > > >  create mode 100644 tests/generic/1956.out
> > > >
> > > 
> > > [snip]
> > > 
> > > > +#ifndef FICLONE
> > > > +#define FICLONE _IOW(0x94, 9, int)
> > > > +#endif
> > > > +#ifndef XFS_SUPER_MAGIC
> > > > +#define XFS_SUPER_MAGIC 0x58465342
> > > > +#endif
> > > > +
> > > > +#define BLK 4096
> > > 
> > > This's a hard code, what if the fs blocksize or pagesize isn't 4096?
> > > 
> > > > +
> > > > +/* ---- configuration (overridable via CLI) --------------------------------- */
> > > > +static const char *target_path   = "/etc/passwd";
> > > > +static const char *clone_dir     = "/var/tmp";
> > > > +static int         nr_writers    = 32;
> > > > +static int         nr_pressure   = 8;
> > > > +static int         budget_s      = 300;
> > > > +
> > > 
> > > [snip]
> > > 
> > > > +
> > > > +#if 0
> > > > +static int is_xfs(const char *p)
> > > > +{
> > > > +    struct statfs s;
> > > > +    if (statfs(p, &s)) return -1;
> > > > +    return s.f_type == XFS_SUPER_MAGIC;
> > > > +}
> > > > +#endif
> > > 
> > > If this's useless, how about remove them?
> > > 
> > > > +
> > > > +/* FIEMAP: is the target's first extent already shared (refcount > 1)?
> > > > + * If so the race can never see refcount==1. */
> > > > +static int target_first_extent_shared(void)
> > > > +{
> > > 
> > > [snip]
> > > 
> > > > +#if 0
> > > > +    /* 2. target on XFS */
> > > > +    int x = is_xfs(target_path);
> > > > +    if (x < 0) die(1, "statfs target", NULL);
> > > > +    if (!x) {
> > > > +        BAD("target is not on XFS (f_type != XFS_SUPER_MAGIC).");
> > > > +        INFO("RefluXFS only affects XFS with reflink=1 (mkfs.xfs default since");
> > > > +        INFO("xfsprogs 5.1.0; backported by Red Hat for RHEL 8 GA).  Default root");
> > > > +        INFO("fs on RHEL/CentOS/Rocky/Alma/OL/CloudLinux 8+, Fedora Server 31+,");
> > > > +        INFO("Amazon Linux 2023.");
> > > > +        exit(1);
> > > > +    }
> > > > +    OK("target is on XFS");
> > > > +#endif
> > > 
> > > Same
> > > 
> > > > +
> > > > +    /* 3. clone_dir on the same superblock */
> > > > +    if (access(clone_dir, W_OK)) die(1, "clone dir not writable",
> > > > +        "Need a writable directory on the SAME XFS filesystem as the target.");
> > > 
> > > [snip]
> > > 
> > > > +static void *pressure(void *arg)
> > > > +{
> > > > +    char p[600];
> > > > +    snprintf(p, sizeof p, "%s/press.%d", workdir, (int)(intptr_t)arg);
> > > > +    int fd = open(p, O_RDWR|O_CREAT|O_TRUNC, 0600);
> > > > +    if (fd < 0) return NULL;
> > > > +    char b = 0;
> > > > +    while (!atomic_load(&stop)) {
> > > > +        /* return values irrelevant -- goal is XFS log traffic, not the data */
> > > > +        (void)!pwrite(fd, &b, 1, 0);
> > > > +        (void)!ftruncate(fd, BLK);
> > > > +        fdatasync(fd);
> > > > +        (void)!ftruncate(fd, 0);
> > > 
> > > As this's a generic test case, the pressure() works for XFS CIL, does it work
> > > for other filesystems?
> > > 
> > > Thanks,
> > > Zorro
> > 
> 
