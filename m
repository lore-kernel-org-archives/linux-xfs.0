Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026A3647
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 03:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721706634; cv=none; b=iLi/Hty/1Pp+LJZpzvsW9rJ4rDGX5BMiTwh6IRj1L7pUJrtUJ5bmYrNnG/1+WZH10n5b4BsKN3LuzuhTVZAI/vyd4j2/xb/htEkQYLTisxa2vr6lmVJRT3QQPpeHg7mpL2Rdhpz74Jcdtlb24ydp3q2LrB9o9YzlJKJjHz6awJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721706634; c=relaxed/simple;
	bh=VL+antW8I5iiercs/9/FXba3cPA2BzESZqTAC/vV92o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXio7woMFMkxonICPiHmWWOXWFTMaLYeTSsJu4tVHMZ9xuEw0Kd5IqlG1E7SftM9hhSsVArHeGpaYZx3OgWPMuICJQ3TPT4f3FGbJP4w7R+M5qbUnf4WZXKfSkaQcDT6pWtHdGGUgcqAlbQBtwzV6hcE/EozSrKWCUw9hytZGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=F/QkXuDB; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="F/QkXuDB"
Received: from cwcc.thunk.org (pool-173-48-115-17.bstnma.fios.verizon.net [173.48.115.17])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 46N3oHZO018818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jul 2024 23:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1721706619; bh=7/wgPEIdjHjNGqUp1ggxMxPVaWpfsNlSZfq2UMcBUFs=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=F/QkXuDBCFqCo8pnF59EQJ92Obp+l+FzJFzZwo2pUiOnOoVqeKrDdluHmrVDF5jnn
	 iws0QXqWp88+JAOThp1JrKtH5oU9mBVKcgUWacMWQgHh+MSAllgLNKoZX+KmxuIEjt
	 RYXB7KIhUkOAFodWrkAczy0aQciL4TjU91a5tSFKgCLlNGyoAAKr92Ztp1OgvyZ5uc
	 YzAzq4NmI8EFVohjduM9TJeYBzX3Fw3E+HPZhPUS9wO8Dr9Lg1mR6/zgWp3x8nFZoA
	 RkxAAIZFigXXV2Dhz//U0YYv84hRzSwJN+YqAnGyzGH4tr1tVdX8jvHqCVtvuwm+iL
	 Nh5hiUJV5NLZQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id DF2CA15C0300; Mon, 22 Jul 2024 23:50:16 -0400 (EDT)
Date: Mon, 22 Jul 2024 23:50:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240723035016.GB3222663@mit.edu>
References: <20240723000042.240981-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723000042.240981-1-hch@lst.de>

On Mon, Jul 22, 2024 at 05:00:31PM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> I've been running some tests with forced large log sizes, and forced
> sector sizes, and get a fair amount of failures because these options
> collide with options forced by the tests themselves.  The series here was
> my attempt to fix this by not failing the tests in this case but _notrun
> them and print the options that caused them to fail.

Yeah, it's a bit of a mess.  It's not been an issue for ext4 because
mkfs.ext4 allows options specified later in the command-line to
override earlier ones.

> So what could we do instead?  We might distinguish better between tests
> that just want to create a scratch file system with $MKFS_OPTIONS from
> the xfstests config, and those (file system specific ones) that want
> to force very specific file system configurations.  How do we get
> there?

There's a third possibility, which is sometimes the test might
explicitly want the mkfs options to be merged together.  For example,
in the ext4/4k configuration we have "-b 4096", while the ext4/1k
confiuration option we might have "-b 1024".  And we might want to
have that *combined* with a test which is enabling fscrypt feature, so
we can test fscrypt with a 4k block size, as well as fsvrypt with a 1k
blocksize.

That being said, that doesn't always make sense, and sometimes the
combination doesn't make any sense.

It's not clear what the best solution should be.

     	       	    	     - Ted
