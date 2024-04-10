Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEF513CF86
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 21:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712785176; cv=none; b=MdVUn8yi5rsnSRS2VxGHGNx8xctzil+icit35pFuSI5w3SqxMOn3R9DRznk8lepMYxDAod+anLUHpJn4ZLCP1w2iT5QKKpwx39FzEmeNi18PHrTpzD9MmmkIup0BJufadYNiZ2psucVTLj2Gjdo3jfR4HTGCKuyx2zRNdH3iLEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712785176; c=relaxed/simple;
	bh=416iFL4/Ik/uhuHekoKSg1wpC2FFZ1A19K0lFIqKkok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOoBqCE7Q0lmMUdnyDvQbGDKBYaOQEfPaQ8V7StZ9n07lHmMHqtso5Mz2WlGjoYpPffoFR8Bgyyj4WcMZUBIgfH5ShDfYQqBMxCR/nStynWFXwvDR7v/M1tZOzWwX0D25oK8dV+5DRwq1BSGdA4kmoydpY76zU0MySBQDslF+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTlAwqS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTlAwqS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56301C433C7;
	Wed, 10 Apr 2024 21:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712785176;
	bh=416iFL4/Ik/uhuHekoKSg1wpC2FFZ1A19K0lFIqKkok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OTlAwqS26iyMoSubXdeqksF2I/HUH12cWaLCg9fXg76/YAB6Az9tDXesMk3JfXU/T
	 SfIFIfkcghgdswirIjCcAt+VCk/Ee9VCcObYfjM27B2E10WSZ6OqvVJ4rNl5m6w7Iq
	 FxjSeqvApuwVOcVEVDREeAVJCihpflMjg25EHS84cICaSx/pN7su5SOls9KMvT4Liu
	 4NiGkzYpgRkqOOBv6W/GoUqvre/cPXBAyI+5LcM8p8SRXU8RsNAh0MUeHG8U6/sxAK
	 no/5c/Lx8aqD/zmStI8pFIAbiVeCiPWQCDZdikK7TX5BdS6M4DccIhqsts9y8XwbyR
	 HDpR95Ba/CaFA==
Date: Wed, 10 Apr 2024 14:39:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/32] xfs: create a hashname function for parent pointers
Message-ID: <20240410213935.GF6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969823.3631889.1348496929393481589.stgit@frogsfrogsfrogs>
 <ZhYkuX5EuadCR7kv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYkuX5EuadCR7kv@infradead.org>

On Tue, Apr 09, 2024 at 10:33:45PM -0700, Christoph Hellwig wrote:
> > +	/*
> > +	 * Use the same dirent name hash as would be used on the directory, but
> > +	 * mix in the parent inode number.
> > +	 */
> > +	ret = xfs_dir2_hashname(mp, &xname);
> > +	ret ^= upper_32_bits(parent_ino);
> > +	ret ^= lower_32_bits(parent_ino);
> > +	return ret;
> 
> Totally superficial nit, but wouldn't this read a little nicer as:
> 
> 	return xfs_dir2_hashname(mp, &xname) ^
> 		lower_32_bits(parent_ino) ^
> 		upper_32_bits(parent_ino);
> 
> ?

Yeah, will change.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
