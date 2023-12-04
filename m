Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1726AC9
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQLLnI3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A20FC433C7;
	Mon,  4 Dec 2023 20:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722632;
	bh=RQq9Lz/M49PMwXzde5y/x4XGpIy+dm2B9hOhM6N3qtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PQLLnI3a7bRiUIX1xz2L8Ue1dTltDcsFZkRAppTS/3MnPQyNXNrrkIgLOzj/Re5QX
	 nDGcjh6qedjyw31a5gttcYLEg2gSBZ8RCbTr8W6b5Gs0br8FT8gpjjjbJNCu8fhLsM
	 /G3Y1gHRGHwua4p01kCr04zF46CB81O10AQlhE63Iv1gmO5BVtJ66lanRZvKv5BEYr
	 3b3bUjEXjJOLeplnuYqUGELrP/uRIrMMUZqAW2uSmkBQQONpX2PFOEIUQ/TSsAJaEg
	 tm/ek2KeusT5+gZVQdgCSdoQVu11v7PSTIaS4P86Urt29aRyuUIkguC6uX8OPD7s0B
	 g5vP8mfHnX1Rw==
Date: Mon, 4 Dec 2023 12:43:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: zap broken inode forks
Message-ID: <20231204204351.GG361584@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927504.2771142.15805044109521081838.stgit@frogsfrogsfrogs>
 <ZWgTSyc4grcWG9L7@infradead.org>
 <20231130210858.GN361584@frogsfrogsfrogs>
 <ZW1YHT4o0WI1F/3U@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW1YHT4o0WI1F/3U@infradead.org>

On Sun, Dec 03, 2023 at 08:39:57PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 30, 2023 at 01:08:58PM -0800, Darrick J. Wong wrote:
> > So I think we can grab the inode in the same transaction as the inode
> > core repairs.  Nobody else should even be able to see that inode, so it
> > should be safe to grab i_rwsem before committing the transaction.  Even
> > if I have to use trylock in a loop to make lockdep happy.
> 
> Hmm, I though more of an inode flag that makes access to the inode
> outside of the scrubbe return -EIO.  I can also warm up to the idea of
> having all inodes that are broken in some way in lost+found..

Moving things around in the directory tree might be worse, since we'd
now have to read the parent pointer(s) from the file to remove those
directory connections and add the new ones to lost+found.

I /think/ scouring around in a zapped data fork for a directory access
will return EFSCORRUPTED anyway, though that might occur at a late
enough stage in the process that the fs goes down, which isn't
desirable.

However, once xrep_inode massages the ondisk inode into good enough
shape that iget starts working again, I could set XFS_SICK_INO_BMBTD (and
XFS_SICK_INO_DIR as appropriate) after zapping the data fork so that the
directory accesses would return EFSCORRUPTED instead of scouring around
in the zapped fork.

Once we start persisting the sick flags, the prevention will last until
scrub or someone came along to fix the inode, instead of being a purely
incore flag.  But, babysteps for now.  I'll fix this patch to set the
XFS_SICK_INO_* flags after zapping things, and the predicates to pick
them up.

--D
