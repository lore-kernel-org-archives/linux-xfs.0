Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFCD79C0;
	Sun, 28 Jul 2024 02:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722133489; cv=none; b=Ox6oWlyZDf6R1wfosMpNdUNoOY3AAdj/9LxDMswMgoNgYgTtlWOGyEtQU4RDrPuRsVTaG1ZVIERH0b80YBuJKOXTy55ahBzs/cm5osmMLeVR8JC5NCCwTL8+1wlir3/kbvlG6Wb1hroymcyfAl87QrW89YrEFyP/Dzbm5kagcF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722133489; c=relaxed/simple;
	bh=pD0bdrmPs9ZOHAzIsfQ6APZUUAphlkHt65tJtrzLRGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9nyX2FgkmSTQ55Tu6VaXx0CiiivKaYKtW5ArQrZ9HU2TVNwjrxbZJBM6yc7KyOx7XALedVHlHShpD37Q10WAf0ESMIobOLS9roSn3DWxke5Tc8KKmtp2l09my8ltxEQZuL0YzWb+jjMOWwSBzth6650Ez9y6MUT3wSheBPwb9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2/nOEko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2/nOEko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C568FC32781;
	Sun, 28 Jul 2024 02:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722133488;
	bh=pD0bdrmPs9ZOHAzIsfQ6APZUUAphlkHt65tJtrzLRGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E2/nOEkoRA8yTnV5MLD6J7rKUymsOSjLgARa0f9e63WDIWww+VHBUxGm6z5or41R7
	 o/TtLk1z5rSYRSHFIyUS6eA5lToeQz0mqfxkL7sHZpCm1npuZBu7SrKs862gabsCle
	 zh2KULqaqYhCywGqriYOUR8L+03NYaalAiRSv2nYbaBSfVBR2L+h+NOSAAyXy1lmlm
	 57KWZO/K8g8ZKqjQUXTkQZYACiK+NYTZpdxick8IWwt2SQAlrW0AG6jmXHIoYyrg/o
	 bZiM8E3V1EcJAJe5b+Y7miLPKUEOxyUgT51SRQB1cyBXNBosIqY6TYHn4IsRuVRwLv
	 VcHt8zBHxBq8Q==
Date: Sat, 27 Jul 2024 19:24:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240728021016.GF612460@frogsfrogsfrogs>
References: <20240723000042.240981-1-hch@lst.de>
 <20240723035016.GB3222663@mit.edu>
 <20240723133904.GA20005@lst.de>
 <20240723141724.GB2333818@mit.edu>
 <20240726162014.GQ103020@frogsfrogsfrogs>
 <20240726171145.GA27555@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726171145.GA27555@lst.de>

On Fri, Jul 26, 2024 at 07:11:45PM +0200, Christoph Hellwig wrote:
> On Fri, Jul 26, 2024 at 09:20:14AM -0700, Darrick J. Wong wrote:
> > The big question I have is: for at least the standard -g all runs, does
> > this decrease the number of tests selected?
> 
> For a -g auto / -g quick run without any extra options it does not
> change test coverage at all.  It only kicks in if you add "problematic"
> mkfs options.

<nod> In that case, I think I'm ok with letting this graduate to
for-next to see what happens :)

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D
