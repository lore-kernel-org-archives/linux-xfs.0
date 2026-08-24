Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1C9430CE5;
	Mon, 24 Aug 2026 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787580333; cv=none; b=n4OLCEnR3f0qnvlHyqfWMJhX1he+2zq3JsMiObZsKdJFKZ6eXmE3/Klz6GrFdkE1B78sfDKQ1n/j37q3yF64PaLiFfkY804K6kc2B6NoTZ5C8mYXa+1iFZrgkSzXz52uxt3OYxDFLx6v0mI9JAQb27Oka7HRzamUnYOhdvKpWC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787580333; c=relaxed/simple;
	bh=TVNuWznbi7z461LCNQ0VjLK7cUNilIMQSiLkD3Jk/a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFbQcRlRzXNh7xHDCLFkr4tzRkx5tMN0rcJjZvJVSeVUgK/SjDP5sDEd0N87ZLcGnM9QPT8lmkiWdQiqGyXG/qZ9766QPVtKFXHzutLq7YW54qKnsjMfazHOm/cMBygFHHhsaATRorKkOomU1gZZ6Gc9meRuEnLxgBXs/fUHpmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9JnrWsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9JnrWsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD341F000E9;
	Mon, 24 Aug 2026 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787580331;
	bh=rf07oECWzg7mA/SbvL9XANAEcqw84tovmNvakjtYx30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m9JnrWsrSN/c8jJlw7IiR2dLMG9AwIGOnnqwVWk6H+/hsj+9pSIJ7XmGUFgrR+Pj9
	 w+v2RpRsFIdcOO0dzztKp81+wLyHBfnSIuOcFMB6JKgzAnZ9wxYdRNvcJCb+6QSuy/
	 fYvivPQK/+u5/w01+3/oyqQb2nCbFB0MAmb3A+N1VX2BBr9jmDBpDZ8xSpyEG25pdT
	 /ZYy1Q33zN/+jgP49uc5xRpRVVR7sBfvJNKYi6edhOM7IZ3R7ae/V4Y/n1gOy3PqGz
	 SCfJwVOgAV7fLE6aexKXDJZqtMD3GcfqsOZkhpxbuSMlkuIatSrtXCgTypLPjcFaGd
	 h6yXrcf/bXcxg==
Date: Mon, 24 Aug 2026 22:05:25 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: qsa@qualys.com, fstests <fstests@vger.kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] generic: regression test for refluxfs fixes
Message-ID: <aoxJrUoCCy5Kxgh8@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, qsa@qualys.com, 
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
References: <20260821235155.GK839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821235155.GK839663@frogsfrogsfrogs>

On Fri, Aug 21, 2026 at 04:51:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Regression test for refluxfs as found by Qualys.
> 
> Reported-by: qsa@qualys.com
> Co-developed-by: qsa@qualys.com
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> v2: add co-author credits
> ---

Hi Darrick,

I just gave this patch a try on linux v7.2+ which contains the commit
2f4acd0fcd862e, but the test still fails as shown below on both xfs
and btrfs. Did I miss anything?

root@bogon:~/git/linux# git tag --contains 2f4acd0fcd862e
v7.2
v7.2-rc4
v7.2-rc5
v7.2-rc6
v7.2-rc7

root@bogon:~/git/xfstests-dev# ./check generic/1956
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
MKFS_OPTIONS  -- -f /dev/sdc1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch

generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
    --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
    +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:41:51.884222239 +0800
    @@ -1,2 +1,2 @@
     QA output created by 1956
    -corruption not observed
    +unknown outcome 126
    ...
    (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)

HINT: You _MAY_ be missing kernel fix:
      2f4acd0fcd862e xfs: resample the data fork mapping after cycling ILOCK

Ran: generic/1956
Failures: generic/1956
Failed 1 of 1 tests

root@bogon:~/git/xfstests-dev# ./check generic/1956
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 bogon 7.2.0-mainline+ #3 SMP PREEMPT_DYNAMIC Mon Aug 24 20:34:26 CST 2026
MKFS_OPTIONS  -- /dev/sdc1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sdc1 /mnt/scratch

generic/1956       - output mismatch (see /root/git/xfstests-dev/results//generic/1956.out.bad)
    --- tests/generic/1956.out  2026-08-24 14:19:18.790104900 +0800
    +++ /root/git/xfstests-dev/results//generic/1956.out.bad    2026-08-24 21:44:35.654443414 +0800
    @@ -1,2 +1,2 @@
     QA output created by 1956
    -corruption not observed
    +unknown outcome 126
    ...
    (Run 'diff -u /root/git/xfstests-dev/tests/generic/1956.out /root/git/xfstests-dev/results//generic/1956.out.bad'  to see the entire diff)
Ran: generic/1956
Failures: generic/1956
Failed 1 of 1 tests


>  .gitignore             |    1 
>  src/Makefile           |    2 
>  src/refluxfs.c         |  461 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1956     |   58 ++++++
>  tests/generic/1956.out |    2 
>  5 files changed, 523 insertions(+), 1 deletion(-)
>  create mode 100644 src/refluxfs.c
>  create mode 100755 tests/generic/1956
>  create mode 100644 tests/generic/1956.out
>

[snip]

> +#ifndef FICLONE
> +#define FICLONE _IOW(0x94, 9, int)
> +#endif
> +#ifndef XFS_SUPER_MAGIC
> +#define XFS_SUPER_MAGIC 0x58465342
> +#endif
> +
> +#define BLK 4096

This's a hard code, what if the fs blocksize or pagesize isn't 4096?

> +
> +/* ---- configuration (overridable via CLI) --------------------------------- */
> +static const char *target_path   = "/etc/passwd";
> +static const char *clone_dir     = "/var/tmp";
> +static int         nr_writers    = 32;
> +static int         nr_pressure   = 8;
> +static int         budget_s      = 300;
> +

[snip]

> +
> +#if 0
> +static int is_xfs(const char *p)
> +{
> +    struct statfs s;
> +    if (statfs(p, &s)) return -1;
> +    return s.f_type == XFS_SUPER_MAGIC;
> +}
> +#endif

If this's useless, how about remove them?

> +
> +/* FIEMAP: is the target's first extent already shared (refcount > 1)?
> + * If so the race can never see refcount==1. */
> +static int target_first_extent_shared(void)
> +{

[snip]

> +#if 0
> +    /* 2. target on XFS */
> +    int x = is_xfs(target_path);
> +    if (x < 0) die(1, "statfs target", NULL);
> +    if (!x) {
> +        BAD("target is not on XFS (f_type != XFS_SUPER_MAGIC).");
> +        INFO("RefluXFS only affects XFS with reflink=1 (mkfs.xfs default since");
> +        INFO("xfsprogs 5.1.0; backported by Red Hat for RHEL 8 GA).  Default root");
> +        INFO("fs on RHEL/CentOS/Rocky/Alma/OL/CloudLinux 8+, Fedora Server 31+,");
> +        INFO("Amazon Linux 2023.");
> +        exit(1);
> +    }
> +    OK("target is on XFS");
> +#endif

Same

> +
> +    /* 3. clone_dir on the same superblock */
> +    if (access(clone_dir, W_OK)) die(1, "clone dir not writable",
> +        "Need a writable directory on the SAME XFS filesystem as the target.");

[snip]

> +static void *pressure(void *arg)
> +{
> +    char p[600];
> +    snprintf(p, sizeof p, "%s/press.%d", workdir, (int)(intptr_t)arg);
> +    int fd = open(p, O_RDWR|O_CREAT|O_TRUNC, 0600);
> +    if (fd < 0) return NULL;
> +    char b = 0;
> +    while (!atomic_load(&stop)) {
> +        /* return values irrelevant -- goal is XFS log traffic, not the data */
> +        (void)!pwrite(fd, &b, 1, 0);
> +        (void)!ftruncate(fd, BLK);
> +        fdatasync(fd);
> +        (void)!ftruncate(fd, 0);

As this's a generic test case, the pressure() works for XFS CIL, does it work
for other filesystems?

Thanks,
Zorro
