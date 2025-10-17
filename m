Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CA029CB4D;
	Fri, 17 Oct 2025 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760718267; cv=none; b=hkU74jNU0uUCFHFy5cxoYGDzBEg3g8AYlp8PB7MF6j93N/ZiPLGO3WU2Go0KuswKaVTawzFjaNGVozcLn4S6f8RN9R9GXPSho0344jT+Y1+oPDNE1b0IlldX4Kl61gf10Wdvr7lkg/jj4qaN7kRslYQBYUAPTnpTzzG5+rUlTcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760718267; c=relaxed/simple;
	bh=g2VAQggSjsfuUWwNDQen3+j4QFacOmRINM7RXpA0JxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWf4Wutv7P6xjSV1FD76/QAdLB7z13piKChPR1CugKs/Tgo8u5b1n1HIFgt7rYCpMN7eCMQAHKEfgv1VyFqG3fubvxtMPVF0JVT+F4eG/Z/sLUVRw7VF6MUBV4KRFnkjkuzTCILpGtDlIP1i+Y/kAwTvQ2kCfUuMfnr+/dd+9og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gb8rTJDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gb8rTJDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C6BC113D0;
	Fri, 17 Oct 2025 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760718266;
	bh=g2VAQggSjsfuUWwNDQen3+j4QFacOmRINM7RXpA0JxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gb8rTJDlBHJ2XGTeaoPuk4Tt0plMmWU2q8ATNpUTKKVmUPFuj1/WR0q841i6rEJJZ
	 5thGFFNf8DNLy0NdZ33B9YkAtjfTuU2DJ3zPkusfdVkD8LDtMsF8nRqCTsNGSeumue
	 HHYBjfm4uQ0yFOFAo4QrNQMUYZc8lURDsA7hiEPBJyWT2XxJNwk8gyN3/hKvpDnwUe
	 7opyabHO0EcpGz9pEwvdAAsrZKAgxQiW+BSm47v83PxZektYLeXtLzVfVVGI6leUCl
	 eqC+p36kkgpLH1GJv1UAmI60qxBAEcHMZX8D0k+Ug8UmuQwTfMBBZ6PSV154yZ5Zsp
	 MURDAxEyn4VGQ==
Date: Fri, 17 Oct 2025 09:24:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] generic/{482,757}: skip test if there are no FUA
 writes
Message-ID: <20251017162426.GE6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617970.2391029.13902894502531643815.stgit@frogsfrogsfrogs>
 <aPHEmXmseASGsj9h@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPHEmXmseASGsj9h@infradead.org>

On Thu, Oct 16, 2025 at 09:22:49PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 15, 2025 at 09:37:45AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Both of these tests fail if the filesystem doesn't issue a FUA write to
> > a device, but ... there's no requirement that filesystems actually use
> > FUA at all.  For example, a fuse filesystem that writes to the block
> > device's page cache and issues fsync() will not cause the block layer to
> > issue FUA writes for the dirty pages.  Change that to _notrun.
> 
> Hmm, zoned ZXFS never issues FUA and didn't fail.  Oh, these use dm thin
> and thus are _notrun. 

Yep.

> > index 8c114ee03058c6..25e05d7cdb1c0d 100755
> > --- a/tests/generic/482
> > +++ b/tests/generic/482
> > @@ -82,7 +82,7 @@ _log_writes_remove
> >  prev=$(_log_writes_mark_to_entry_number mkfs)
> >  [ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
> >  cur=$(_log_writes_find_next_fua $prev)
> > -[ -z "$cur" ] && _fail "failed to locate next FUA write"
> > +[ -z "$cur" ] && _notrun "failed to locate next FUA write"
> 
> This isn't really the last but the first FUA write we're looking for
> here, right?

Yes, it's looking for the first FUA write after mkfs, which is
(presumably) the first directio O_SYNC write or (more likely) journal
commit.

> >  
> > -[ -z "$cur" ] && _fail "failed to locate next FUA write"
> > +[ -z "$cur" ] && _notrun "failed to locate next FUA write"
> 
> Same here.
> 
> The only reason I'm asking is because if we did this for every write
> we'd kinda defeat the purpose of the test.  But we're only doing it
> to see if any FUA writes exists as far as I can tell, so we should
> be ok.  But it might be worth changing the messages.

"could not locate any FUA write" ?

--D
