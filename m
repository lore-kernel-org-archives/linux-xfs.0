Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47E72936
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 23:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161258; cv=none; b=l7QPUmUd0a2Wh6Z6CfbyscTP2Ji35KW+8bqNiK8YRtGwf2k596YZFalS9L+Wv5biuS+2LH/2DxAMhfUZ3EDIM01n7LEo0fwisElWefCaO8TL9+3TdYygL0qkvT/oqR6yBZ0EdxH38IdTh5A6VuO/hIo1/TIDS+1kRhmokGVHhJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161258; c=relaxed/simple;
	bh=lyMe189KyEYO7XOBHvEX+3c3r1fIequm9rX0DNW4Dno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWlXIqd996QANbFGBPZdaTP4F5AClMOP16H0jA9EL9y7owzl/fJlkBbPAIqU6JX3aON7wm3m54hjEBordE0yP6keR+lQlVxq7o/COPo3yFz9Ftz998sVwTaS+5Vlymy7b4HYWF8QWxlRnYBrm2kNxKlQP52+29+8+IPl1+FSQog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AlgRmQp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlgRmQp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECD1C433F1;
	Wed, 28 Feb 2024 23:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709161258;
	bh=lyMe189KyEYO7XOBHvEX+3c3r1fIequm9rX0DNW4Dno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlgRmQp++DaaiDcBL79BdwCa/LqwFkQkXHzgiJ6mEy+dy0a13WPAuwm8pTAaguWnB
	 p+nf05RyYR/di5dFImWQ50UQ7RrGx+Ij4b+IFy71FOlqomqCMe94JY4ksGapdmChBp
	 BwPSBe1f/tkFBiDZhPUSKpDxLaLk0gRRtzr3c6CLl+iH8GlHiHxpLLq9w242R0AaRl
	 hwLc747VG5lxI55GegtyZkztWg2L/KebO38ey1+elK4A/KBdR3Mlt60foRQ/0SHnMP
	 e6kdHmCXWV4CHYeYyCJwg7j2pzzWtRoWHPcI5RuhHvnZSxC7fWmHCm0vK8IkkSN1h+
	 J7HyglrvyitJA==
Date: Wed, 28 Feb 2024 15:00:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <20240228230057.GU1927156@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
 <Zd9U4GAYxqw7zpXe@infradead.org>
 <20240228193547.GQ1927156@frogsfrogsfrogs>
 <Zd-LdqtoruWBSVc6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd-LdqtoruWBSVc6@infradead.org>

On Wed, Feb 28, 2024 at 11:37:26AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 11:35:47AM -0800, Darrick J. Wong wrote:
> > > How about only doing this checks once further up?  As the same sb also
> > > applies the same mount.
> > 
> > I'll remove this check entirely, since we've already checked that the
> > vfsmnt are the same.  Assuming that's what you meant-- I was slightly
> > confused by "same sb also applies the same mount" and decided to
> > interpret that as "same sb implies the same mount".
> 
> You interpreted the correctly.  Sorry for my jetlagged early morning
> incoherence.

So it occurs to me that I've mismatched the signedness in struct
xfs_exchange_range:

struct xfs_exchange_range {
	...
	__s64		file1_offset;	/* file1 offset, bytes */
	__s64		file2_offset;	/* file2 offset, bytes */
	__u64		length;		/* bytes to exchange */

Compare this to FICLONERANGE:

struct file_clone_range {
	...
	__u64 src_offset;
	__u64 src_length;
	__u64 dest_offset;
};

The offsets and lengths for FICLONERANGE are unsigned, so I think
xfs_exchange_range ought to follow that.

--D
