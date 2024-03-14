Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E486119
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 23:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710459822; cv=none; b=MlVt9ZpoxYESrrwaOG/WU98gLV4mzxC+ONemWkfK5nKqiglqm60zF3IykHP4jx+Log8jj/RCnH+hctStbT7tsggnHdpWuxETrscQXX0XOKz83ipnwme2+0daciXSdWdufBoBi7f4GvwGA4fkqxM+Z5SvfauXwRudSeu30LNUidg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710459822; c=relaxed/simple;
	bh=kDZ9uetFuUFNFdtwi15LeMyZZIvrRGL0hfr5nPKyqDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVZWo3F5QptcLa7mY4VmCI/zq4NuAspFW/B8tFw+y+pvW4fbzufI49PuyD7YYRJS6LGy28xTtE3eV+9EBITUJWK0nd4kRkSuZEilocdcaIONuf0rHui/4gI6PDhh/kGKt4fHPzmKcL4qFGpBUB4/9DgYGLOY0Dnnlrs7SqZ23n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iK3sUbMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iK3sUbMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38BC433F1;
	Thu, 14 Mar 2024 23:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710459821;
	bh=kDZ9uetFuUFNFdtwi15LeMyZZIvrRGL0hfr5nPKyqDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iK3sUbMxmZ6cwntsM2aFHvZgKuhq5JBsDdmK9TctQ2z/9/E2ee1ShegC4MgklI+cl
	 ScWcn30nfk4oLOVlcYaV6XRYYNRTH+kPRDp5S0ZKw37Krw19YWr8MCHbAb3o+aZz0G
	 wsqUmFe64clnMlCRzwXuMOmT3uctZ0Jr0301Vkkw+fjpybDYBC2uPoy6YcF1m6b+cE
	 WjNTeCfM+utdDzgTlgaQZF9RwxmAfWW+20ut14qtvwZLomGlKE/fkkwjYIits3l1bS
	 rxCWTt1Uqemmnpm+s3Us4HcTDuzJVh8b7KAIjQ+pp6IX8Ux2wc/i1gAg74ka8zzbYJ
	 CdQ4eLlC6UYLw==
Date: Thu, 14 Mar 2024 16:43:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] mkfs: fix log sunit rounding when external logs
 are in use
Message-ID: <20240314234341.GS1927156@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430586.2061422.6975814186247298641.stgit@frogsfrogsfrogs>
 <ZfIhy9OapF4MKkQy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfIhy9OapF4MKkQy@infradead.org>

On Wed, Mar 13, 2024 at 02:59:39PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 12, 2024 at 06:50:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Due to my heinous nature, I set up an external log device with 4k LBAs
> > using this command:
> > 
> > # losetup -b 4096 -o 4096 --sizelimit $(( (128 * 1048576) - 4096 )) -f /dev/sdb
> > # blockdev --getsize64 /dev/loop0
> > 134213632
> > 
> > This creates a log device that is slightly smaller than 128MB in size.
> > Next I ran generic/054, which sets the log sunit to 256k and fails:
> 
> Can we wire this exact mkfs command line up as an xfstests instead of
> requiring a very unused setup to trigger it with the existing test?

I'll have a look at creating an fstests for this sort of thing, unless
the LBS folks already have one handy?

--D

> The xfstests patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
