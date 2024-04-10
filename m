Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0288181D19
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 22:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786503; cv=none; b=cPCiD9vjXWCFG+loSn6ZxlGaSj4ipIpw1mIffu9J6gyfOpfmLAEXWUgG6xNAkfH+dnfqxTWKKqX1mVx+q1Il2lkjRmtuYPGUjNGFl6BOzYKWJSb02GQdf7JQ1iT59Qpa3Gwh869dVU3MuyRwjvkrZLzILl3UewvF5la1kE4O+KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786503; c=relaxed/simple;
	bh=XOGELrchjJo4xQVb37HvEloMAqg/FRZwkvJX9Xi/ohI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ca8bQuonVuQpBghjAifLmxdVve1x04I6wByXYKwvO9HLUzW1FznRjeEcAle5kXMe1HSOie85xrRdSXAN1G4+hR/ryAzZ6L06jX7bKNffoxlVGUw1nilrJ2qSIFg8EiX4FFZAMNR9LRhlx8/IMhgvsG/jbnkX8orHlv8waqx1r3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpdfZu4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpdfZu4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8A6C433B1;
	Wed, 10 Apr 2024 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712786502;
	bh=XOGELrchjJo4xQVb37HvEloMAqg/FRZwkvJX9Xi/ohI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpdfZu4dVdynYjDXLdwtdECkCrSIMTrocprQAmWB6UTcoowc7yy1g152PsfwRhiKC
	 fqQdzNZq7U/2uUUc7LPe4aguMHuPCDVvErbw30LhZi8IAHZPYzKXhAAp2QLvTYyzvG
	 rnfwLVsXryMlyEnAklSivsCGrwNF4orZ/ZDXsxwTM+9zNeYMcb8ffaJFqCax4LQJzB
	 nYDJtedFHF1LS+LOoLlAxFVaEOE5gQavCMmqTNw8SccudDPEbkFSoFF7TTrnftJ843
	 Nk8Y8dXogGD4lbTyHC1keD+NvrhMgN12Sw+FF7O9t971+Kk0tZRp4XP8xxnrqVTSRF
	 uAF5MIrkRFOgw==
Date: Wed, 10 Apr 2024 15:01:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/32] xfs: split out handle management helpers a bit
Message-ID: <20240410220142.GI6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969991.3631889.18004647832726113704.stgit@frogsfrogsfrogs>
 <ZhYp9j_4g7bNmfEf@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYp9j_4g7bNmfEf@infradead.org>

On Tue, Apr 09, 2024 at 10:56:06PM -0700, Christoph Hellwig wrote:
> > +	handle->ha_fid.fid_len = sizeof(struct xfs_fid) -
> > +				 sizeof(handle->ha_fid.fid_len);
> 
> If we clean this up anyway, maybe add a helper for the above calculation
> and share it with xfs_khandle_to_dentry?

Done:

static inline size_t
xfs_filehandle_fid_len(void)
{
	struct xfs_handle	*handle = NULL;

	return sizeof(struct xfs_fid) - sizeof(handle->ha_fid.fid_len);
}

static inline size_t
xfs_filehandle_init(
	struct xfs_mount	*mp,
	xfs_ino_t		ino,
	uint32_t		gen,
	struct xfs_handle	*handle)
{
	memcpy(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid));

	handle->ha_fid.fid_len = xfs_filehandle_fid_len();
	...
}

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
