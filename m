Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95F65B05E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721233147; cv=none; b=A0PU7WP4yN7H7pEOpbmJGHPhJkK2Orrfcjcjv0gvRnvEP3aR3VDnmncscHiWnMILefAFp/hL52rvO59Qf5EWn0hkZHkFXNM9ZBVNMBEgRa3Wgu2rFuuWRQdiswEb3dL73jhzQSUJpLT/Xpw5jI+csRXvQXj/Ixqhbf+/TwziKCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721233147; c=relaxed/simple;
	bh=/JMhknfH1jC1t4JIqDTZ9oixI56Vjgn0y74ZphsBt0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCH5lQnXiToLKwCBLrsZOFaHdPWEX+jXBP7Luq3K8RP2Wr7fJyMSTV4qb08+43i1v8r3Z/WA2R7FhR3TbGSc/oSPw5grG1J+qao1k3u0WDLrOBgMxoNqw2e7XNGyBeSpLf2CaoUbe0xSqtcn90w9kZSfKDh3GGGoqe5EfeOqpg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+czbgcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+czbgcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7467FC2BD10;
	Wed, 17 Jul 2024 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721233146;
	bh=/JMhknfH1jC1t4JIqDTZ9oixI56Vjgn0y74ZphsBt0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+czbgcGvrUUNQRkPgLGIWAEIhIRbXrfPyj8kzMCDt3Lyer+0zAXrgCIEAZ2e5nJp
	 ZSy5o0VAYVpFfq2icvBi5s3iZLYShFctjpve7xRzUA5+w3j9XIcajvDxK3MLS1/sHx
	 OI+NwvM+76rA2hdItaHo1qJoLzkXlLrs6T5Lb27Pd5D88pJtasrjKdNQ11AD6o3A/h
	 my7OKV5473XzQNkV3XusG0a4pGwHG4MQVp2MdzJU1yuKbT8Lxj1lb4knzvzyWasccE
	 OdXK+MF/Mn3KzRQiPx7CGm3uYTPVAV4JOl69TS0Ak3DIrRhRcwopiiVGxWPfb0rGnK
	 z+L1+55v+AFhw==
Date: Wed, 17 Jul 2024 09:19:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] misc: shift install targets
Message-ID: <20240717161905.GI612460@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
 <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
 <20240702054419.GC23415@lst.de>
 <20240703025929.GV612460@frogsfrogsfrogs>
 <20240703043123.GD24160@lst.de>
 <20240703050154.GB612460@frogsfrogsfrogs>
 <20240709225306.GE612460@frogsfrogsfrogs>
 <20240710061838.GA25875@lst.de>
 <20240716164714.GC612460@frogsfrogsfrogs>
 <20240717050005.GB8579@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717050005.GB8579@lst.de>

On Wed, Jul 17, 2024 at 07:00:05AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 16, 2024 at 09:47:14AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Modify each Makefile so that "install-pkg" installs the main package
> > contents, and "install" just invokes "install-pkg".  We'll need this
> > indirection for the next patch where we add an install-selfheal target
> > to build the xfsprogs-self-healing package but will still want 'make
> > install' to install everything on a developer's workstation.
> 
> Maybe debian packaging foo is getting a little rusty, but wasn't the
> a concept of pattern matching to pick what files go into what subpackage
> without having to change install targets?

It is, and modern debhelper-based packaging workflows make this easy.
Unfortunately, xfsprogs hasn't been updated to use it. :(

--D
