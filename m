Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765FE33260D;
	Thu, 16 Jul 2026 19:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784231969; cv=none; b=UdqaWZeVkECtrKyqhdUw/0iMsdjQktxMvlUd1i48kTfL0sgYIIbIqbHlXN2ZBxY0tVQmERFp1L4CLYrYXTuQ4GjBPTjdSkG7i1J5X+6hqj7B6+ULkhMKBFvvEfaS4y4Mpa1L//AFTmpQw4j7MwznU6+zftml5t9gar1xFFAAi/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784231969; c=relaxed/simple;
	bh=e94VUESWRh10ox0dSJWICLcD4X4i3YoDD5wD6dGXvOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GB2lK+4xpw06azBlhCVCO52PTyqYrDv9pQaAhzpRlzTHsZHpww2V77Tf3qeQ1Ez8wtEzb5DAp/10rOhAI4HvfvYNuzu0ZF4xeRgxDySFUcy3WgHbsGXiyx4+/VrlzQiyd0syU0Zxv4tl8b2tsYj6nDznyzohevGEdeOVxXt8waI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVZEHiii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVZEHiii"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 06C1D1F000E9;
	Thu, 16 Jul 2026 19:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784231968;
	bh=wCQekIZgJFBaxgInYwz9JYvXUh2Xj5X1mi6ffcmNrDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kVZEHiiiiXHjbpgeJ6PAkYa1q7/D77u3J0uK17xukff30HGFLj3XiJ4yWCfMVlwWj
	 TzWv6/jMJz/8A0vMzX3Q58TP8ASR7ZthRiC/o2hrpHefdSqMeNxBcPkQdBKxcR+O0f
	 5xyjrdFxqU/ZHs7L5XmsfZmuufddN2kVEj00aiIjoUnCthll/hLBj7T2n/5zbC8zWX
	 pBeqoPXGU50wg5AQssXpGj81yNk3nqt4QdM9/9b3J6FLeYm3RHjXsJ9UC14a1FMsou
	 Qu6Pl4OR0rOsVccjFpCeKj0xNPKSHfURp+aNfg+PAWsTepRWveveYjh04n/gjv8D7U
	 A1AM3wpqcRrnw==
Date: Thu, 16 Jul 2026 12:59:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Avinesh Kumar <avinesh.kumar@suse.com>
Cc: cem@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] libfrog: make cmn_err() emit each message atomically
 to avoid torn output
Message-ID: <20260716195927.GL7398@frogsfrogsfrogs>
References: <20260716151329.GA7371@frogsfrogsfrogs>
 <20260716194723.191090-1-avinesh.kumar@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716194723.191090-1-avinesh.kumar@suse.com>

On Thu, Jul 16, 2026 at 09:45:49PM +0200, Avinesh Kumar wrote:
> From: Avinesh Kumar <avinesh.kumar@suse.com>
> 
> fstests xfs/033 fails sporadically with a spurious blank line in the
> xfs_repair output:
> 
> - output mismatch (see /opt/xfstests/results//xfs/033.out.bad)
>     --- tests/xfs/033.out	2026-06-24 15:52:51.000000000 -0400
>     +++ /opt/xfstests/results//xfs/033.out.bad	2026-07-14 18:54:46.582495041 -0400
>     @@ -103,6 +103,7 @@
>      Phase 3 - for each AG...
>              - scan and clear agi unlinked lists...
>              - process known inodes and perform inode discovery...
>     +
>      bad magic number 0xffff on inode INO
>      bad version number 0xffffffff on inode INO
>      inode identifier 18446744073709551615 mismatch on inode INO
> 
> Root cause is in cmn_err() (libfrog/util.c), which emits a message
> and its newline as two separate writes to unbuffered stderr.
> xfs_repair's threads all share stderr. If one is preempted between the
> two writes, another thread's line lands in between:
> 
> (snips from `cat -A 033.raw`) -
> Phase 3 - for each AG...$
>         - scan and clear agi unlinked lists...$
>         - process known inodes and perform inode discovery...$
> Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000        - agno = 0$
> $
> bad CRC for inode 128$
> bad magic number 0x0 on inode 128$
> 
> which should be like -
> 
> Phase 3 - for each AG...$
>         - scan and clear agi unlinked lists...$
>         - process known inodes and perform inode discovery...$
> Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000$
>         - agno = 0$
> bad CRC for inode 130$
> bad magic number 0x0 on inode 130$
> 
> _filter_repair() strips the noise line it glued onto but not the lone
> newline, which then fails the golden diff.
> 
> Make the two writes atomic.
> 
> do_error() in xfs_repair.c also has same issue, fix that too.
> 
> Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>

Looks good to me, hopefully this will cut down on the random xfs_repair
errors in fstests.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v2: fix the do_error() in xfs_repair.c too.
> 
>  libfrog/util.c      | 2 ++
>  repair/xfs_repair.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/libfrog/util.c b/libfrog/util.c
> index 5bae5bab..3b6df917 100644
> --- a/libfrog/util.c
> +++ b/libfrog/util.c
> @@ -116,8 +116,10 @@ cmn_err(int level, char *fmt, ...)
>  	va_list	ap;
>  
>  	va_start(ap, fmt);
> +	flockfile(stderr);
>  	vfprintf(stderr, fmt, ap);
>  	fputs("\n", stderr);
> +	funlockfile(stderr);
>  	va_end(ap);
>  }
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 6b97a806..dd758ebc 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -458,10 +458,12 @@ do_error(char const *msg, ...)
>  {
>  	va_list args;
>  
> +	flockfile(stderr);
>  	fprintf(stderr, _("\nfatal error -- "));
>  
>  	va_start(args, msg);
>  	vfprintf(stderr, msg, args);
> +	funlockfile(stderr);
>  	if (dumpcore)
>  		abort();
>  	exit(1);
> -- 
> 2.55.0
> 
