Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FDC17984
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 02:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXs6PeI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD36C433C8;
	Wed,  3 Jan 2024 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704250220;
	bh=OjsKBITXc4+77oN4/6XEhdSVdMc9c7T9XJUAN7HB7JA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dXs6PeI46nanb0LmG6G9W1BfhKdEZ1IVNWB/bpH1R0kfRoRsPXKICdWNye6qaEFJ/
	 DP7oMNdjG4qm1vkpFPi/o9Awwz73QtHRLT0+o/NWIl2UqXdjpwCnu8vMSlDlRTJ5Or
	 sUMWaE2sEtiqNKl24QbXylwsh6zOfrL34hOiK4vZkABBMgDyzmUsl70kVkZgewP1T9
	 hqs3sjZg3LEqTabpg634lUcRz/SZKj1LmpEjbDuM/lusqIsgUCRvAMJ2b9mR9nJgG/
	 RCCtALtMeCyquJsK7yevotwzi/ELaoUiG/j80iNk6AORWshvCISDkU/Lmi5LVuZuN7
	 GWxCoouIJ/nzA==
Date: Tue, 2 Jan 2024 18:50:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: repair file modes by scanning for a dirent
 pointing to us
Message-ID: <20240103025019.GM361584@frogsfrogsfrogs>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827036.1747851.13795742426040350228.stgit@frogsfrogsfrogs>
 <ZZPllihxlutug6c9@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPllihxlutug6c9@infradead.org>

On Tue, Jan 02, 2024 at 02:29:42AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:07:18PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > An earlier version of this patch ("xfs: repair obviously broken inode
> > modes") tried to reset the di_mode of a file by guessing it from the
> > data fork format and/or data block 0 contents.  Christoph didn't like
> > this approach because it opens the possibility that users could craft a
> > file to look like a directory and trick online repair into turning the
> > mode into S_IFDIR.
> 
> I find the commit message here really weird.  What I want doesn't
> matter.  If what I say makes sense (I hope it does, if it doesn't please
> push back) then we should document thing based on the cross-checked
> facts and assumptions I provided.  If not we should not be doing this
> at at all.

What you said back at [1] makes sense -- user controlled data blocks
should not be used to guess the inode mode.  I yanked that patch and
replaced it with this one, which scans the inodes looking for a dirent
pointing down to the busted inode, and uses that to decide if the busted
file is S_IFDIR.

How about I rephrase the whole commit message like this:

"xfs: repair file modes by scanning for a dirent pointing to us

"Repair might encounter an inode with a totally garbage i_mode.  To fix
this problem, we have to figure out if the file was a regular file, a
directory, or a special file.  One way to figure this out is to check if
there are any directories with entries pointing down to the busted file.

"This patch recovers the file mode by scanning every directory entry on
the filesystem to see if there are any that point to the busted file.
If the ftype of all such dirents are consistent, the mode is recovered
from the ftype.  If no dirents are found, the file becomes a regular
file.  In all cases, ACLs are canceled and the file is made accessible
only by root.

"A previous patch attempted to guess the mode by reading the beginning
of the file data.  This was rejected by Christoph on the grounds that we
cannot trust user-controlled data blocks.  Users do not have direct
control over the ondisk contents of directory links, so this method
should be much safer."

--D

[1] https://lore.kernel.org/linux-xfs/ZXFhuNaLx1C8yYV+@infradead.org/
