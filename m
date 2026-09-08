Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E7385D73;
	Tue,  8 Sep 2026 06:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788849252; cv=none; b=Cp79Shp+j65QMD0E9tWCf6ZMow+fPOFlOWGmbCwtGdDWY03miKPK7BGDhd7/OX6Rq3uRGaLmrVT5Ul5CXcs/aCRAJTE0kTaX1cmWHf4BpfQ3pW1okE5tuW7DVLP1vPHzbQLw9bU45pLdRsgsKHL8cloNMHNCYZTVSz98/qQcQ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788849252; c=relaxed/simple;
	bh=oh948wHwE+92N7A7GHZByuxRaDZZWMpabhyUSnkDyvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isnFJRCW78+2koj5yK9cutUVXwlHUQ95wxlEant3oIoTGmFc+c6raLGiUqhX6gmIZKKM2dTa14ckZwiwYHu455ODrCn1WgzF1n1g9cQ1xjRPuXlaKuQZTZ91FQJn/4JE7ViwmFVFKgQB514Fzm/ZN2OQAwHxyOmdMT4dORj5920=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFwQolio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFwQolio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FE41F00A3E;
	Tue,  8 Sep 2026 06:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788849248;
	bh=uQAtdeCpjEFjK7Mix88SdJFp8UWpForvQAe5vbBazts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFwQolioxiW3Y02xxUGM9pg4abmCVw4EtNka52NS56rCT4pgwECpITZpBaBb7uzVj
	 wWI7HzrFgkHqHOZYJLXFyBc4tAcCKv5RfLFIXit8faKM3CdR+guaZ0vhAFz16fzthi
	 MkL/CjrJm1R4vtxz3/xLhgEYHylebLuoZTTNszGWxvRFX0eTCVKt7UHPLfHxHKDCt2
	 byxEGF+kTzWpCduuTm1WBznHfg9wFgPBoKJK4z/zIxWhMhAM+4MnPSGqPEUvSNpLnT
	 TA1Lat7aNNIaw8HY40E2gAifZOJmaDQQ6iYFggaslcfYyIgMAUx4ZmdUdHlXP7DHLL
	 ywtDwaQH5JwKA==
Date: Tue, 8 Sep 2026 16:33:59 +1000
From: Dave Chinner <dgc@kernel.org>
To: Hongling Zeng <zhongling0719@126.com>
Cc: Hongling Zeng <zenghongling@kylinos.cn>, cem@kernel.org,
	darrick.wong@oracle.com, chandanrlinux@gmail.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: bound logged region access in inode buffer
 recovery
Message-ID: <ap-sV2Cc5U5fNMmo@dread>
References: <20260907080450.314067-1-zenghongling@kylinos.cn>
 <ap8ucHIw-pKLhh9c@dread>
 <6A9F7022.6020206@126.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6A9F7022.6020206@126.com>

On Tue, Sep 08, 2026 at 10:17:06AM +0800, Hongling Zeng wrote:
> 
> 在 2026年09月08日 05:36, Dave Chinner 写道:
> > On Mon, Sep 07, 2026 at 04:04:50PM +0800, Hongling Zeng wrote:
> > > xlog_recover_do_inode_buffer() reads the logged di_next_unlinked field
> > > from a log record buffer at a computed offset:
> > > 
> > >          logged_nextp = item->ri_buf[item_index].iov_base +
> > >                          next_unlinked_offset - reg_buf_offset;
> > >          *buffer_nextp = *logged_nextp;
> > > 
> > > The only protection against reading past the log record buffer are
> > > ASSERT()s, which compile away on non-DEBUG kernels.  The existing
> > > XFS_IS_CORRUPT(*logged_nextp == 0) check also dereferences the pointer
> > > before validating that the computed offset lies within the logged region.
> > > 
> > > A crafted log record can make the computed offset exceed iov_len, causing
> > > an out-of-bounds read from the log record buffer during inode buffer
> > > recovery.
> > > 
> > > Convert the relevant ASSERT-only checks into runtime corruption checks and
> > > verify that the logged di_next_unlinked field lies entirely within the log
> > > iovec before dereferencing it.
> > > 
> > > Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> > <sigh>
> > 
> > I'm going to say what I've said before again here, and it applies to
> > the BLF bitmap range checks patches you posted yesterday, too:
> > 
> > Hacking the same types of region size and range checks into every
> > log item type in an ad-hoc manner is not the right way to address
> > these log item verification issues.
> > 
> > We need to add a robust verification layer to the journal to verify
> > all the journal level metadata (e.g. ophdrs, transaction headers,
> > initial log item regions, per-log item type verification, etc) so
> > that we check *all* the journal items for sanity before we use them.
> > 
> > This is the same architecture we use for metadata (the verifier
> > layer) and it applies to the journal for the same reasons and
> > provides the same benefits (i.e. validate at first access, rest of
> > the code can assume validity and not have to clutter logic with
> > random validity checks to prevent bad behaviour.)
> > 
> > The high level design doc and rough plan I put together last time I
> > brought this up is in the patch below. If you're not willing or able
> > to spent time and tokens on fixing this entire class of problems for
> > everyone, then let please let me know ASAP.
> > 
> > -Dave.
>   Hi Dave,
> 
>   Thanks for the detailed feedback. I understand the concern: the ad-hoc
>   region checks I posted don't address log recovery validation
>   systematically.
> 
>   I'll withdraw the inode buffer and BLF bitmap patches and switch to
>   the design-driven approach. I'll post your patch 5 first (the
>   unchecked ri_buf[ri_cnt-1] in add_to_cont_trans(), the unbounded
>   kvrealloc() there, the missing oh_len alignment check in
>   process_data() - all reachable bugs, no restructuring), then work
>   through the rest of Phase 1.
> 
>   Three points to confirm before coding:

Don't take the design doc as being complete or correct - it's a
working document and really only serves as the initial high level
plan I fleshed out.

Indeed, I implemented a chunk of it yesterday afternoon (i.e.
before I saw your patch this morning) and my findings change quite a
bit of the generic infrastructure to make it handle the transaction
header without having to special case it. So from that perspective,
it's already out of date...

I'll post what I have in the series later this afternoon so you can
get up to speed.

>   1. I don't see a write-side guarantee that a region is split at most
>      once - xlog_write_partial() can emit multiple continuations. So
>      beyond your patch 2 treating the header as a normal accumulated
>      region, note that today a third fragment walks into
>      ri_buf[ri_cnt-1] with ri_cnt == 0 / ri_buf == NULL. Correct?

The iterator structure behind the item decoding should handle
decoding regions split into an arbitrary number of ophdr regions
without issue.

That's kinda the point of it; ensure the region is
fully extracted from the journal before we try to decode any of it.
Hence we have to handle CONTINUE/WAS_CONT regions as partial
additives until we get to the final WAS_CONT region that closes off
the region as a whole.

>   2. For the zero-length first fragment: if this is old-log
>      compatibility only,

Real thing, go look at xlog_write_get_iclog_space() and
consider what happens when the lv_chain passed to xlog_write() gets
it's first iclog with only space for two ophdrs left in it....

>      I'd document it that way and keep the special
>      handling as narrow as possible rather than introducing a generic
>      anonymous item state. Note the doc's ri_in_continuation has no
>      owner at that point since no item exists yet - narrow handling
>      avoids that entirely.

The special case handling for it is awful, and IMO needs to go away
because it is actually buggy and makes it much harder to reason
about what is a valid item in a transaction....

>   3. For testing I'll cover each phase with crafted-log images and run
>      xfstests.

This is why I have been rewriting xfs_logprint in rust: so it has
the same capabilities as xfs_db in terms of being able to walk,
parse and modify individual items in the journal. i.e. to be able to
explicitly fuzz the journal in a systematic, programmable and
reproducable way and hence avoid the need for hundreds of corrupted
images to test all the corner cases....

And, FWIW, the iterator + generic item handling design of the
validator for the kernel code is a fairly close translation of the
layered generic item type verification my new rust logprint code
already uses. 

>      My bigger worry is over-strict validation rejecting valid
>      logs, which only shows up replaying real crash logs - what
>      coverage do you expect there? And should the design doc go in
>      first so the series can reference it?

We have extensive journal recovery stress and validity tests in
fstests (e.g. the recoveryloop group), and so I'm really not worried
about structure verification being too strict. I'd much prefer to
err on the "extremely strict" side right now, and loosen if needed.
I don't think it will be an issue, because if the journal
verification comes across improperly formatted items then it points
to a runtime bug that needs to be fixed, not a journal recovery
issue.

i.e. I'd much prefer we have strict verification because that finds
logic bugs on both sides during testing, that way they do not end up
in production systems...

-Dave.

-- 
Dave Chinner
dgc@kernel.org
