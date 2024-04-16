Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CEF374F1
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713242845; cv=none; b=gjZejxyExtCFmYMfuTEmdWi9kjm1c2odNrAmur4YFSgZn+k/xJHHGyI/odSRqwD5pz9gRLUEn93YyaM7zteukoJ2EMO/etINWXpAJmI3tQm8lbE/wR18KNiNWeObnLKSBz7MhaNuin6D4wNDWcm7oxkqnTohTLAUuOrcoaFGSa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713242845; c=relaxed/simple;
	bh=Ey4b8f3EEK6FLIelAFOUGlCRhxhnBbKcjUKpNljkJno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCqG4sUaGLhC0v53+wYlHFQ4UTONfHggMYFFT6Jo7ZfZLF4MYky22a+5H+eLMzoLKdjaqC9theyAfZDsMvee27V/wULUhlzL/hR8ZGprTHyvtLfLc3RLbpCpoJU6X5QR+jEC6Dtx6voD4ucT7YWsY2aq4urfZuxIpEHlfRA+FxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F099D68CFE; Tue, 16 Apr 2024 06:47:16 +0200 (CEST)
Date: Tue, 16 Apr 2024 06:47:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240416044716.GA23062@lst.de>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs> <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs> <20240412173957.GB11948@frogsfrogsfrogs> <20240414051816.GA1323@lst.de> <20240415194036.GD11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415194036.GD11948@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 15, 2024 at 12:40:36PM -0700, Darrick J. Wong wrote:
> True, libhandle is a very nice wrapper for the kernel ioctls.  I wish
> Linux projects did that more often.  But suppose you're calling the
> ioctls directly without libhandle and mess it up?

The you get different inodes back.  Not really any different from
pointing your path name based code to the wrong fs or directory,
is it?

> > In theory no one cares as all operations work just fine with disconnected
> > dentries, and exportfs_decode_fh doesn't do these checks unless the
> > accpetable parameter is passed to it.  The real question is why we (which
> > in this case means 15 years younger me) decided back then we want this
> > checking for XFS handle operations?  I can't really think of one
> > right now..
> 
> Me neither.  Though at this point there are a lot of filesystems that
> implement ->get_parent, so I think removing XFS's will need a discussion
> at least on linux-xfs, if not fsdevel.  In the meantime, getparents can
> do minimal validation + iget for now and if it makes sense to port it
> back to xfs_khandle_to_dentry, I can do that easily.

Uhh, I'm not advocating for removing ->get_parent at all.  We actually
do need that for security on NFS, where the file handles are used
undernath pathname based operations.

And it turns out my previous analysis wasn't quite sport on.  The
exportfs code always reconnects directories, because we basically
have to, not connecting them would make the VFS locking scheme
not work.

But as we never generate the file handles that encode the parent
we already never connect files to their parent directory anyway.


OTOH we should be able to optimize ->get_parent a bit with parent
pointers, as we can find the name in the parent directory for
a directory instead of doing linear scans in the parent directory.
(for non-directory files we currenty don't fully connect anwyay)
