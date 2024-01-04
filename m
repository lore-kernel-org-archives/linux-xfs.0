Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B11D68E
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D58068AFE; Thu,  4 Jan 2024 07:23:32 +0100 (CET)
Date: Thu, 4 Jan 2024 07:23:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/15] xfs: don't modify file and inode flags for shmem
 files
Message-ID: <20240104062331.GB29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-9-hch@lst.de> <20240104000145.GB361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104000145.GB361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 04:01:45PM -0800, Darrick J. Wong wrote:
> I actually want S_PRIVATE here to avoid interference from all the
> security hooks and whatnot when scrub is using an xfile to stash a
> large amount of data.  Shouldn't this patch change xfile_create to call
> shmem_kernel_file_setup instead?

Yes, and it used to do that before I reshuffled it..

> > -	inode->i_mode &= ~0177;
> > -	inode->i_uid = GLOBAL_ROOT_UID;
> > -	inode->i_gid = GLOBAL_ROOT_GID;
> 
> Also, I don't know if it matters that the default uid/gid are now going
> to be whatever the defaults would be for a new file instead of root
> only.  That seems like it could invite problems, but otoh xfiles are
> never installed in the fd table so userspace should never get access
> anyway.

In-kernel shm files are created on shm_mnt, which is owned by the global
root, so this will do the right thing.
