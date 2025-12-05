Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D47F2DE6E3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764954735; cv=none; b=CU/u3lKidPO6pN8m+fyFRW4eDrWchSuCXRGfcuCA/O3IvsxyyB9l2uUtxCqDP6HUZQp0zGqemmdUcR5hkSHIBXvAxMsdENB+45zDDTDa2L0v0gbYkauGDwtRLrxnntAEL+nKVh1auJziTXAzGU64rt/AlCOiSlMVnAG5jOsjhFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764954735; c=relaxed/simple;
	bh=n7jMhhqCwDkKDqBKg7dUBgUUiluaBkdTYFdI73ReaE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sgv7C33MBfZ0y6AZ2DQk2V3nLBHKCGfZ19kjRys8grfzcBfx923I7loBiLwKgOLMf+J6MSA+FwGCw/+T7n5mRCdSN5tZM1oy8wIZrjRm6xCKxe45ceKRCn6rvUkj1eiD6ucvylXLrVKqyEpQU5dkH1SjOAR+mZ0rhwCXj+K5klI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxviMt0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxviMt0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97CBC4CEF1;
	Fri,  5 Dec 2025 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764954733;
	bh=n7jMhhqCwDkKDqBKg7dUBgUUiluaBkdTYFdI73ReaE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZxviMt0M23P+icYV+jUZqFkpMxQMwjUR5ROPlc3YmrUA7m/nYaLvwHNlDdcgl70O7
	 8o0jrzje7CQ85gNxHdaR3kikBFQKd+Z94Fx1pToMa9TQDLcswOAGUz7ceIpufJV/mJ
	 QHBN+yhFCYPYTT0G68rdVf5hszkAb9s9roFN086hracd0ibEJ6Y3ddBB5avMuy78AQ
	 +y1+6SVq1MlZTMnsd4dpBkZxNG3A6A45gamGdF7szNjiAgCcC6L79FI6CS9xgHKFJ6
	 sbRpi4nsmD/Z9WqdsrCQDcxoq6EzEAH98rQKdX9w48Rg83jbszkvpBblMxeL5Rrx4h
	 yeSf2XMAkXkIg==
Date: Fri, 5 Dec 2025 09:12:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix a UAF problem in xattr repair
Message-ID: <20251205171213.GR89472@frogsfrogsfrogs>
References: <20251204214350.GM89472@frogsfrogsfrogs>
 <aTKSWb-wR7pQ43Mk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTKSWb-wR7pQ43Mk@infradead.org>

On Fri, Dec 05, 2025 at 12:05:45AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 01:43:50PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The xchk_setup_xattr_buf function can allocate a new value buffer, which
> > means that any reference to ab->value before the call could become a
> > dangling pointer.  Fix this by moving an assignment to after the buffer
> > setup.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Do you have a test case for this?

Not yet, but working on it.  I'm working on a corruption problem I
occasionally see in the xattr leaf freemap code, so I think the trick is
that you have to generate a leaf block with a corruption that will cause
the scrubber to exit early having called xchk_*_set_corrupt, and then a
remote xattr with a value larger than xfs_attr_leaf_entsize_local_max.

Obviously this is easy to reproduce after I added a verifier check for
corrupt freemap data, but for older kernels I'd need to inject some
sort of corruption.  Probably twiddling the crc or something would
suffice, but ATM I'm a little absorbed in sorting out the freemap code
and stamping out the bugs.

--D
