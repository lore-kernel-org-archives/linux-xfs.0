Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6416319007F
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739514180; cv=none; b=usHR0MkuavTvIEEcBeHlfNFQL5/tp1cM8ezWJB5qb3loIc06ZYEvmZnr0xhjnPQr1SRlpzoSLDlZAEuHBkUyCcZWG7XeC9cCzNE7cLl9SOALoDE9A/U39nR78hexlwSbkkwcJ/bH4yOrYGLLUOPbU7qhvMpYyGJP/q1gY0NWTnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739514180; c=relaxed/simple;
	bh=f4GI9fSzT484nA/wMIlPAs707rKB3+pUZlM6a/LNmrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qygapQxZ9sbaiNXH332DByl0a5HsijZYugyLXoOLJ8TGZ1IAJvdCPyLrU4yngVCAG87rOc5lGYhyqfKg7Pz+rqFlRAkF70ZAC0XEB9Q010waJW3WWkmpeYVzjRrnfefV/anZ/wKmlMPXa+1QIbVdCP4qOUybXyCGD/LCfgJT9e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A815768D07; Fri, 14 Feb 2025 07:22:52 +0100 (CET)
Date: Fri, 14 Feb 2025 07:22:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: implement buffered writes to zoned RT
 devices
Message-ID: <20250214062252.GB25903@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-26-hch@lst.de> <20250212005405.GH21808@frogsfrogsfrogs> <20250213053943.GA18867@lst.de> <20250213230558.GX21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213230558.GX21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 13, 2025 at 03:05:58PM -0800, Darrick J. Wong wrote:
> > we'll need a space allocation for every write in an out of tree write
> > file system.  But -ENOSPC (or SIGBUS for the lovers of shared mmap
> > based I/O :)) on writes is very much expected.  On truncate a lot less
> > so.  In fact not dipping into the reserved pool here for example breaks
> > rocksdb workloads.
> 
> It occurs to me that regular truncate-down on a shared block can also
> return ENOSPC if the filesystem is completely out of space.  Though I
> guess in that case, at least df will say that nearly zero space is
> available, whereas for zoned storage we might have plenty of free space
> that simply isn't available right now... right?

That's part of it, yes as we can't kick GC.  That reason will go away
if/when the VFS locking for truncates is fixed.  But I also doubt people
run nasty workloads on reflinked files all that much.

