Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD416F858;
	Wed, 19 Feb 2025 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739984242; cv=none; b=ct5V+x3uJV1hn0+0OVInOCeLxXnUUJ38MfiSp60oiRdX/o0Bb7muugoVJj8fB1b5X2LxxzKxxU6OomcvKeS/fOF6XEuwVapb8l7NalTgcB89PqhrOGFTYV4har0V0gvvSihQMpYTvXyqcWQrBXamaqpzGCtuiVlvTryn66Ro9gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739984242; c=relaxed/simple;
	bh=RhvFmV+tBIfrFDsVZlCrlgBZN8j9ZhOdeBYPDXDiVG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgcm9InJ4d6joaCYxTOoMloxj0E48v+5Mle/EO+Mm4ZE3Yf5rU/poe9qdJv2aQRpg3D5n/8xSyNBvibAaiRXsP4eHgArdzh0X+9verGqGxHTJTkdRrzjtymnyETOGafMA1yrdNFkYgTZSd3jk8gt77rmjD5irVluAt4lhoyacqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSvxQzrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSvxQzrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1F6C4CED1;
	Wed, 19 Feb 2025 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739984241;
	bh=RhvFmV+tBIfrFDsVZlCrlgBZN8j9ZhOdeBYPDXDiVG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSvxQzrKljGxpT74CodvT8pUgY89IuZjo4Qtpdg40le+WH+QyBXk9uA+QsrCHxZKT
	 QEJ7IkbNAGOdl8SfaJxhvqOMYICwCsP7QuBSivqv1RUYURA30EVp8Fgo9KjOaSKRQW
	 US3jADnaaj/7nBFdqY06vxie3ZUgfGXhDOmuPVY5pklxvfI2jHIHYNkkusv/zn5mxo
	 73u25zTsZAQsvOz4ez0F+JQ+hB4Ewq4yAGsCJNjN/Vq72Q6SQ63xYqBKP2QaemvDXM
	 UcqGdjmKBrj5dcgCruwlSgrcAF/n14+RPcdBqLzZWULOOU6yZke9w8Yqzw3i+KN4IV
	 GKNNJzdNYMxuw==
Date: Wed, 19 Feb 2025 08:57:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCHSET v6.4 07/12] fstests: store quota files in the metadir
Message-ID: <20250219165721.GP21808@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
 <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
 <Z7WF70dbtoNGfOIY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7WF70dbtoNGfOIY@infradead.org>

On Tue, Feb 18, 2025 at 11:19:11PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 04:47:40PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Store the quota files in the metadata directory tree instead of the superblock.
> > Since we're introducing a new incompat feature flag, let's also make the mount
> > process bring up quotas in whatever state they were when the filesystem was
> > last unmounted, instead of requiring sysadmins to remember that themselves.
> 
> This sentence looks like it was erroneously copied from the kernel
> series.

Oops, yeah.  Will change it to:

"These are the fstests adjustments to quota handling in metadir
filesystems, which means finding the quota inodes through paths, and
adjusting to quota options being persistent."

--D
