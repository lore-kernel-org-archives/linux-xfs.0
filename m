Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BC5197A69
	for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2024 20:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719521661; cv=none; b=UnYx+RRF7/UXclSkubLMBOzcMooTVDrmkSZs2S/k8te5WK8Fi7mAxH5H6wxO5zwjaCpCdikYMQvxF71A8FL7PST8Pp3NQv2oz2ccf0UghxCY4YNOtarZErzM2N52hmyGf03cDp7LfUgmMvkm0HeuU/JkHZRqUZ3iN63AT3T+cLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719521661; c=relaxed/simple;
	bh=S5kpsKUA760oBfksIxZImnjnle7WVz+EDeOigirg4W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q37aDsYt0YNl/0jZo4U+WhRYP0jqc7wsPpMOQKU60k6Kba+ALHZBTWmqBrAH50tnkOAL3e69ZVTkSllpAiE+QXtAuLr7gbp9iOfHllSgPI1dxxitH/cbjSV1uogrd9JnS1Mz8srpbc+qHwRTWaA9dydURt32H+Cr55E93lilDiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQFs1lF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQFs1lF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8074C2BBFC;
	Thu, 27 Jun 2024 20:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719521660;
	bh=S5kpsKUA760oBfksIxZImnjnle7WVz+EDeOigirg4W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQFs1lF8iUGRPNTa0o09XkzxudRUFMDpxnCeSQABdO8e4QwtLqvNgyrZkp3XyjOPT
	 rOGLFBXsF0OmbVnsEfjyehDrfaTQ+bLTkL6pJRiSLDoH4sKpNY6jDswB3MDnhjLpxg
	 JHV1bCb3Rq2FRsHClxUG/HFvVMzyl9BWWdL/NDzIH5hPz9OJ6U+Y5Eo+bnGdDZdGTi
	 xIjPnghwiRT5ovZ+FOABuW0VJ3sGnt5D1mOcrzEC4mCIoSnc2MvU5MAioKgDDbVJAB
	 hpPYD1sy8SaMwmpAR6bMQB853gifk9s6q6oz5O12+1Auozsz+UAXc4umO0OBkgOcys
	 jubD6kUnrCEoA==
Date: Thu, 27 Jun 2024 13:54:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfs: enable FITRIM on the realtime device
Message-ID: <20240627205420.GC612460@frogsfrogsfrogs>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
 <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs>
 <20240624150421.GC3058325@frogsfrogsfrogs>
 <87y16qhp4a.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20240627063538.GA16531@lst.de>
 <20240627063800.GA16609@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240627063800.GA16609@lst.de>

On Thu, Jun 27, 2024 at 08:38:00AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 27, 2024 at 08:35:38AM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 27, 2024 at 11:43:42AM +0530, Chandan Babu R wrote:
> > > Darrick, This patch causes generic/260 to fail in configuration using a
> > > realtime device as shown below,
> > 
> > It'll need "generic/{251,260}: compute maximum fitrim offset" from
> > Darrick's xfstests stack.
> 
> Actually that one is already merged, it needs
> 
> common/xfs: FITRIM now supports realtime volumes
> 
> on top of that.

Correct.

--D
