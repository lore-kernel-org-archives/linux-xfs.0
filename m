Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BD721146C
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783006364; cv=none; b=YFgMzUPGJACs3FHyydk8M6EABKt9AsrBLSNufNo1fGTFr9EQm+TX2qhxhu2YaZXH+jvyaPwyWxLNocGS3rrygXU9Q4WLtk9tHePeTsFgO1klynE3A4yk9eoSG8rHdauK6hWGFPG8WmggcHF7+ub4afyHKTW07BlE8+SIspZIzos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783006364; c=relaxed/simple;
	bh=/EINKj2WSSFCMW63KhlSwrmYWsH1xIuocYly2REBb+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTDRfT+Hw99YYWP3VwN+/ktZ1pwIGz4AshX2wCqhANiRp80ZRUq9rm5usWYbm3nFqwmWvoCSHrqil/f4sw8rjTcrJuxKQRF9aTtW70koIwm+qXHIfITyd8FErBnXHzGNID1aa6GOLzq5rOpnEiA1GSspCPZCsV0mV0Ror05sdOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGnUZ8nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGnUZ8nh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4F0041F000E9;
	Thu,  2 Jul 2026 15:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006363;
	bh=BDvJjoPIBH2zXl8u3TwCcJG8PyHK3PAYji0UfDsmbv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AGnUZ8nhhJxQgxrNtEezOMeAKs+38bqeaa/O4+UN++xIcMXgFPsQhB4cTkzmNX7ti
	 Cw0E7jMZqY85DmlNyUtITjhGEAUYY9Z2ydvY4IKv8eG8b7exqlFhpdqfydLiD8sZI1
	 abiN/bw0gypsIseACpY3KmOHBMy64a9O/yjT0PdmraxcktpX6R0/YLV1qmUhJKO49P
	 5XUJ8+uM3rwXnsd1qgydHK+iokMvV2E5tx4t9TygiIwSXv3uDir343Cr3UlZqns3ve
	 YGlpOlp4j8GX2zToucLVTzKc1VTXji1N6uDKTJpNxLFP6kf9q6Hx4HehQq8VxI3mhF
	 e+yzvb2t06FQw==
Date: Thu, 2 Jul 2026 08:32:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Weiming Shi <bestswngs@gmail.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 3/3] xfs: fail recovery on a committed log item with
 no regions
Message-ID: <20260702153242.GB9392@frogsfrogsfrogs>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-5-bestswngs@gmail.com>
 <20260701220838.GI6526@frogsfrogsfrogs>
 <akZD87nbm6q0KXrP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZD87nbm6q0KXrP@infradead.org>

On Thu, Jul 02, 2026 at 03:56:51AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 03:08:38PM -0700, Darrick J. Wong wrote:
> > I agree that a totally empty log item is a sign of corruption, or at
> > least something going seriously wrong.  Can the runtime log code ever be
> > tricked into emitting a bare transaction header?
> 
> I don't think so.  This looks like an automated search for bugs in the
> parser.  And while I'm happy about tightening up all parsing, I still
> think this should be stated in the commit log much more clearly.

Yes, it could at least state whether this is a code change because the
author hit a crash in practice vs. running some tool that pointed out a
gap and emitted a reproducer.

--D
