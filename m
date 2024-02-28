Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887D70026
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 20:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709153534; cv=none; b=HlB22+t3v+cq6H8yS9ErfEflMTVj5RFbGxnWErG5rXtdWzXQc3KWFJNrlMb7iIow2GrcIo61NjfVAVYmPbavvpqsThkHkDJ9D3FrT0T1DP2+bAvFmPzeXcZ9b0MGt5u8Oyvflx3tySmf8SYGjo8gWKu41/U6B+Br+YzJ5PMHQZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709153534; c=relaxed/simple;
	bh=kjb8MFHgzd/B+I/2HocFu+glNxWLRJ21eCrXN413zTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llvIVi/ikn03vogWitrgrOTWF4Y7AMKZe2Jobu9HQAT0za3q35WB6bCsRDZiyC3jm2dzDt5Ih3fo5pWOgM7CLiDvb1y+9G5eFO73aErC2ErnQ3XeV6KuB6ni9vtowuILgJefFVsjy0hprE3TIlhIUdxfohchhgQAiP+II7h7gF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5DoDjHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5DoDjHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDCEC433C7;
	Wed, 28 Feb 2024 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709153533;
	bh=kjb8MFHgzd/B+I/2HocFu+glNxWLRJ21eCrXN413zTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T5DoDjHo0RqnzcBA78e5JNctR5u2O1Z4WLa64CUOaRlCtdpUIKusmT3zxJm8OpUl2
	 UpE2I94zEXQ5Q9+n6fIfws4c6L++E0vf9BVpEtrsqWAicTKsCpnQB+0QjFqls3Zfts
	 jpgQXL42XkNsvaE8fvfxbVPXHQe8UMs3Tmp08hPugbgUreoOnjSfVECgvb7A40Mn35
	 1wn+2D2JqoP2V+0Ru/rOq72YxQUkikyJ6XV/j4Pl77dwPDSNWLyJMSAPjKgpga2Nhb
	 iT9qnDTh1E9lf+K/I6oHKR8H61q7o48AD1FmOzFqO4H3VHRyMp7L+W8mfSWrNwAbEb
	 4KZfl9TJMwoIg==
Date: Wed, 28 Feb 2024 12:52:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <20240228205213.GS1927156@frogsfrogsfrogs>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
 <Zd-BHo96SoY4Camr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd-BHo96SoY4Camr@infradead.org>

On Wed, Feb 28, 2024 at 10:53:18AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 10:37:40AM -0800, Darrick J. Wong wrote:
> > Going back to [1] from last year, I finally /did/ find a magic symlink
> > target that actually does trip EIO.  That solution is to set the buffer
> > contents to a string that is so long that it exceeds NAME_MAX.
> > Userspace can readlink this string, but it will never resolve anywhere
> > in the directory tree.
> > 
> > What if this unconditionally set the link target to DUMMY_TARGET instead
> > of salvaging partial targets?
> 
> Sounds good to me.

I overlooked something this morning -- if the caller passes in
XFS_SCRUB_IFLAG_FORCE_REBUILD, that might be the free space defragmenter
trying to get us to move the remote target block somewhere else.  For
that usecase, if the symlink scrub doesn't find any problems and we read
in exactly i_size bytes, I think we want to write that back to the
symlink, and not the DUMMY_TARGET.

Something like:

	if (FORCE_REBUILD && !CORRUPT) {
		if (sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
			ret = xrep_symlink_salvage_inline(sc);
		else
			ret = xrep_symlink_salvage_remote(sc);
		if (ret < 0)
			return ret;

		if (ret != ip->i_disk_size)
			ret = 0;
	}

	target_buf[ret] = 0;

	/*
	 * Change an empty target into a dummy target and clear the symlink
	 * target zapped flag.
	 */
	if (target_buf[0] == 0) {
		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
		sprintf(target_buf, DUMMY_TARGET);
	}

Can we allow that without risking truncation making the symlink point to
some unintended place?

--D

