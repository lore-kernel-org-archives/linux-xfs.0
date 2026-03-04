Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423E734A3D2
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641821; cv=none; b=WaUFg/lPtsf2/D1hXvLB1Gs192he9p67w4igWKCDxuY0xOcWDcicCxhfLngpeSEp3BfSO0gVrTE13wwKFsNX4HEnsXXUSopDPyMAi1FcEVl3Uuv1PhXXX9UfZ3pYfpJ2ZDbOIrOryPhK2hRxQhdhGsEj9QqajsEFazYHs8HM09A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641821; c=relaxed/simple;
	bh=y+ihdeYqVYpDA+fMCsffMFgWbvumwQ6iTpI8L1A0+KY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfB4IxgogXyUJhXOZDK9ZvtJgrIDKX9z77zzSUmH3wVlynT/Zpi6x08eea11Ek1fdZIrgyOG49ZukahuimupDOWzqfD0cLgIHc338xotfMVs1KuVBkJ2sORjuHEJp4thVWkx/ougJ31WNbgOL6s5FHEyvd/EvCDXKWlKE1W7VPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BU2qolYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BU2qolYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9D6C4CEF7;
	Wed,  4 Mar 2026 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772641821;
	bh=y+ihdeYqVYpDA+fMCsffMFgWbvumwQ6iTpI8L1A0+KY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BU2qolYbjotufvuNWGFEnF5t1q7sqIl/5AFbHtue1hMsAt+kil/Zj7cL6HC+7pQJQ
	 ZdNP4VagDNNOS/FYFPZfvKAEPrmIgbjCMc8cOb/A5dz44PUe2ErQToSyFZpTB7Sbny
	 MkTRNDY1O5K2xeSlEGxVGWAcAgO5X+frNLXG0yWxfRqJJDiMH7usbHB9eSsiPIzigR
	 HDZ3o7SzbpnBNViGJK4NKDiiERSNFYmUHW5iPOzkt7arQm7Dqyc4oUemVzT+DQf0RA
	 l8F4ohyfO7IdTtfTe1JQetO74+Q1mtv9cAnuYZgiPtB38MpgJEqYW5awTsfSxk5+7Z
	 d4TXFprUI0sJQ==
Date: Wed, 4 Mar 2026 08:30:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
Message-ID: <20260304163020.GU57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
 <aacDkSiRLgD1k3Tg@infradead.org>
 <20260303172654.GQ57948@frogsfrogsfrogs>
 <aagtnm0-z3ldfFqd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagtnm0-z3ldfFqd@infradead.org>

On Wed, Mar 04, 2026 at 05:03:26AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 09:26:54AM -0800, Darrick J. Wong wrote:
> > Or did you mean that xfs_healer should keep the rootdir fd open for the
> > duration of its existence, that way weakhandle reconnection is trivial?
> > 
> > [from the next patch]
> > 
> > > > When xfs_healer reopens a mountpoint to perform a repair, it should
> > > > validate that the opened fd points to a file on the same filesystem as
> > > > the one being monitored.
> > > 
> > > .. and if we'd always keep the week handle around we would not need
> > > this?
> > 
> > The trouble with keeping the rootdir fd around is that now we pin the
> > mount and nobody can unmount the disk until they manually kill
> > xfs_healer.  IOWs, struct weakhandle is basically a wrapper around
> > struct xfs_handle with some cleverness to avoid maintaining an open fd
> > to the xfs filesystem when it's not needed.
> 
> Ok.  I've officially forgot what all the kernel code did.  I somehow
> expected a weak handle to be a fd that the kernel could close on us,
> which would be much more handy here.

Yeah.  I tried creating a(nother) anon_inode that has the same sort of
weak link to the xfs_mount that the healthmon fd has, for the purpose of
forwarding scrub ioctls.  That got twisty fast because the scrub code
wants to be able to call things like mnt_want_write_file and file_inode,
but the file doesn't point to an xfs inode and abusing the anon inode
file to make that work just became too gross to stomach. :/

--D
