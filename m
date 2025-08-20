Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8725B239E80
	for <linux-xfs@vger.kernel.org>; Wed, 20 Aug 2025 08:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755677227; cv=none; b=lGxuI9SnNXtrGpO496h9QRZdtOjwmzH7OgnAunS0ixC10ys+/qjCbbTNJWzYPi5FjPpg4v/Mbbxxo5hlhCEHH+uMEifKKqTpSq4bK5aNvGoitUulQ0CjHFhJ9FiyJeB09pFmDyFEVamFT3oXT4j0O0c9uvVOEY1ebX0DYwuEYNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755677227; c=relaxed/simple;
	bh=uy0YhMlfWfNwFO5NwN0aD6LHONz/B/9JDYkME8/BfW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPRfTY9ky5/jL+NEknzOGKXrvuNPzFgy1mYh1Ic2mg635nvT8+YjvPjW2G9kw5Aa/Iw+i/1awD+AF+d2F4cP0lsOmj17RYTjy6Z/XJutLCH7LwZMjsrwumJmwz/mF+t7/HPd7uQ+QHMoHzEF7+YZjdCUi35FVm97T709AW6YZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vnwzjo8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vnwzjo8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F81C113D0;
	Wed, 20 Aug 2025 08:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755677227;
	bh=uy0YhMlfWfNwFO5NwN0aD6LHONz/B/9JDYkME8/BfW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vnwzjo8GXNOuJsT8xWxZlYoK6kZhy+Jne+DtnwGXHjKTuxzRHxJT5xXmtnC1ofJvh
	 3cA7WNIxDjJMXBLCmOrg4re5vLImavzMQ7LapS+UJTYI5GtTxjiUFldCEOAm4ooKdp
	 lTmaLAjfqMHVs9GzLal+88qs6SBkpRgJFfNxPH7bHG3CCLc5gqd/67fS3dZaT4tzGg
	 csk3hcnfB8yb/+Get2en1TFIqts702ExDN2IDcQZsv/VSDmJw0XjGTOh6ybu01yZiz
	 25HLcHsjq6GfsWdGK09uSZln/Bn4bF9xoCWT0jo54CeMWDOYyMJ626VidFxsSzSy1p
	 9v9FQmxkeBF/g==
Date: Wed, 20 Aug 2025 10:07:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
	Chandan Babu R <chandanbabu@kernel.org>, Zorro Lang <zlang@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Yearly maintainership rotation?
Message-ID: <7svscwa3oy5oxavscjgapcvr7lbumsntu32fq7uhmrfqr6pino@7awm4hxzzqzb>
References: <Pd4KqICHYbjm5ZYOHBmgSRgs-uKNopGdeI4ARGEXr12t8ZnKctQMdfVRNceZbMeFFKncvIv9_fKyKoMCmCiLfg==@protonmail.internalid>
 <20250819225400.GB7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819225400.GB7965@frogsfrogsfrogs>

On Tue, Aug 19, 2025 at 03:54:00PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Now that it's nearly September again, what do you all think about
> rotating release managers?  Chandan has told me that he'd be willing to
> step into maintaining upstream xfsprogs; what do the rest of you think
> about that?
> 
> Also, does anyone want to tackle fstests? :D

Considering you were specific about xfxsprogs and fstests, I believe
you excluded kernel on purpose, but anyway, from my side I'm pretty ok
with how things are now, and I'd rather keep it as-is, specially because
I'm enjoying the role :-)

Of course I'm talking about my side and my workload only, I don't speak
for Andrey or Zorro.

Carlos

> 
> --D
> 
