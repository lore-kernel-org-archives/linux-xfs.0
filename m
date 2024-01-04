Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC801DFF2
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s48f1/nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF244C433C8;
	Thu,  4 Jan 2024 07:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704353652;
	bh=WB6QDBuh+8dTaDg6wIWWKoDCDxW/TzOz1dvaVK3aFFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s48f1/nkPD2EZRF3FPExmtgmsE2Ad1HAtbSvhpyspkrvOSdX51WXj98zJJJt/gobe
	 fyEGv7XrtXNNvHkSyi0BRujT6fa0k3iAXXvO4i2Kt9Hyuptd4NgMbaw5hLcplv2RmW
	 cDMLRVJ963NwBOC0qRnW6Y9ZtXpUQXpzYUphf1kc0UGNQa5LoYHFj8ebjZlgJEt1k/
	 qfC7lNYiBFwr04xENg6T9Hts67meZzgVAsZVvbPK0GlfpN/u3fTb8lUlVwHV1zDGvS
	 /IPyDi1yRRavhbjjUOWzk1hMkRrzt94vV2YzUwxvyXAQg6+WPF/UvYGnWmNb+ZrOop
	 9CylnSmk+B4aA==
Date: Wed, 3 Jan 2024 23:34:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <20240104073412.GF361584@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
 <20240104013356.GP361584@frogsfrogsfrogs>
 <ZZZOMiqT8MoKhba7@infradead.org>
 <20240104072050.GA361584@frogsfrogsfrogs>
 <ZZZeFU9784rD5XsD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZeFU9784rD5XsD@infradead.org>

On Wed, Jan 03, 2024 at 11:28:21PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 11:20:50PM -0800, Darrick J. Wong wrote:
> > > Sure, I just suspect the commit message is wrong and it's not about
> > > mapping the page into the kernel address space but something else.
> > 
> > Yeah, I only did A/B testing of before and after this patch, so it's
> > quite plausible that it's the lookup that's slowing us down.
> 
> Can we re-rerun the test once the pending xfile changes are in?
> I'd be kinda surprised if the fairly simply xarray lookup for the
> page is so expensive.  If it is the patch is a good bandaid for that,
> I'd just like to ensure it actually is still needed.

Ok, I'll do that.  Were you planning to send that first series to
Chandan for 6.8?

--D
