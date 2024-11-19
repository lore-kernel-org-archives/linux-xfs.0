Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC701D14FB;
	Tue, 19 Nov 2024 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031121; cv=none; b=gT0r7dlcdS47pay5qq7Jd7fCvV4wEBKvOyQ4DlVvOaH+ZuIN06vvMnD8TE2RnV//vv8atGeXzJJ94tykokasFenG17yyKmHTtav4HOhLybYzYNFjMWt7ECNrBWHq5ACeAl+cxxJQ32IauvC/8gZusKoReXIvlvwTpjPRlW+LCkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031121; c=relaxed/simple;
	bh=mgVaw/gaBpEwRQJg7OQipi80mdgppv5nbX6a4IWxIOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kctg17+ZNgcxhAepCVJFxh4wh2yYYJod9xVTwSl8lCJ5rUOagxJZWxzJrpK8NjbBA/FClRvTMEyOcDd3iX+oz67Og+7fVjZ3xJ+elnuz5MQKYoT/3/yB2rb8f71Z/8Xn+Cr27Ne3aPeB6ABWc59A1dRPA/eBqPGSlOGaA99pU+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUjOAVbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUjOAVbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD27C4CED2;
	Tue, 19 Nov 2024 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732031121;
	bh=mgVaw/gaBpEwRQJg7OQipi80mdgppv5nbX6a4IWxIOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pUjOAVbi5v3vlF5TVcJpEg63HpKxbVrW1ByFJsz5swQ4mOf9QbCzNvQ5Dep5pj7zd
	 y5A5kU+i+CY12D7V5rYcIkmJmy2E1af+Ak6eXwJFMem/Z5RngRho3ZINvfAyhX4CYW
	 SpPkosJO8w6IZ9HNbS4b20svOafhDIvvRYlJh4WX0dMogt5olByPoKBaefKz5OEIdj
	 Kx+PGU1pI8I5qREvGsZ+xucRAKLLZADqef/iQ7nO/SpaqcEZWbBQqbFBnGi+LGit9f
	 QYw7bvn0QzkJEjRxRZApbmBdeSu/Y8TPZYstAjyhz212F2IfSNWe3Wf3UYSCGYhzoz
	 ysR4uDkjSjzqg==
Date: Tue, 19 Nov 2024 07:45:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, zlang@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] generic/251: constrain runtime via time/load/soak
 factors
Message-ID: <20241119154520.GM9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064562.904310.6083759089693476713.stgit@frogsfrogsfrogs>
 <ZzvtoVID2ASv4IM2@dread.disaster.area>
 <Zzwsgzu81kiv5JPB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zzwsgzu81kiv5JPB@infradead.org>

On Mon, Nov 18, 2024 at 10:13:23PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 19, 2024 at 12:45:05PM +1100, Dave Chinner wrote:
> > Question for you: Does your $here directory contain a .git subdir?
> > 
> > One of the causes of long runtime for me has been that $here might
> > only contain 30MB of files, but the .git subdir balloons to several
> > hundred MB over time, resulting is really long runtimes because it's
> > copying GBs of data from the .git subdir.
> 
> Or the results/ directory when run in a persistent test VM like the
> one for quick runs on my laptop.  I currently need to persistently
> purge that for just this test.
> 
> > 
> > I have this patch in my tree:
> > 
> > --- a/tests/generic/251
> > +++ b/tests/generic/251
> > @@ -175,9 +175,12 @@ nproc=20
> >  # Copy $here to the scratch fs and make coipes of the replica.  The fstests
> >  # output (and hence $seqres.full) could be in $here, so we need to snapshot
> >  # $here before computing file checksums.
> > +#
> > +# $here/* as the files to copy so we avoid any .git directory that might be
> > +# much, much larger than the rest of the fstests source tree we are copying.
> >  content=$SCRATCH_MNT/orig
> >  mkdir -p $content
> > -cp -axT $here/ $content/
> > +cp -ax $here/* $content/
> 
> Maybe we just need a way to generate more predictable file system
> content?

How about running fsstress for ~50000ops or so, to generate some test
files and directory tree?

--D
