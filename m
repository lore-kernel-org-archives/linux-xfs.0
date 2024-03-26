Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0585913C8E4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711470503; cv=none; b=Y/uPyPgc2s7YNMYP5lO88jjuQxmzcH6h6F0D69OzVPfMq51cNtuWch6zH1qTzgcdmDakHrvgVPpDJAsVLr6WkdMKDXas01qfptg37Vq/PN7lb+uvUiOhBQU6AHM25mXCFxTuiAQn6lFXZzAOz0DL6Z1kF0wBzVya9/PQTCB9G4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711470503; c=relaxed/simple;
	bh=wTq+3u/9tGB6AWXsts4C7uWRD8s3H3UofmEerZC14C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwZ4KoL7sgPiATCYyiPSC9hNUHMkjvqN08MaBQefqdrBRlL/zI/UyKcVmAV1A5XR/sv7KBf6ze4hQPoG1DhrMmZ5MYKPZQYk6jZbRl6pZnUmUH5KIPSIRBb8uXi9N9kG5N8o86HHCKpBx/qyqhAan2YRo3djLY/Zd86d13AFQrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KE582jKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KE582jKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E52C433C7;
	Tue, 26 Mar 2024 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711470502;
	bh=wTq+3u/9tGB6AWXsts4C7uWRD8s3H3UofmEerZC14C8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KE582jKfWD9/D7gly4CRA0OaRU/4fKHTVYaAPaV06STwteH7fhVkFAdfBnMat/C/X
	 YHIoUndFVn/iW8pIRUyvj1lVNtf5CBMnn0RkGzjxsGZ0VxKDf+TIa1PPHtC2toJf5d
	 A0uEl5tqMYtP5XbpMvtbzCxAuYVILvKo5WUc4aXuf6y4trNTz3/Xz8NzjjvbWeZ0FI
	 CuobuTKJ5FE8kryvfPcUsEjXs44dG58sEqax5AZaVQteNuGViFGiEAx4mvZlWs+fMy
	 kSl8pWS2bY9yUfs6ccUKigwtiZNLGTWrjFWm0bgfKHkuXAfrPkr3iBCah5lvuI8HyA
	 fAzSBgzTpb7ag==
Date: Tue, 26 Mar 2024 09:28:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_db: fix alignment checks in getbitval
Message-ID: <20240326162821.GI6390@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128594.2214086.10085503198183787124.stgit@frogsfrogsfrogs>
 <ZgJZzSMIWDFBzADm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJZzSMIWDFBzADm@infradead.org>

On Mon, Mar 25, 2024 at 10:14:53PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 25, 2024 at 08:21:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > For some reason, getbitval insists upon collecting a u64 from a pointer
> > bit by bit if it's not aligned to a 16-byte boundary.  Modern day
> > systems only seem to require N-byte alignment for an N-byte quantity, so
> > let's do that instead.
> 
> Not sure what modern day systems means here.  In general in C you can
> do unaligned access, but it might be very inefficient. 

Platforms like SPARC where unaligned accesses result in kernel traps
that abort the program.  Not that I've used any such platforms in 15
years now.

> If this code does what I think it does, maybe the right thing is to
> simply use the get_unaligned_be{16,32,64} helpers?

Well we could still use the regular ones for aligned access, e.g.

#define PTR_ALIGNED(p, type) (((intptr_t)(p) & (sizeof(type) - 1)) == 0)
	switch (nbits) {
	case 64:
		if (PTR_ALIGNED(p, __u64))
			return be64_to_cpu(*(__be64 *)p);

		return get_unaligned_be64(p);
	...
	}

--D
