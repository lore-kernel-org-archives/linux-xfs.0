Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3BE258ED4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900472; cv=none; b=tldsMgq3UPCacAx6rDbIKrITEMplu0SM7p7c9pxWXlTbz+KGLyGeOwQnrjGwiE6+aTVwLkC3CKB3VDn22/Qd6G5El80r/OcVXwu8fI1BFg7s7Y5HvnksrXbybIS3Oko/rXuzAxOZQUhkTmmnG+hFcrQuSEHTO4HSYKa8XF/OTTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900472; c=relaxed/simple;
	bh=1R8eLG1z1i9aqQRgD3l0f2rCn1V8XEvEdNO2X4Rr45Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0mu9F7YAbeWqKBtG0jQj6t3v6jBEohxKR7x4xmw3ZE8I1bI8oTnBKixDR25PfQDxG3kdMkkprzwh3ffeSGVNJ0lx2BDo0+idlnVCFQ6wzE8dF9uQW9lFjpOkU59K372AniQzGjhEI6g5heBDAE4y4acppvOxfOXNRQQUkFNJM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnMK8Tz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnMK8Tz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BDCC4CEF1;
	Tue, 16 Dec 2025 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765900472;
	bh=1R8eLG1z1i9aqQRgD3l0f2rCn1V8XEvEdNO2X4Rr45Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fnMK8Tz61IfeM6E37DkEOVOYwVCLQRYHCGzrmXYFoOIuqtgU0Ekex15NRDhb0Tr9O
	 O4WX0SqHFtDgjMpx9bNry22ARufy9tNMfuCxKebGGeZ9mrjt9rNbq5TsQ3NkcFreLl
	 5Ft8o86V0PrmumyNZk70fJbZnL/kB56IusYHEq1bh7v4Wx587DEd1X8DfVojX1DUMJ
	 ZW/ZoRrqC0BicDQODrKENqAUhQNo9FTgwADiecDu5kE+B4eq0gOkt+0vSLfub2w3Cz
	 wQigyBQGfmpe0jdNuh+if84Qf9VF+sbh+DajJEhXn/3tVgz7/D7fd+NlGUayCnOI8s
	 tb866zj4iYO+w==
Date: Tue, 16 Dec 2025 07:54:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, bfoster@redhat.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251216155431.GP7725@frogsfrogsfrogs>
References: <P_OCd7pNcLvRe038VeBLKmIi6KSgitIcPVyjn56Ucs9A34-ckTtKbjGP08W5TLKsAjB8PriOequE0_FNUOny-Q==@protonmail.internalid>
 <20251215060654.478876-1-hch@lst.de>
 <ffgi6wyu52fnaprwf3yh55zu7w54jnzeujfqhojpevntzfd4an@bpjnajccspt2>
 <5Jo2Clb8CI-sXH9HcivM7ax5k7r_sSb5fXgPjIiDorMYb_ZPsX3AUGt5g3YOaaTH1rFgjRwXz_FjIVfkIe2ViQ==@protonmail.internalid>
 <20251216080618.GA3453@lst.de>
 <tbzmh2fl7vchasnqvosujidfttyftmkhmdt5odmzscdbj2x6qo@ln7n6m5aw7k3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tbzmh2fl7vchasnqvosujidfttyftmkhmdt5odmzscdbj2x6qo@ln7n6m5aw7k3>

On Tue, Dec 16, 2025 at 09:11:13AM +0100, Carlos Maiolino wrote:
> On Tue, Dec 16, 2025 at 09:06:18AM +0100, Christoph Hellwig wrote:
> > On Tue, Dec 16, 2025 at 09:03:42AM +0100, Carlos Maiolino wrote:
> > > >
> > > > +/*
> > > > + * For various operations we need to zero up to one block each at each end of
> > >
> > > 							^^^
> > > 					Is this correct? Or should have it been
> > > 					"one block at each end..." ?
> > >
> > > Not native English speaker so just double checking. I can update it when
> > > applying if it is not correct.
> > 
> > Your version sounds correct.
> > 
> 
> o>

The original version is correct.  If you have 4k fsblocks and a
zerorange request for 8GB - 2 bytes starting at 4097, you'll have to
actually zero 4097-8191 and 8589930496 - 8589934591.  (Almost) one block
each, at each end.

That said, "one block at each end" conveys that adquately in modern day
English usage and people think I'm old fashioned even for uttering the
first version. ;)

(Old fashioned being 1960s :P)

--D
