Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9674AFE29;
	Thu, 24 Sep 2026 19:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790276686; cv=none; b=u1y1hOZGNFxp6f1NkgRCrh3sAdJxn+9xgdce/SPM7ECDtu0zpIYSp406q0/nuGO2q4q8W7VQmrz/2y+JNA4bRwOlPsbUXiBr6liE59dw7OfSSO0AE1seh3pC/o49A31rNSSpRs0o5cC5+ZZ+txU7lsAECLm9rBE5SqzTt4UkYiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790276686; c=relaxed/simple;
	bh=n/mGDdA4vGy+lsfOSITKeJFB6K8dosLYn0tWIErbnZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcaxqZHybRbqj5ZoBZK95DfMb7cx3vMba8ze0eBKBA8IURT80LbOgWOF9wEKq6W1+gPNLnj2IiO8uUYY555Zn3a5SUR8l0UwlxGH178HRkZ/6gGh9sbP4zmf1qHuyNLDZ7fH3kvQfpJtwZBbDRZYNgS0zfhMLbanUpW8jgAcHV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWiUArgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWiUArgx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 075301F000FF;
	Thu, 24 Sep 2026 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790276681;
	bh=zJRHMJhAY4hd8flYH3L1mFTJcar4lkY4nEVMHUWAeZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QWiUArgx/Odg0vCuGDpdSld2Yo1mr4DvaHaIqPnzwlQplORAxhT/lJWqBFYxAo65Z
	 5s8g9bWsAJae5gTRX5AIqvt7LbZyqyuuwVkIxPMp5Z07abauy4S56iwl++h6Qzg5xQ
	 F1OsdgPQEW0RrBi5IIWHDpcRwhxn5wk8cZAHfdywhnnVUg4jh9yIFFSaruJygdd1CT
	 xhN6+DH/RtdkOe3iL2O3kvzg8LcM+RJC7iIhEk+vgXrz5/RZNm43kOq/OAjK/a5eJv
	 toU35hpcKVkxFV/Y5swJpbUTlMqSLZo+VvAhpFm6xUm1eECqQC/N+AK2xR3fLaz007
	 0yAGIttoyA0YQ==
Date: Thu, 24 Sep 2026 12:04:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: fix integer overflow problem when setting
 large free areas
Message-ID: <20260924190440.GQ2705364@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159671.1875436.8939376627577757057.stgit@frogsfrogsfrogs>
 <arS6U6GRYEQaSBIZ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arS6U6GRYEQaSBIZ@infradead.org>

On Wed, Sep 23, 2026 at 10:51:15PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 22, 2026 at 11:02:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM points out that the min_t comparison in xrep_rtbitmap_mark_free
> > operates on a 64-bit bitmap word offset quantity and a 32-bit
> > words-per-block ratio.  Unfortunately, I should have done the comparison
> > with the (64-bit) xrep_wordoff_t type, but used the 32-bit word count
> > type.  Oops.
> 
> I don't think we'll see rtbitmaps beyond 32-bits in our lifetimes, but
> the fix still looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I really hope not.  You can't create them at all with rtgroups, and that
usecase was horribly broken (and still unfixed) on old kernels.  Thanks
for the review!

--D
