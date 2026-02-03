Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DE6366061
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770102884; cv=none; b=U48gFajblr+xw8lWDnDQf9/hSP14o8yuXHtqt8R+Xuk8ACDsG/vFuzSfH4xwsrwUX/mrnXTcDkcvOftbwSBJfwrHN7IMOwjCD/u8HtS6mAoP+GAW2n6uG2YmkIDhwmvAu70AEPkah9MgAMW+RFaCBKeLCrDisNBgzQGdQDzqX5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770102884; c=relaxed/simple;
	bh=soJLhEC/gOBvYNlQymo+EJEdb2hNrutxbEXk0QXEm/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GkAJu3V28jzrzkHlxrBeCQMFLKECZKRflro4BQnr5F8wTl8eBiSEf36zYru+C1dNCe6epfnVwaQF79D1OCeMLXTZojXlYbHeJJ02lVKlx8XLtOvJwJZKArqLi0k2PrLq1/EFdh635Agcy2a11vlAiElAG6+65Eq3lU0K7H9z3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2872A68AFE; Tue,  3 Feb 2026 08:14:35 +0100 (CET)
Date: Tue, 3 Feb 2026 08:14:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260203071434.GA19039@lst.de>
References: <20260202141502.378973-1-hch@lst.de> <20260202141502.378973-3-hch@lst.de> <00fa6edc7f0c324ceb95f7181682d04ce3f53839.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00fa6edc7f0c324ceb95f7181682d04ce3f53839.camel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 03, 2026 at 12:41:23PM +0530, Nirjhar Roy (IBM) wrote:
> On Mon, 2026-02-02 at 15:14 +0100, Christoph Hellwig wrote:
> > The active inode (or active vnode until recently) stat can get much larger
> > than expected on file systems with a lot of metafile inodes like zoned
> > file systems on SMR hard disks with 10.000s of rtg rmap inodes.
> And this was causing (or could have caused) some sort of counter overflows or something?  

Not really an overflow.  But if you have a lot of metadir inodes it
messes up the stats with extra counts that are not user visible.

> > This fixes xfs/177 on SMR hard drives.
> I can see that xfs/177 has a couple of sub-test cases (like Round 1,2, ...) - do you remember if 1
> particular round was causing problems or were there issues with all/most of them?

Comparing the cached values to the expected ones.

> So is it like then there is a state(or at some function) where
> xs_inodes_active counter was bumped up even though "ip" was a metadir
> inode and here in the above line it is corrected (i.e, decremented
> by 1) and xs_inodes_meta is incremented - shouldn't the appropriate
> counter have been directly bumped up whenever it was created?

xfs_inode_alloc doesn't know if the inode is going to be a meta inode,
as it hasn't been read from disk yet for the common case.  For the
less common inode allocation case we'd know it, but passing it down
would be a bit annoying.

> > +/* Metafile counters */
> > +	uint32_t		xs_inodes_meta;
> uint64_t would be an overkill, isn't it?

Yes.  Sticking to the same type as the active inodes here.

