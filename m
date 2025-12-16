Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B0B347BCA
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 08:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872677; cv=none; b=vEq+v5jlezlPdtCkZUEdAMUZgTpt/QzmxMt8FeH4fnR1CS3q1WnsHcH7L8QJYGtyeQMeQhTnFfDJbYdWE7yUJbRgKXR8jKLeDUCmCowW9jJ+E6K/RcYgaviLFoIuB/jbnotMfooiQrBhMdQKEcUO4WtOHpFUVGC/CTe10K15lwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872677; c=relaxed/simple;
	bh=kJMyatMtt9TAPxxhYkwYZazEt7Tn3vs+HSEwzZGK9z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNeFN925on9eAF+8cn0PyJXqO0poEwsujiezMUw1EPKaPD3szYKIRiA5FcLDpURJNgqcG1AzRvbFlIgBGlAqK9zt7o2Cq1GUIuPThIaL2XuDWwhkWBw6EZprc6yYVsgPZn6NYxgSM0YLtXgXK2d5t4lLg0KvbMsux6yQPRNQajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sc9lFvkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sc9lFvkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D1CC113D0;
	Tue, 16 Dec 2025 08:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872677;
	bh=kJMyatMtt9TAPxxhYkwYZazEt7Tn3vs+HSEwzZGK9z4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sc9lFvkNjJz13DWrynVGwtFHmYrMPPB5NHvpIHuVhQaQJMOfx6o0wo69eWw3bHOYc
	 eup1X5YpAcmcfGtkYHMLGTr6HAXdpdL493Bvgv2iPi2NvwolPBE0LPAmLydSXyp1Cw
	 /wGi3cIqrBeDsQXwce9Ia0SDHYwJro0wOdc1iXFWLJ6uZdLsDHfEKcgxqx01IdHI1+
	 EQGFqBAXJXuxJ18wRzekeg1wSQzF5RphJLBFx6Nc+cMgue5Qsba5h0KmCCY7X4K76a
	 U2dhTxEbvElu7U1KrDafwDiPNfRXTLZuz+FKI25vcVd/KNOE5Y4TwmfOQXaUW1MQFS
	 +HIb1+vdW+lww==
Date: Tue, 16 Dec 2025 09:11:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <tbzmh2fl7vchasnqvosujidfttyftmkhmdt5odmzscdbj2x6qo@ln7n6m5aw7k3>
References: <P_OCd7pNcLvRe038VeBLKmIi6KSgitIcPVyjn56Ucs9A34-ckTtKbjGP08W5TLKsAjB8PriOequE0_FNUOny-Q==@protonmail.internalid>
 <20251215060654.478876-1-hch@lst.de>
 <ffgi6wyu52fnaprwf3yh55zu7w54jnzeujfqhojpevntzfd4an@bpjnajccspt2>
 <5Jo2Clb8CI-sXH9HcivM7ax5k7r_sSb5fXgPjIiDorMYb_ZPsX3AUGt5g3YOaaTH1rFgjRwXz_FjIVfkIe2ViQ==@protonmail.internalid>
 <20251216080618.GA3453@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216080618.GA3453@lst.de>

On Tue, Dec 16, 2025 at 09:06:18AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 16, 2025 at 09:03:42AM +0100, Carlos Maiolino wrote:
> > >
> > > +/*
> > > + * For various operations we need to zero up to one block each at each end of
> >
> > 							^^^
> > 					Is this correct? Or should have it been
> > 					"one block at each end..." ?
> >
> > Not native English speaker so just double checking. I can update it when
> > applying if it is not correct.
> 
> Your version sounds correct.
> 

o>
