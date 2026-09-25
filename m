Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB42A376A0D;
	Fri, 25 Sep 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347788; cv=none; b=iELncGY8Klrte4uAPq8JzOoZQtkr2vPnFw0E142ORSvPXIs5FGCMUqesSW19w4hnPaE88zHhUFLh+ESN0xU91vTQ8lMw3OTZrKBruAYWb2c0Uyk49KYaJf37HPLgDBIE0RXeqvkNUi8M2osOUe/9W3eQRG4/cKx42MuM4E6qzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347788; c=relaxed/simple;
	bh=a3R1OhS54AAEPr5eBSMSeAzCNr0p77mW1cVE++7Chbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvG8GZYvE69jWdnMA6ztwwmFXlutETKQqyECuJpGS089UYkcFu7oHQXOnUK5KS+i81lV/SFEnVVTHjM5pb82/UbgKy6MgYgpcNzeUsN/YjXT4X7S+KZU18V94Cd/pUXwSXPGTEZvHE9pcrlqwJsOK58PLoa8L7nG7LLZ7ah+dl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jG0V+PnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jG0V+PnC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 385DD1F000FF;
	Fri, 25 Sep 2026 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790347786;
	bh=a3R1OhS54AAEPr5eBSMSeAzCNr0p77mW1cVE++7Chbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jG0V+PnC7CAb8eJoq3y/yLH4MpFo0d5f7hLd1vCXn8G8m1EkoHv2lwWrzd1buBU0v
	 xnLJT3LAM94Fx9NAWh41sXgmLUNxbi3GMa8wFWVI01YigL/KINy38RZq0kdjaKdGcF
	 P/EFnLKOwCURjYjOqXgQsS8nQEnQHKvaQDzsXTlJX/ekHqKQ9BN20jQ+joQLbv6Tp2
	 N3ozxeTh6L4GUQyhee7uF1V/5UQTLNV2xruX33a522G4jwc5veGphH0b9pl/7CsAax
	 nac6xg+0iDhHS+/5hevJBuJ6v08hRZLaPr4YBShSFQzcKfTafJmCHgGJMGqEqekUcB
	 CGR35BVAmt6aQ==
Date: Fri, 25 Sep 2026 07:49:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/805: skip this test if we can't mount the
 filesystem
Message-ID: <20260925144945.GN2705364@frogsfrogsfrogs>
References: <20260924060245.GE6253@frogsfrogsfrogs>
 <arX_YZb_Gmxrx3zb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arX_YZb_Gmxrx3zb@infradead.org>

On Thu, Sep 24, 2026 at 09:58:09PM -0700, Christoph Hellwig wrote:
> I think my version of this is better - we really should never
> use the scratch helpers unless using a real scratch fs.

<nod> I think your patch works too, though if we can't _mkfs the
synthesized device then there's no point in continuing the test.

--D
