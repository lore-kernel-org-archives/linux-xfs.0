Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DE913792A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 19:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294454; cv=none; b=eROZgESxIMfaldPUUj0RFEBoy8PaeOmKovJUs93tchc6Qjy22h5+m1suN7fKaH7f3VcWlaJM+7cIEH1OicOExNaQ9YzHweyZCzgoPtu3/3jpxFFxq7D+BIpm0utY02T3tR0PzlrCCszgQLluykCEkgx64kSJjk9E+TJ2QmdJXjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294454; c=relaxed/simple;
	bh=Yt8lkw748UpNlqLs4IK+8RzH/6zlxjo0e2b2pQHWmkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTrDb5NoKjw3c4Dd6kTcd71NsiIJ1cuPf4Q0U1Ql/qx6czPqT2DNCaUgW67cvIDl6eAZpL3zbZt/MK8pWAqIqFE4gizzhOvSXLUzWnNqSMZiegr0cuc9i5KEbvSw7Z/pW9PEQzXxycnWdK6twIQwHvWGfrQg+X6ggmQMlbU3rbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lm/R1WsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lm/R1WsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DDDC113CE;
	Tue, 16 Apr 2024 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713294454;
	bh=Yt8lkw748UpNlqLs4IK+8RzH/6zlxjo0e2b2pQHWmkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lm/R1WsAo9p4lBpheZrfHG1AqEX5FHlLhdZYSsFvt//jB76+w/v3LyXBVleOU64sV
	 4WkeDBgbyZ68Nr0rrMK7jb/Qkqg/7YF+QwIijrfa4NlWAyIiR2Dx/af3sQ5Qp7m19+
	 UzSNpjOxOQJ10Pmxc8YveNRVbo+X1t92PC+nShWOxsNYmADNFj/jQepe7EBERqyWkz
	 ZlO/itRuj8WMq2i1hxm1wsx/I01HsjjCh9QyXvlHIdtVctdefQ0DlBs4fo4gL8eq9h
	 WEDvfbVMmwEqZ81gqLHSyufXqC6RYTx5X/nO4tWHcLvL9d+wlDisbyd6gp48XEMOZz
	 kK4M3PzXs4UuA==
Date: Tue, 16 Apr 2024 12:07:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240416190733.GC11948@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
 <Zh6tNvXga6bGwOSg@infradead.org>
 <20240416185209.GZ11948@frogsfrogsfrogs>
 <Zh7LIMHXwuqVeCdG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh7LIMHXwuqVeCdG@infradead.org>

On Tue, Apr 16, 2024 at 12:01:52PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 11:52:09AM -0700, Darrick J. Wong wrote:
> > > > <nod> But does exportfs actually want parent info for a nondirectory?
> > > > There aren't any stubs or XXX/FIXME comments, and I've never heard any
> > > > calls (at least on fsdevel) for that functionality.
> > > 
> > > It doesn't.  It would avoid having disconnected dentries, but
> > > disconnected non-directory dentries aren't really a problem.
> > 
> > For directories, I think the dotdot lookup is much cheaper than scanning
> > the attrs to find the first nongarbage XFS_ATTR_PARENT entry.
> 
> It is.
> 
> But I was confused again, it's been a while since I worked on that code..
> 
> We do the full reconnection for non-directories if NFSD asks for it (the
> XFS or VFS handle code won't hit this because our acceptable callback
> always returns true).   That code does a readdir on the parent and
> returns the name when it finds the inode number.  For files without
> crazy number of hardlinks just looking over the parent pointers would
> be a lot more efficient for that.

Ohhhh, does that happens outside of XFS then?  No wonder I couldn't find
what you were talking about.  Ok I'll go look some more.

--D
