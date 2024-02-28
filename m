Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0040853
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144528; cv=none; b=aAgZbYiaoCv8b8RnoOj6Ft0RTYhePB8zLvhoFVOsq2qFewNy7cFtCAs3cMscwDAosAwFbyypLvx+xNxKnimjHzno+vfHH08LXrqhyjfmlry37/gI++TeyZMDBy79AL+56mO/vGtTDOHWhcQ3NHdrMoeSmTr30Ug+Q10oNJIVwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144528; c=relaxed/simple;
	bh=T5RMZJ0KgP7Es8rRmfEPVTnb2kFnz6475jdWgkE3zyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeX2Boo6k0kURc6QBXjlaMKNwIi9lFFTAC1mv08cANaSlJQCCASCW/xhz8o9JCj77RrN6VCEWJkpuGzZS4YKpUKzVZ3RWpXd/DWSGrU7Bzm449iiD8jlCmdp57SplYVagRF4XUbMdbsVcM6gORV7tK8p3BFP4nD9NyqE1Vrh4Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5xSIWPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5xSIWPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9524C433F1;
	Wed, 28 Feb 2024 18:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709144527;
	bh=T5RMZJ0KgP7Es8rRmfEPVTnb2kFnz6475jdWgkE3zyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5xSIWPqeywxEs9f9nFlofrt8R7aImX1WVWMb+ixThK7TGemJVqZR7PInfd4hyCts
	 frkta73bJmZu6ZFQtSLS9U71742dP6Zi2pc8KFJC550dgh/l3sUvkXK6UawvtF5rza
	 6VfmQiU64pVpPJaWxjQx9PdjPcmfZ7iglx7rM9Rh38AG4dLA7LyajGo7Ue/ZIVVGt8
	 GhPBhYusLAxk6W+HexgAJXURIDOm93ToSIyMQjjKjAmqFJFWkGKmMx6OYGj7oERI0y
	 lts3jWB0rthot7l6q/ntuygyVQYJcIosq2LLb7JTlSFhTNj3ff5cC2Y6RAmfYuBMlp
	 n7m06RXhJML9A==
Date: Wed, 28 Feb 2024 10:22:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs: online repair of directories
Message-ID: <20240228182207.GM1927156@frogsfrogsfrogs>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
 <170900014471.939516.1582493895006132993.stgit@frogsfrogsfrogs>
 <Zd9qdpZU_er8nXdj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9qdpZU_er8nXdj@infradead.org>

On Wed, Feb 28, 2024 at 09:16:38AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 06:31:01PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a directory looks like it's in bad shape, try to sift through the
> > rubble to find whatever directory entries we can, scan the directory
> > tree for the parent (if needed), stage the new directory contents in a
> > temporary file and use the atomic extent swapping mechanism to commit
> > the results in bulk.  As a side effect of this patch, directory
> > inactivation will be able to purge any leftover dir blocks.
> 
> I would have split xfs_inactive_dir and it's caller into a separate
> prep patch, but if you want to keep that together that's probably
> fine as it's completely unrelated functionality.

Eh, I'll split it out.

> > + * Legacy Locking Issues
> > + * ---------------------
> > + *
> > + * Prior to Linux 6.5, if /a, /a/b, and /c were all directories, the VFS would
> > + * not take i_rwsem on /a/b for a "mv /a/b /c/" operation.  This meant that
> > + * only b's ILOCK protected b's dotdot update.  b's IOLOCK was not taken,
> > + * unlike every other dotdot update (link, remove, mkdir).  If the repair code
> > + * dropped the ILOCK, we it was required either to revalidate the dotdot entry
> > + * or to use dirent hooks to capture updates from other threads.
> > + */
> 
> How does this matter here?

Al's been threatening to revert brauner's change to hold i_rwsem on
child directories during renames due to deadlock potential.

OH.  He finally merged it for 6.8-rc1:
a8b0026847b8c ("rename(): avoid a deadlock in the case of parents having no common ancestor")

"Prior to Linux 6.5" and "Legacy" can be deleted now; this is the state
of the world again.  Let me correct some of the weird sentence
structure:

/*
 * Locking Issues
 * --------------
 *
 * If /a, /a/b, and /c are all directories, the VFS does not take i_rwsem on
 * /a/b for a "mv /a/b /c/" operation.  This means that only b's ILOCK protects
 * b's dotdot update.  This is in contrast to every other dotdot update (link,
 * remove, mkdir).  If the repair code drops the ILOCK, it must either
 * revalidate the dotdot entry or use dirent hooks to capture updates from
 * other threads.
 */

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
