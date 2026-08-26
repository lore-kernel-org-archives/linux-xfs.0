Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3403B37D11A
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 04:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787720034; cv=none; b=be8qdOeDbKCds7WzvXpIDdHcSPS7mk3uVolMJwpYxicDTeCKLX3FVUcXIAqCkCrP0+DWproJi1ARoZ21GV2KtA2HrqPMxvuhX/RanVlqasG94IyHvp122QkzNyYPj6SJEhKd6ne2j/3ImWAzAYSoPb6ZDeRDHuV/3ruLp2n0c2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787720034; c=relaxed/simple;
	bh=l30LThf8m/e1Hv70FB7FruqZS7ZLWOIEXuoAxM3pAVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BtIuOh9qXz2MWxmbXI+atqUwoKaRXdo9lVUOCh3zCtBadMWLZ9DqQdUProw8R6EM/Jpe8t+RPcb4Z1AZmgleF5BGWFKS+1paLczv2l3uwU/4IsIoUdKC+/6/Vu0tPSpWOGLq+e1SBS6fYoy8CUMoS2h/TaZV9b4P9hq4qaLKCwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhQksS62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhQksS62"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C7CE1F000E9;
	Wed, 26 Aug 2026 04:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787720018;
	bh=TLIfiPwOgHFUkGQCpwEL1X0wREBZRkUFr1x2CcQPzyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dhQksS62NpJ5UlKtHWhJqtc6Jrp7O8whcSQbkLmtoVvXmOKjfhfpHrPmzsSOBr4AD
	 6pCrdzoJ2Wcj4WVH8gklWfvRlvzAgbCsBI20+exXjR7YK0IWbXNr1iNRCraRbzMtsu
	 oTlmEkOQtmSLoP6DFlAIqCEQlnmGajPYEGYaMHLnzCROHR3aHbijHXOher2MVzKqdN
	 2bNFo4xCN5MTPJkRGmfpZKLk4fLCGfPQkuACI0WyukspmDNFkIHUtfC8HeS7FZ3kMi
	 vTU/6OLOiHpT8UOMXooTTFdEOQ6LFHO5obA7FH48EMoQeT3e8N1WQmh/VQQosFrt61
	 NeF0S1ZX0OUqA==
Date: Tue, 25 Aug 2026 21:53:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <20260826045337.GA2114998@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
 <178760940784.944084.16150563988327141422.stgit@frogsfrogsfrogs>
 <20260825063214.GE24324@lst.de>
 <20260825234001.GY6072@frogsfrogsfrogs>
 <20260826044601.GB14936@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826044601.GB14936@lst.de>

On Wed, Aug 26, 2026 at 06:46:01AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 25, 2026 at 04:40:01PM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 25, 2026 at 08:32:14AM +0200, Christoph Hellwig wrote:
> > > On Mon, Aug 24, 2026 at 10:35:41PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > A longstanding weakness of the metapath repair code is that it can only
> > > > reattach non-directories to the metadata directory tree.  Let's fix that
> > > 
> > > Why was this not done before?  Why is it possible now?  Testcase?
> > 
> > I straight up forgot to implement it.
> 
> Heh..
> 
> > And right now there's no way to
> > mount a filesystem with a broken subdirectory (your choices are
> > /rtgroups or /quota) so it didn't stand out.
> 
> Maybe add this to the commit log?

Ok will do.

--D
