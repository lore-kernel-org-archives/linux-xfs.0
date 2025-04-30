Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD81A2206B1;
	Wed, 30 Apr 2025 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746005696; cv=none; b=QZ5oXoIFNdbASccVTCTStoA3WLF0CBlHuc1M46wKmmRirw1CLx8JVLVFwz3/NNsd6dbQMwC+unA75xbB2mE9z+dgaSUKn+w2xBqerj/mDoeIonwgaVGTlC8yvl6RIQzEGngiPjOxjDWepdo5UeW4YfRFErXoiz7xOil/81w3jZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746005696; c=relaxed/simple;
	bh=MRUoh+uxcDbMkLUhQxahHDNcXlIFBI2LDJEfCoN76ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRelGO0I4b+lYBkMk4PIZGDsxiaT1fGHmQacLf4bk10hsnWMeeyaBiREbJ4dhzMWjBx9vwt1WL1gmqmO7RjIzUTbvNsqzZ18e7NP8nt+uJJcVuKW+XFQOtzyXX6iguE9y9k4UGoaQ7RCo+HmLnrBUVgGrVu+jJv3npj6lJriuvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9hxpgy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9hxpgy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A86C4CEE9;
	Wed, 30 Apr 2025 09:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746005696;
	bh=MRUoh+uxcDbMkLUhQxahHDNcXlIFBI2LDJEfCoN76ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c9hxpgy5lfzlZVRFBX9gIIxiqJ5m7LMz6kCuZFyV9iAdhqPOckRq0v3DjWp/4m99p
	 eWuSkEGddHM1zsmwSvcGO/RSb7yPmgQtdlybWKfIyz1wGHGprN6sq91SlVWuQ+kNRJ
	 yyDvHBYbuKy/iAvwsLeAM3Vbl6NM6t2HBCS5bA7AMCMfBnMNIahQs74fVCQi56rS97
	 u+EqRvlhiDhnHCyl2x7Ro6sK88aB1flXNnI71fiZMR2gRddw9jY/Fz/KIT5Ujo+k/h
	 U1dHehG0UDeQfAFV+dZW6CyYSEjZHaR9C5UGva7IRhQVwlyI8uZXSpy+DRO/luNi2K
	 qdGb/7/5061SQ==
Date: Wed, 30 Apr 2025 11:34:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	Chandan Babu R <chandanbabu@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Qasim Ijaz <qasdev00@gmail.com>, 
	Natalie Vock <natalie.vock@gmx.de>
Subject: Re: [PATCH] xfs: Simplify maximum determination in
 xrep_calc_ag_resblks()
Message-ID: <rjazpdvhkyz5xzl3rndpfuwqcnqevhcjp3rs7iy2utd7gwleqc@zjiy73y73lt2>
References: <oL08RYG1VC2E9huS2ixv9tI5xAJxx88B60-95yE-8PIDHIdkDkYdqKhA9T_qDEoFzv4qGpCn0M0WtI3JV3f5EA==@protonmail.internalid>
 <2b6b0608-136b-4328-a42f-eb5ca77688a0@web.de>
 <wv2ygjx2ste2hfusgp7apsp76wufeegrd26kdkzqmergwhwfqd@spof2npy32p5>
 <4EauTu1pTPZgYcvewRgJKMqpdqHA0CRpDDyv-37l3g8wp4DHcjRyKiSdFSs-Kcbt9kGQyjJvN7cNE2KZ6p9rlQ==@protonmail.internalid>
 <f35da51a-d45a-4be2-81c3-4da25b65c928@web.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f35da51a-d45a-4be2-81c3-4da25b65c928@web.de>

On Wed, Apr 30, 2025 at 10:34:59AM +0200, Markus Elfring wrote:
> …
> >> +++ b/fs/xfs/scrub/repair.c
> >> @@ -382,7 +382,7 @@ xrep_calc_ag_resblks(
> >>  			refcbt_sz);
> >>  	xfs_perag_put(pag);
> >>
> >> -	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
> >> +	return max3(bnobt_sz, inobt_sz, max(rmapbt_sz, refcbt_sz));
> >
> > I have nothing against the patch itself, but honestly I don't see how it
> > improves anything. It boils down to nesting comparison instructions too, and
> > doesn't make the code more clear IMHO.
> > So, unless somebody else has a stronger reason to have this change, NAK from my side.
> Would you be looking for a wrapper call variant like max4()?

I have no preference really, between a max(max(), max()) and a max4(a, b, c, d),
the latter is a tad easier to the eyes, if it's worth adding a new max() macro
for that, it's another thing. Although a quick search on the source code
returned returned several usages of the max(max3(a,b,c), d) patterns, so I think
indeed the kernel could benefit of a max4() :)


> 
> Regards,
> Markus
