Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81302571A1;
	Tue, 14 Oct 2025 20:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760474128; cv=none; b=E5USgDofMAaWzuWqiYM08UQWc9cbGNl4SbZ7DeR9gc6DYk8c9WGcWHRGqlyQBd6zgHt8P8y7B7YbjvgiFhuj3vjnzoWIQo1Qt3ToPOaAW5p0QcP9cKkEecRdAJomEf+OqRAbg1meB0CshkQL61pg8QwLnfc0Nsdww9lIaXo3DDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760474128; c=relaxed/simple;
	bh=9R1aucuZobRn6Ija7EjDWKLa9tcxo5yonZ+ZUmemBag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=keu4/BvLuNu+zn0EPsSMSvV8LIQbg+7SEu8HpFwFDpMb56mhsgRE64s6pJxnAuRikAE9wypQL2lPOFnDfLVaYQUgGcNlhRMlqb/87M1orpcYGpxWgkgHq+QgN63tkmj6wDqP/EyvbBms3IUGzqfIeNoE4HtRYX471U+4IyqXSAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VVMQF9Hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VVMQF9Hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D045C4CEE7;
	Tue, 14 Oct 2025 20:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760474128;
	bh=9R1aucuZobRn6Ija7EjDWKLa9tcxo5yonZ+ZUmemBag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VVMQF9HuPGrzsdp9n/QrLo6qd7IZ1LkKXHJJRUo8sTbk9a55I9OywcTl73NaXrq3o
	 SZVr3ev/rGCe+uw+DbHGjiDpLAfkoHTSGK1ik2Riv64DspWjRVli91ZhGAcGUzeL63
	 cRTuLKGXno1hmvApiW6e0mM1TZuhihkpii9e7yUbZMdnpRp6PykzxB1iHlJLpLmY7o
	 kvC9fBwWFUA4J+pJfpMkYW/fD4Kg4rPke42Q0AWmODcqhpPixFArk7j5ptzWne+DW/
	 hO7k0cvVcivw3yveRWWcRsUqfdQgE/Tx0NIlM4QyB4HupVHRVsgcOsalAwLiTdjCSm
	 sKbecK4aeGPQw==
Date: Tue, 14 Oct 2025 13:35:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Pavel Reichl <preichl@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 2/2] xfs: always warn about deprecated mount options
Message-ID: <20251014203527.GZ6188@frogsfrogsfrogs>
References: <20251013233229.GR6188@frogsfrogsfrogs>
 <20251013233305.GS6188@frogsfrogsfrogs>
 <aO3RTDjEjz3Lpi8A@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO3RTDjEjz3Lpi8A@infradead.org>

On Mon, Oct 13, 2025 at 09:27:56PM -0700, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the review!

I will also remove the now unnecessary parameters for v2.

--D
