Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E4C1CF96
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 19:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCQFfnMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B9CC433C8;
	Wed,  3 Jan 2024 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704311907;
	bh=K/Yn5zVPZcxuFgrirU2RdBgyJV7p5CBRdm5ea5eL72M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dCQFfnMfXj6sreMcReczc7jiaRl/AxGneXuBuMABSGrqEA3g4V35lUqlbgeKSG/mS
	 DwVK1ffWLCnNkmEHhJn3F05puhO2qv/2le2WcQo1EYBkO2sgbnn2DNPGCNU97ipTa5
	 rJ1R9KEKB+rh2FQ/lgmBmHj0aWm6nAkd0nJm37ISQvfmWPavLoXQU6A7/bWViJQY/8
	 E2W6A5t3j7BuCKP4CIAuvHxxThY8oHI/Wmp4ezViRcJrAAVBEWjZPmX1WhI+aqnvnN
	 k3NNDyayXXUtPF8SUSN1H+MFpLtwA+AxUmYAvw1mI+5uqchBjPm9PIJA7M5hUTwvsg
	 oq2iguqkr4/3w==
Date: Wed, 3 Jan 2024 11:58:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: encode the default bc_flags in the btree ops
 structure
Message-ID: <20240103195826.GT361584@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830543.1749286.11160204982000220762.stgit@frogsfrogsfrogs>
 <ZZPmflimTzsSzH76@infradead.org>
 <20240103011511.GB361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103011511.GB361584@frogsfrogsfrogs>

On Tue, Jan 02, 2024 at 05:15:11PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 02, 2024 at 02:33:34AM -0800, Christoph Hellwig wrote:
> > On Sun, Dec 31, 2023 at 12:17:28PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Certain btree flags never change for the life of a btree cursor because
> > > they describe the geometry of the btree itself.  Encode these in the
> > > btree ops structure and reduce the amount of code required in each btree
> > > type's init_cursor functions.
> > 
> > I like the idea, but why are the geom_flags mirrored into bc_flags
> > instead of beeing kept entirely separate and accessed as
> > cur->bc_ops->geom_flags which would be a lot easier to follow?
> 
> Oh!  That hadn't occurred to me.  Let me take a look at that.

Eeeeyugh, this became kind of a mess.  These XFS_BTREE_ flags describe
btree geometry, are set in the bc_ops->geom_flags, and never change:

1. XFS_BTREE_LONG_PTRS
2. XFS_BTREE_ROOT_IN_INODE
3. XFS_BTREE_IROOT_RECORDS		/* rt rmap patchset */
4. XFS_BTREE_IN_XFILE
5. XFS_BTREE_OVERLAPPING

This one flag describes geometry but is set dynamically by
xfs_btree_alloc_cursor.  Some of the geom_flags (rmap, refcount) can set
it directly too, since they don't exist in V4 filesystems:

6. XFS_BTREE_CRC_BLOCKS

This one flag doesn't describe btree geometry but never changes and
could be set in bc_ops->geom_flags:

7. XFS_BTREE_LASTREC_UPDATE

The remaining flag actually describes per-cursor state:

8. XFS_BTREE_STAGING

Flags 1-5 can be referenced directly from geom_flags.

Flag 6 could be replaced by an xfs_has_crc call, though I'd bet it's
cheaper to test a cursor variable than to walk to the xfs_mount and
test_bit.  But this feels weird.

Flag 7 is set in geom_flags as it should be.

Flag 8 is really a runtime flag, so it can stay in bc_flags.

*or* I could rename geom_flags to default_bcflags and make it clearer
that it's used to seed cur->bc_flags?

--D
