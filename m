Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938FA3FE2A
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884308; cv=none; b=eXYej5L1bwW++MaR2vKoOHTz7HG+/RzZR+VIzw69SS1+TG2Dv2+XzEe5YIZzNk4iAY9+/YH+btoDOWr+yDYjhatugaToy3nDb6xvx6emwtcCTrLKfQrlZ/xxRvjTU/vktZkOxqEvYv29G7HgWd277ea7ErDF3lMJkbcpGHE15wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884308; c=relaxed/simple;
	bh=J1OSX8jVDj0/t7F7HsB4hFMmTU0i1niOifkdgsu/r2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MB2gmJ1wu1Cx5OUuruvzbMUHyWq7peFSlHkCXkEa6vZlQpTuosRiIvLdRNa2139a6YdQgqGWF92Vw71e8F1cnF8pcs2wLw5xf6f+PCB6J2FYjkDhCyiVqH42VeAsTEqXSXPsCLjCKefo4hO51ATxslwjcmmolzKU262QBDde5ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd87AUt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd87AUt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEDCC433C7;
	Tue, 19 Mar 2024 21:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710884308;
	bh=J1OSX8jVDj0/t7F7HsB4hFMmTU0i1niOifkdgsu/r2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hd87AUt7a5n0zSUuXZGehRiaa7qzgynfvT7rO5Kzk1ErPvPJkzOePeLvGzAwgediX
	 W00ecRFVcPYKqnSBECe4cBQrgfjenzA2sID8XJ3Zc6aLas4PenSmbaY46jCdHMhUNA
	 Asr+QQBK1kXIJ6TvMDk23pGTUOYKovaKQ/JN1utA0NBSTdytUOqki7vsJXSP5I6jue
	 qmFwXCx3aOjLSS8kwoib7wzTOzylm0cr9kqwBN35DBkugT8UBfzozMtPsKaogvhLnt
	 xX7DjTTfxUnCJlLoivncYO9640rf7w3K31Lw+Ov4kKZeY4UPbJnxZWpBhIbBZRkVaK
	 uclLLWKNBZh+g==
Date: Tue, 19 Mar 2024 14:38:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <20240319213827.GQ1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfoEVAxVyPxqzapN@infradead.org>

On Tue, Mar 19, 2024 at 02:32:04PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 10:29:09AM -0700, Darrick J. Wong wrote:
> > So.... does that mean a 128K folio for a 68k xattr remote value buffer?
> 
> I though 64k was the maximum xattr size?

64k is the maximum xattr value size, yes.  But remote xattr value blocks
now have block headers complete with owner/uuid/magic/etc.  Each block
can only store $blksz-56 bytes now.  Hence that 64k value needs
ceil(65536 / 4040) == 17 blocks on a 4k fsb filesystem.

(On a 64k fsb filesystem, that bloats up to 128k.)

Luckily we bwrite remote blocks to disk directly, which is why we've
never blown out the buffer log item bitmap.

> > I've been noticing the 4k merkle tree blobs consume 2 fsb in the xattr
> > tree, which isn't awesome.
> 
> Maybe that's a question for the fsverity thread, but how do we end
> up with these weird sizes?

Same reason.  Merkle tree blocks are $blksz by default, but storing a
4096 blob in the xattrs requires ceil(4096 / 4040) == 2 blocks.  Most of
that second block is wasted.

--D
