Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6AE31E10F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 20:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830647; cv=none; b=Lt99J6a3FlyBgewbfRUrqQKh2weZurnHhA4FlKV5UeJ6Z86MaeSFhB79CbjDoziHffu83iAgkljpYo/wcWkRnfFUO7xDtS/U6lgJ2D450IJiuP9xI/oNagA1TV2/e5J0c3IP4QAO+6onhrf8WdzZz7Q8w1t3x7+338LyaTBhYt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830647; c=relaxed/simple;
	bh=yBFbmp+m+3VM/2TE+NfPJphtZbqIj+R7kaVUQCpkjhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPLQI4qsOT/7PHraqEFi1CDoQhoCtqOA+AEOsyfcpa0T5sAmBILfC427D0N1SOi7lgX29MMY3ZnSsqQgHue41QDHwHiCpQbZg1FnujwQzmXWcNP1j6fAxAYz4OPcKbCR1F2fhEIB+hwg3mMs4ISeJECWJlHAo6GKbPgudAttajU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBhOQ3Hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBhOQ3Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A0BC4CEF7;
	Thu, 25 Sep 2025 20:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758830647;
	bh=yBFbmp+m+3VM/2TE+NfPJphtZbqIj+R7kaVUQCpkjhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NBhOQ3HcPz8kTWKcMjPLLfdyzKyBcmlDq1RSE2B7xzjsU8S7A1K8sszSxP6aKdI31
	 Frtm/omb9mO5fSbEga0Q/jadTruJ9BX6nOM1/tonJJAfRG5QucJsKyzHQnnfpk+qrg
	 VfY6h0YkExdCCR4fjFuaRatXVME0IamKtC57SzvPmdZAiCfduMERs/LHn9nm8RoBik
	 nmK03CTxtyLSuLDLdC7sxv4e7cOtRrqATh5D86bdxrfq5wXQZhMEc4fYDGE4f9H1DG
	 sfti/ZONR0IlspE8iw0v1C+vqBth+P+kD2sV4uy/m4G16t3AMP1mSKqEJnVnTRJMGQ
	 xuXFoJt+nbBIQ==
Date: Thu, 25 Sep 2025 13:04:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <20250925200406.GZ8096@frogsfrogsfrogs>
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org>
 <20250924005353.GW8096@frogsfrogsfrogs>
 <aNTuBDBU4q42J03E@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNTuBDBU4q42J03E@infradead.org>

On Thu, Sep 25, 2025 at 12:23:48AM -0700, Christoph Hellwig wrote:
> On Tue, Sep 23, 2025 at 05:53:53PM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 22, 2025 at 10:01:17AM -0700, Christoph Hellwig wrote:
> > > The autoconf maigc looks good (as good as autoconf can look anyway),
> > > but why is this code using strerror_r to start with?  AFAIK on Linux
> > > strerror is using thread local storage since the damn of time, so
> > > just doing this as:
> > > 
> > > 	fprintf(stream, _("%s."), strerror(error));
> > > 
> > > should be perfectly fine, while also simpler and more portable.
> > 
> > But there's no guarantee that the implementation does this, is there?
> > The manpage doesn't say anything like that.
> 
> To me this pretty clear reads that the return string is stable until
> the next call to strerror as long as you only use it in the calling
> thread:
> 
> "The strerror() function returns a pointer to a string that describes
> the error code passed in the argument errnum,  ...
> This string must not be modified by the application, and the returned
> pointer will be invalidated on a subsequent call to strerror() or
> strerror_l(), or if the thread that obtained the string exits.  No
> other library function, including perror(3), will modify this string."

Huh, I don't see "...or if the thread that obtained the string exits" in
my version of the strerror(3) manpage on Debian 12.  For that matter, it
still lists strerror() as MT-Unsafe.

Looking through the manpages git repo, I see that strerror actually does
get changed to MT-Safe in commit 01576f703f820e54602:

    strerror.3: Change strerror() reference from MT-Unsafe to MT-Safe

    The information in this patch was obtained from a glibc upstream patch,
    commit 28aff047818eb1726394296d27b9c7885340bead ("string: Implement
    strerror in terms of strerror_l").

    According to the patch above, for glibc versions >=2.32, strerror() is
    MT-Safe.

    Signed-off-by: Shani Leviim <sleviim@redhat.com>

Then looking through the glibc repository, that 28aff047818e commit
comes from:

https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=28aff047818eb1726394296d27b9c7885340bead;hp=9deec7c8bab24659e78172dd850f4ca37c57940c

which turns strerror into strerror_l.  This commit only appears in glibc
2.32, which appeared in August 2020.  That version first appears in
Debian 12 and RHEL 9, which are still fairly new.  musl apparently has
had strerror call strerror_l since at least 2011.

Has strerror() been designated as thread-safe at a POSIX level, or is
this just an implementation quirk of these two C libraries?  strerror
definitely wasn't thread-safe on glibc when I wrote this program.

--D
