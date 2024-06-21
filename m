Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E095C40856;
	Fri, 21 Jun 2024 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718992404; cv=none; b=mOheDRzKv/CncKpXXjQe9Z/jekMKN6jUkiSGqpVcnFP6bqz2TIq5N4y8/SHTYQZ9qRn4D3mZeWjoAhfLlwFOQK1dy29xUPbecfcHs0gFuYjvUzPhQzdIRunOLUEPWSb1kNIY50mj/ys2dMX850x+mCGtvvzi5/5gUSF0jCih45Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718992404; c=relaxed/simple;
	bh=0fGlCA/L0UocJTiDr0ISItSBNPn3E+Z087jZs97He8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rab1P/LXNKsnH6c0/ZDrODo4LHes5qN15juNfUmeXnK/TXHjFOclz9NjooBDmuVbrnfR3J5/Om8LCWceCS1y1Awbvrk6qsoEdF2pvqqE0vux2tkGV5Q7gt8OeIUfYC3lagQQ/EdU/kJ521GNZpOVfZbknIrSQRF6nYZ+QgQfBRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jkb1wEQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jkb1wEQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE89C2BBFC;
	Fri, 21 Jun 2024 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718992403;
	bh=0fGlCA/L0UocJTiDr0ISItSBNPn3E+Z087jZs97He8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jkb1wEQ61B0c3GubeazrwvvsIzC2WK9TEbkXHyAtLgbGWz4I7/RM1VBpfn7deQ+qN
	 CWzI+NranqLb63CETrOFCX/XBxebRdHBK2JTNhux0jnZ9EDk9D2e9q/DvVy44dMqy1
	 JwO92wd5ZD+QjcRk3qfuQpcl0GEn+ayO73G0btd6Z9BksmSaJ4AmYpulViEAPM7Z9U
	 NfoUPfHt9b5cpCFPOsqI7bSeVJx5b9tjwt0s/VqZvYPVx2b7xj+KytvaHAgtvuqkur
	 c2RoJLglJEoBqP+q+PhyFXAJafGaF2st4BpYmhamZAe+KqTb0mTwH+W3h/yusbuvmG
	 Sn+O1J/REUnzA==
Date: Fri, 21 Jun 2024 10:53:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHBOMB] fstests: catch us up to 6.10
Message-ID: <20240621175323.GH3058325@frogsfrogsfrogs>
References: <20240620205017.GC103020@frogsfrogsfrogs>
 <20240621172034.qemkrzrpxif37tot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621172034.qemkrzrpxif37tot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Jun 22, 2024 at 01:20:34AM +0800, Zorro Lang wrote:
> On Thu, Jun 20, 2024 at 01:50:17PM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > This patchbomb are all the fixes that xfs needs to bring fstests up to
> > date with what's in 6.10-rc.  Except for these two patches:
> > 
> > [PATCHSET v30.7 2/6] fstests: atomic file updates
> > [PATCH 03/11] generic/709,710: rework these for exchangerange vs.
> > [PATCH 04/11] generic/711,xfs/537: actually fork these tests for
> > 
> > everything else in here is fully reviewed and ready for PRs.
> 
> Thanks for big updates!
> 
> This patchset is big, I've merged and pushed all these patches to
> fstests' 'patches-in-queue' branch, feel free to check that.
> 
> I need more time to give them more tests, will try to release fstests
> at this weekend or middle of next week.

<nod> The patch "src/fiexchange.h: update XFS_IOC_EXCHANGE_RANGE
definitions" is going to need another update if Chandan pulls in[1]
before 6.10 closes:

[1] https://lore.kernel.org/linux-xfs/171892459317.3192151.14305994848485102437.stgit@frogsfrogsfrogs/

But I'll let that go upstream before I make the change to fstests.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> 
> 
