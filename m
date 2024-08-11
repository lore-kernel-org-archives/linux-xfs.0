Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658611CAAF
	for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723365895; cv=none; b=Kss9QWWdghIPBQ1jAwv5SoMYFzVZb5sfVnhYblWxhGhxdT1Bxu06MotazT8zCfhFSiAN+O4njGxWh26310+57L4qynlE2o/Fq4QI1AGMY8D74Rc3reO9BgxOWiZNfEVtYjFJRrBfXFgoB7zq5+Op46y8TacmweBmFsEs5HGAtHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723365895; c=relaxed/simple;
	bh=cqG4mgI7TsbVBJxr7EbQlvbE7yvAOOBXiig0r9g1i/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZidCFtD3hzIjImnyY56yCYqom3aQQ48nWPpmw7LRCrY/kglCFY9BSWeUQglzMlhnxcyVHfc/X0Jc4ihEAW4rVN7qYJXMxKjda1xlnASZBXDI6YZwWsdet2+zGt7YVz0YZXFJqOhh1xgqhRPDcyR0+WNmB+1Omuj2iSNEunmdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D4D0B68AFE; Sun, 11 Aug 2024 10:44:47 +0200 (CEST)
Date: Sun, 11 Aug 2024 10:44:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: only free posteof blocks on first close
Message-ID: <20240811084447.GA12713@lst.de>
References: <20240808152826.3028421-1-hch@lst.de> <20240808152826.3028421-7-hch@lst.de> <ZrVIcay+jnfM7mM5@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrVIcay+jnfM7mM5@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 09, 2024 at 08:36:33AM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 60424e64230743..30b553ac8f56bb 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1204,15 +1204,21 @@ xfs_file_release(
> >  	 * exposed to that problem.
> >  	 */
> >  	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
> > -		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> > +		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
> >  		if (ip->i_delayed_blks > 0)
> >  			filemap_flush(inode->i_mapping);
> >  	}
> 
> This should probably be open coded to minimise lock cycles and lock
> contention on the flags lock when concurrent open/sync write/close 
> cycles are run on the file (as recently reported by Mateusz). i.e:

Let's do that as a separate patch on top of the series, as that
is unrelated.

