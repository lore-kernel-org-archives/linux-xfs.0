Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFA930ACEB
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297983; cv=none; b=E3LoVKWcSyrOLl5KVinC+mbXVFukf2GEEmxlUQUkVs2hUj7jHGB/YuVVrNJ6KAAjBXmJnM6n6nFlqRlZZtewdwolX5vE+T2TFFFDrKpP3JSlV6cltabPippoc5EGcDVu7Bo6/tUKPiFFMhgAhipx4GinZ7a/NGbQqt7mbn9VWFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297983; c=relaxed/simple;
	bh=MlXSUiFaknWMs24JcO3DSj6b1RgMu4Qsz36afjomLRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuJChvI9eCsRqB4OjUNTnFZRCgyiAPHJ0cYv0aj+GSV2VL8hDYDEuE3J6a9RH4q0c67+1UT13InGXJsqGZYYLw+dPRrCifFj4OEj6PsXyMNhOb0YXYdlx9/Urfgt8oNA+zfEIodQvRs0GhKs76prpl7mJhv54fFnRVHbeBsAkt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljrvm5VP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljrvm5VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACD7C4CEF0;
	Fri, 19 Sep 2025 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758297982;
	bh=MlXSUiFaknWMs24JcO3DSj6b1RgMu4Qsz36afjomLRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ljrvm5VPUr9mK11efHd+ddaljSzvc8SKxibCgDVhu8zabW3TwiP9iqYfBVe53YHSN
	 /8mSZUwsdSNmAnOofbcrJ27FRygmXY0l6rwTyxJhSBKH2Iiys3+ELb5a1M1mmCETI8
	 0mxoQPq4MBF6ebBFCXkU5Wo3OXJxXCM7qgoVy0mBJcJIusWfyzrWst+rZ5fr6S9UdL
	 V98gz+I5BksvydqSGNJHlkxoHlbA7cso+amI0cAK4c93ZT++xC5A4bZDgZBrOLmjws
	 M37ch8tj46NYtWUlOrbcS4IwrhuYmzCj290+eNOHOZD2zedHlN1CX/Rav+xgIh6Sze
	 4ALbZJiEV0VTw==
Date: Fri, 19 Sep 2025 09:06:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "A. Wilcox" <AWilcox@wilcox-tech.com>,
	Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: fix strerror_r usage yet again
Message-ID: <20250919160622.GM8096@frogsfrogsfrogs>
References: <20250918194836.GK8096@frogsfrogsfrogs>
 <aM1tAlLshkg7Hi3b@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aM1tAlLshkg7Hi3b@infradead.org>

On Fri, Sep 19, 2025 at 07:47:30AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 18, 2025 at 12:48:36PM -0700, Darrick J. Wong wrote:
> > "Fix" this standards body own goal by casting the return value to
> > intptr_t and employing some gross heuristics to guess at the location of
> > the actual error string.
> 
> That really makes things worse.  I think we'll just want ifdefs for the
> two versions if there is no better option.

But what is there to #ifdef on?  _GNU_SOURCE is always included in
CFLAGS by builddefs.in even if we're not building against GNU libc
and doesn't define any new symbols so you can figure out which version
you got:

/* Reentrant version of `strerror'.
   There are 2 flavors of `strerror_r', GNU which returns the string
   and may or may not use the supplied temporary buffer and POSIX one
   which fills the string into the buffer.
   To use the POSIX version, -D_XOPEN_SOURCE=600 or -D_POSIX_C_SOURCE=200112L
   without -D_GNU_SOURCE is needed, otherwise the GNU version is
   preferred.  */
# if defined __USE_XOPEN2K && !defined __USE_GNU
/* Fill BUF with a string describing the meaning of the `errno' code in
   ERRNUM.  */
#  ifdef __REDIRECT_NTH
extern int __REDIRECT_NTH (strerror_r,
			   (int __errnum, char *__buf, size_t __buflen),
			   __xpg_strerror_r) __nonnull ((2))
    __attr_access ((__write_only__, 2, 3));
#  else
extern int __xpg_strerror_r (int __errnum, char *__buf, size_t __buflen)
     __THROW __nonnull ((2)) __attr_access ((__write_only__, 2, 3));
#   define strerror_r __xpg_strerror_r
#  endif
# else
/* If a temporary buffer is required, at most BUFLEN bytes of BUF will be
   used.  */
extern char *strerror_r (int __errnum, char *__buf, size_t __buflen)
     __THROW __nonnull ((2)) __wur  __attr_access ((__write_only__, 2, 3));
# endif

I tried turning off GNU_SOURCE but that broke the build even worse and I
don't feel like spending a whole lot of time fixing up all the damage
for the sake of a supporting an alt libc that I don't know how to build
against and don't much care about.

I suppose configure could detect which version you're getting, and set
its own #define that would enable us to #ifdef the callsite.  But this
"same symbol, different return types" is a whole mess of stupidity, to
say nothing of advisory feature enablement via preprocessor defines.

Anyway, v2 on its way.

--D
