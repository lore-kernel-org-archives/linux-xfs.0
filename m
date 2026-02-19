Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8D522A7F9;
	Thu, 19 Feb 2026 05:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480743; cv=none; b=bHhw4V1/ryhpTGBp6dQXOVt83Fay2edc084xo/dzaA5dT1aCCGmsHFhN4LL/aMyCEnLE/b/t7n4dTNfcoaL0mvUVNi/f5ZUUKLcLDFzjaeXm84Gg0U2VHIbyPtANcX85w4RLZcxefViC4HAZFYHvHN3bqWtj7k48slgIVFaCmUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480743; c=relaxed/simple;
	bh=Vpe1bCiOudTET+CZNzz7Aq9b1b3HOp2IX1C++brFTBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dp13YIsvHUAM+PxBgU9JJX3/IqOR1vXLYN/Q+8m10Ro5K07g7Y6syZC8Ofhssmn5gJppGlWWv7VoT89QBlkSTuUy866Vtq/e1ipm5GSvvXTpotPlJAJLqL200VN/rArLdBXUS72G/U7iZZGqxLyuhzS2pBFHdcEkyOz0R7X/Qzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E883B68C7B; Thu, 19 Feb 2026 06:58:57 +0100 (CET)
Date: Thu, 19 Feb 2026 06:58:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3 06/35] fsverity: pass digest size and hash of the
 empty block to ->write
Message-ID: <20260219055857.GA3739@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-7-aalbersh@kernel.org> <20260218061834.GB8416@lst.de> <wl5dkpyqtmbdyc7w7v4kqiydpuemaccmivi37ebbzohn4bvcwo@iny5xh3qaqsq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wl5dkpyqtmbdyc7w7v4kqiydpuemaccmivi37ebbzohn4bvcwo@iny5xh3qaqsq>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 01:17:52PM +0100, Andrey Albershteyn wrote:
> On 2026-02-18 07:18:34, Christoph Hellwig wrote:
> > On Wed, Feb 18, 2026 at 12:19:06AM +0100, Andrey Albershteyn wrote:
> > > Let filesystem iterate over hashes in the block and check if these are
> > > hashes of zeroed data blocks. XFS will use this to decide if it want to
> > > store tree block full of these hashes.
> > 
> > Does it make sense to pass in the zero_digest vs just having a global
> > symbol or accessor?  This should be static information.
> 
> I think this won't work if we have two filesystems with different
> block sizes and therefore different merkle block sizes => different
> hash.

Looking at this a bit more - you're storing the entirely zero_digest
in struct merkle_tree_params, which is embedded intothe
fsverity_info.  This means that you can trivially access it using an
accessor of the fsverity_inode.

It also means that you actually bloat that structure quite a bit for
constant file system wide information.  Maybe it's time to split
out the file system wide part of it into a separate structure?
Eric?
