Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806A621ABD7;
	Mon, 24 Aug 2026 20:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787602731; cv=none; b=FkYn1yKEw7otspgK+h8b9BPy7ToVeg/EeNVtweQZo3zWhL86pi4+AMzZeUxBzePugq3vSrs2nCbcni7QCNaWXBjgMG/6ARxga/fToCoNS11PKh2+1fz5J4emkOSUkxr1ezeC47YranFSpfDDVrLsuFPP+XTWDbSjbrBJkNtHwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787602731; c=relaxed/simple;
	bh=/q8W6S6uIgQo63fj6qEhvOjCrN8PUyRD5MCnPirFPzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdUvOHY/ATOTwC5w9kFGCbG0XWxu9DF+l6H2xcOZR6COy8Fsrzkpp4EuG5t3HGVe848CKOCVy9yYVb6Yo6YOB8MshlmQgEE+hq5fmxGREfY05PA8I6JpgOjMtbYmq3gMTIj/25/zNBWpOoQOXvnxZJ1vqveWuK4x5mYK6KjBAtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2WaMxgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2WaMxgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2851F000E9;
	Mon, 24 Aug 2026 20:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787602729;
	bh=uSd/couIh7A+T5jJ/4jYwP4E+iBNjDjaknoUCZlHFDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h2WaMxgOkpvl+9iYyV+wNultqwRS3qc//b6N1B00Ac+69+rUmDzPUYLfZBt9bW+Rs
	 pNmu+6kmoG9MD7Oi58uUEO9KEdiO0JOptAxHteSePfh4/hknizqRAYszahySoCjS/i
	 x6e17GLVaFCGVZpyf2dJn/UuTBelHamNlFK1Pf7ASpLxfwmNdtQjkggVh6/ZKXayCf
	 bhGyo5fSoPWL3TjUKslOIkpE1vG9J4hNIAP27+y4JjADyAA/k5nlXJYD3ubs4NUiYh
	 JCLjFy4V2IOZPudMOiUZpWPd6Mo4L3BgAJJEXQjJ8WNiboI6h+SeT+6/XJSlALK1OO
	 nds2icEYcuvVA==
Date: Tue, 25 Aug 2026 04:18:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: qsa@qualys.com, fstests <fstests@vger.kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic: regression test for refluxfs fixes
Message-ID: <aoyhsTq7abQSSDnQ@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, qsa@qualys.com, 
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20260821235155.GK839663@frogsfrogsfrogs>
 <aoxJrUoCCy5Kxgh8@zlang-mailbox>
 <20260824164516.GF6110@frogsfrogsfrogs>
 <aoyH0JUd6Bh8Oj8t@zlang-mailbox>
 <20260824191513.GS839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824191513.GS839663@frogsfrogsfrogs>

On Mon, Aug 24, 2026 at 12:15:13PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 25, 2026 at 02:15:31AM +0800, Zorro Lang wrote:
> > On Mon, Aug 24, 2026 at 09:45:16AM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 24, 2026 at 10:05:25PM +0800, Zorro Lang wrote:
> > > > On Fri, Aug 21, 2026 at 04:51:55PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Regression test for refluxfs as found by Qualys.
> > > > > 
> > > > > Reported-by: qsa@qualys.com
> > > > > Co-developed-by: qsa@qualys.com
> > > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > > ---
> > > > > v2: add co-author credits
> > > > > ---
> > > > 
> > > > Hi Darrick,
> > > > 
> > > > I just gave this patch a try on linux v7.2+ which contains the commit
> > > > 2f4acd0fcd862e, but the test still fails as shown below on both xfs
> > > > and btrfs. Did I miss anything?
> > > > 
> > > > root@bogon:~/git/linux# git tag --contains 2f4acd0fcd862e
> > > > v7.2
> > > > v7.2-rc4
> > > > v7.2-rc5
> > > > v7.2-rc6
> > > > v7.2-rc7
> > > > 
> > > > root@bogon:~/git/xfstests-dev# ./check generic/1956
> > > > FSTYP         -- xfs (debug)
> > > > PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
> > > > MKFS_OPTIONS  -- -f /dev/sdc1
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch
> > > > 
> > > > generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
> > > >     --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
> > > >     +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:41:51.884222239 +0800
> > > >     @@ -1,2 +1,2 @@
> > > >      QA output created by 1956
> > > >     -corruption not observed
> > > >     +unknown outcome 126
> > > 
> > > 126 is probably su trying to communicate that it couldn't actually run
> > > refluxfs.  _require_test_program should have _notrun if the binary
> > > didn't build, so ... I don't know what's going on here.  Does
> > > $seqres.full have anything interesting to say?  Or does su'ing to fsgqa
> > > not work?
> > 
> > Wow, you reminded me! The /root/ directory doesn't has 'x' permission for others,
> > so this $qa_user can't run /root/git/xfstests-dev/src/refluxfs . My bad, now
> > it works :)
> 
> Oh.
> 
> > > 
> > > (FWIW it works fine on my system even with large block size)
> > 
> > It's fine with large block size? In my review comments below, I questioned
> > the hardcoded "BLK=4096". While it might not fail on an XFS with a non-4k
> > block size, it probably won't trigger the bug either on an unfixed kernel,
> > right?
> 
> It should on a 1k fsblock filesystem the kernel will just mash
> four blocks.  Though I guess for a 64k fsblock filesystem it'll fall
> back to pagecache writes and fail to trigger it.
> 
> I dunno.  Changing BLK to 65536 seems to make it reproduce reliably here
> on every fsblock size between 1k and 64k so I'll make that modification
> and resend it.

I just reproduced it on XFS with a 1024 block size. Apologies for the delay,
the reproduce rate on my side was quite low, so I ran it in a `while true`
loop and finally triggered the bug (I'm still waiting for the 65536 blocksize
xfs testing result).

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > >     ...
> > > >     (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
> > > > 
> > > > HINT: You _MAY_ be missing kernel fix:
> > > >       2f4acd0fcd862e xfs: resample the data fork mapping after cycling ILOCK
> > > > 
> > > > Ran: generic/1956
> > > > Failures: generic/1956
> > > > Failed 1 of 1 tests
> > > > 
> > > > root@bogon:~/git/xfstests-dev# ./check generic/1956
> > > > FSTYP         -- btrfs
> > > > PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
> > > > MKFS_OPTIONS  -- /dev/sdc1
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch
> > > > 
> > > > generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
> > > >     --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
> > > >     +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:44:35.654443414 +0800
> > > >     @@ -1,2 +1,2 @@
> > > >      QA output created by 1956
> > > >     -corruption not observed
> > > >     +unknown outcome 126
> > > >     ...
> > > >     (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
> > > > Ran: generic/1956
> > > > Failures: generic/1956
> > > > Failed 1 of 1 tests
> > > > 
> > > > 
> > > > >  .gitignore             |    1 
> > > > >  src/Makefile           |    2 
> > > > >  src/refluxfs.c         |  461 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/generic/1956     |   58 ++++++
> > > > >  tests/generic/1956.out |    2 
> > > > >  5 files changed, 523 insertions(+), 1 deletion(-)
> > > > >  create mode 100644 src/refluxfs.c
> > > > >  create mode 100755 tests/generic/1956
> > > > >  create mode 100644 tests/generic/1956.out
> > > > >
> > > > 
> > > > [snip]
> > > > 
> > > > > +#ifndef FICLONE
> > > > > +#define FICLONE _IOW(0x94, 9, int)
> > > > > +#endif
> > > > > +#ifndef XFS_SUPER_MAGIC
> > > > > +#define XFS_SUPER_MAGIC 0x58465342
> > > > > +#endif
> > > > > +
> > > > > +#define BLK 4096
> > > > 
> > > > This's a hard code, what if the fs blocksize or pagesize isn't 4096?
> > > > 
> > > > > +
> > > > > +/* ---- configuration (overridable via CLI) --------------------------------- */
> > > > > +static const char *target_path   = "/etc/passwd";
> > > > > +static const char *clone_dir     = "/var/tmp";
> > > > > +static int         nr_writers    = 32;
> > > > > +static int         nr_pressure   = 8;
> > > > > +static int         budget_s      = 300;
> > > > > +
> > > > 
> > > > [snip]
> > > > 
> > > > > +
> > > > > +#if 0
> > > > > +static int is_xfs(const char *p)
> > > > > +{
> > > > > +    struct statfs s;
> > > > > +    if (statfs(p, &s)) return -1;
> > > > > +    return s.f_type == XFS_SUPER_MAGIC;
> > > > > +}
> > > > > +#endif
> > > > 
> > > > If this's useless, how about remove them?
> > > > 
> > > > > +
> > > > > +/* FIEMAP: is the target's first extent already shared (refcount > 1)?
> > > > > + * If so the race can never see refcount==1. */
> > > > > +static int target_first_extent_shared(void)
> > > > > +{
> > > > 
> > > > [snip]
> > > > 
> > > > > +#if 0
> > > > > +    /* 2. target on XFS */
> > > > > +    int x = is_xfs(target_path);
> > > > > +    if (x < 0) die(1, "statfs target", NULL);
> > > > > +    if (!x) {
> > > > > +        BAD("target is not on XFS (f_type != XFS_SUPER_MAGIC).");
> > > > > +        INFO("RefluXFS only affects XFS with reflink=1 (mkfs.xfs default since");
> > > > > +        INFO("xfsprogs 5.1.0; backported by Red Hat for RHEL 8 GA).  Default root");
> > > > > +        INFO("fs on RHEL/CentOS/Rocky/Alma/OL/CloudLinux 8+, Fedora Server 31+,");
> > > > > +        INFO("Amazon Linux 2023.");
> > > > > +        exit(1);
> > > > > +    }
> > > > > +    OK("target is on XFS");
> > > > > +#endif
> > > > 
> > > > Same
> > > > 
> > > > > +
> > > > > +    /* 3. clone_dir on the same superblock */
> > > > > +    if (access(clone_dir, W_OK)) die(1, "clone dir not writable",
> > > > > +        "Need a writable directory on the SAME XFS filesystem as the target.");
> > > > 
> > > > [snip]
> > > > 
> > > > > +static void *pressure(void *arg)
> > > > > +{
> > > > > +    char p[600];
> > > > > +    snprintf(p, sizeof p, "%s/press.%d", workdir, (int)(intptr_t)arg);
> > > > > +    int fd = open(p, O_RDWR|O_CREAT|O_TRUNC, 0600);
> > > > > +    if (fd < 0) return NULL;
> > > > > +    char b = 0;
> > > > > +    while (!atomic_load(&stop)) {
> > > > > +        /* return values irrelevant -- goal is XFS log traffic, not the data */
> > > > > +        (void)!pwrite(fd, &b, 1, 0);
> > > > > +        (void)!ftruncate(fd, BLK);
> > > > > +        fdatasync(fd);
> > > > > +        (void)!ftruncate(fd, 0);
> > > > 
> > > > As this's a generic test case, the pressure() works for XFS CIL, does it work
> > > > for other filesystems?
> > > > 
> > > > Thanks,
> > > > Zorro
> > > 
> > 
> 
