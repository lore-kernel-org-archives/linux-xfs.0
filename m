Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA963A6F16;
	Wed, 18 Mar 2026 09:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773826823; cv=none; b=W6v9HRBDfWhkwn8Wpz+PzZPBV/fd+GSfpG06Kg7vEQ5H5K3pMFRvegDzsFm3rpNYBxwvSkvIHV2YbIMfc6dHBm89DzSdVaXTy4zaPfyNKyRmer6cgmM32xnuFLfVKmF5mlXmTzAH5LnOCSy4FYQGCtQ5knw2pJWitRqwytI3Ltc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773826823; c=relaxed/simple;
	bh=VNVe/PLtGkPFZYJIF01u03qo7stbCIfuQ65YqprsSd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qom0bG3p+jUSaRkDB5mt8f+Dl4qvnJZWEZL2rRVqAAYbP/VCZaDQenmBx4s51W8lrGnSIR7sowskFWWRWpEcX2/6zWj86xPcvMCa24p8HEOvKXkrfeQcl424hKk2uhyYY0zMv1HIVn9oqyufZ0gkKe/URI4fFc/vU1KG37uwiAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFmDCLDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFmDCLDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAFCC19424;
	Wed, 18 Mar 2026 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773826823;
	bh=VNVe/PLtGkPFZYJIF01u03qo7stbCIfuQ65YqprsSd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LFmDCLDwDRBFYnKwXwMNRkVntHYfOhCNOTA+W3HfPLQnsokhqYAnz/9fiCqumyeDt
	 jFRhctKJrbrPcnjpdmtfaNn9M7SThKEzA7Ttihib26LBjelvrn5y+6HuEr0T5iVx9r
	 ByyBJxXJRqyWIETizX6xD3G9adC0xmK4FiwmsS1KShqcrOdJkBlg1rrsAkP0uu3nsC
	 JwX+n+eeF9+D+TlEcfgwWvt6box5LgjHylWAN8o64YXx37Q0Uf7Mtqu+KqxH/9g+wt
	 qPjSjrqR6iwMgFs5faHTkaEiSxhdbikfvHrRjdOsAelIU7Yzoory0+F9i1GJSMcrJd
	 FOetDubs6Ucjg==
Date: Wed, 18 Mar 2026 10:40:19 +0100
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com
Subject: Re: [PATCH v4 0/8] iomap, xfs: improve zero range flushing and lookup
Message-ID: <20260318-rauchen-abneigung-edae059d60a5@brauner>
References: <20260311162502.192375-1-bfoster@redhat.com>
 <abpsdcySytW3J_2G@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abpsdcySytW3J_2G@nidhogg.toxiclabs.cc>

On Wed, Mar 18, 2026 at 10:13:43AM +0100, Carlos Maiolino wrote:
> On Wed, Mar 11, 2026 at 12:24:54PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > No significant changes in v4. A few whitespace fixes throughout and I've
> > added some R-b tags from v3 review. Thanks.
> > 
> > Brian
> 
> Christian, giving the majority of this series belongs to XFS, are you ok
> if I pull this series through XFS tree, including the iomap patch?

Feel free to take it through the VFS tree. Thanks for asking!
Christian
