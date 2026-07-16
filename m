Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EED3C98BA;
	Thu, 16 Jul 2026 22:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784239557; cv=none; b=GBlc7PzTCg9iCMM+ZxEKFk/yf6gluINhWealzEM/eWsxRohld3YAkAIotGhYqC8y3HtIbB9ZrsXhe526ewaKeLGSdSC7l2YNrQrjZ2kAPTbV4Ru0fKGagyqqO5xpBvbzSAEm/ldAw6RG6OtSfLXPRP/3R5JHRSxeorMANLNLAO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784239557; c=relaxed/simple;
	bh=DEuJkfxnd50V2UVBJLNe4rpOhJNZQ2u9pGKHZeQ71K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcM3dNmwG5h2zJ+bEp99z5rKae3ep/tGLjw7lANAC+hdL9Dev5iqPfEvOYA5REG71dA2YiwGwGjVE1G96/3jzd+qfeog7/vTw/8F1NiOd1BY+ixswUFon72/GwqHSewJNQThmLljLCdLt2F6iw75P6nVPQGvgMNfdIJlHeodDi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AavenVYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AavenVYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2117D1F000E9;
	Thu, 16 Jul 2026 22:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784239555;
	bh=fcS4b9vAtWdCN+62UzcaB4rNWwTsvRdUfvJxbOGNkKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AavenVYOnEtwmL/Ejrhyn7WJ1KJKV1COd5ZSO1S3VZCPthKYpEJ+/02dprzp7GrwY
	 1N9GJOOKhvPl4WtSf920rfRi8YvutNdqZlhg798j1kuRyGdyiGNReRR9ZKoZHNtuc6
	 HYT1EoAkvHJQ09qtZPxRDERUhmNHhJ296cOP8yNM/qs7QkmDl+4wd16QdX/ey4qUZE
	 E8q1qyDFyc3j5ZmEKXCs7iZH+1it1T4NSa3gqmSQcgw4K6aFpnI0EiOi/27VwDrhyG
	 FENJZNG9/A/VL5J7u9xraQLk2btWC2NWkgw95BDa+tlGR7dX+L/JD2UTxS4O288VCU
	 ohhW0a1hKps2w==
Date: Fri, 17 Jul 2026 08:05:46 +1000
From: Dave Chinner <dgc@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, xmei5@asu.edu
Subject: Re: [PATCH] xfs: validate inode log item regions during recovery
Message-ID: <allVuuJJjZb1jfBJ@dread>
References: <20260716174813.3627911-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716174813.3627911-1-bestswngs@gmail.com>

On Thu, Jul 16, 2026 at 10:48:12AM -0700, Weiming Shi wrote:
> xlog_recover_inode_commit_pass2() replays an XFS_LI_INODE item straight
> out of the log: it dereferences ri_buf[1] as the log dinode and copies the
> data and attr forks from ri_buf[2]/ri_buf[attr_index], but never checks
> that those regions were logged or that the dinode geometry agrees with the
> mount. ri_buf is sized by the item's ilf_size, bounded only to
> [1, XLOG_MAX_REGIONS_IN_ITEM]; the number of regions actually filled in
> (ri_cnt) and the fork copies are guarded only by ASSERT()s, which compile
> out in production.
> 
> A crafted image mounted for log recovery can thus hit a NULL dereference of
> an absent region, an out-of-bounds read from a di_version or di_forkoff
> that disagrees with the mount, or an overflow of the inode fork by an
> oversized local or extent region. An item declaring a second region that
> is never logged faults on the log dinode:
> 
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  RIP: xlog_recover_inode_commit_pass2 (fs/xfs/xfs_inode_item_recover.c:370)
>  Call Trace:
>   xlog_recover_items_pass2 (fs/xfs/xfs_log_recover.c:2011)
>   xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2078)
>   xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2328)
>   xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2502)
>   xlog_recover (fs/xfs/xfs_log_recover.c:3486)
>   xfs_log_mount (fs/xfs/xfs_log.c:667)
>   xfs_mountfs (fs/xfs/xfs_mount.c:1039)
>   xfs_fs_fill_super (fs/xfs/xfs_super.c:1965)
>   get_tree_bdev_flags (fs/super.c:1680)
>   vfs_get_tree (fs/super.c:1803)
>   __x64_sys_mount (fs/namespace.c:4433)
> 
> Validate the regions before use: require ri_cnt to cover the regions
> ilf_fields implies, the log dinode to be present and at least a log dinode
> in size, and di_version to match the mount. Replace the di_forkoff check,
> which can never fire (di_forkoff is a u8 of 8-byte units, sb_inodesize a
> byte count of at least 256), with xfs_dinode_verify_forkoff() (exported
> here), and bound the local and extent fork copies against the destination
> fork. The btree-root formats are logged in their larger in-core form and
> converted on the way in, so they are not bounded by the on-disk fork size.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.h   |  2 ++
>  fs/xfs/xfs_inode_item_recover.c | 59 ++++++++++++++++++++++++---------
>  3 files changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 336ef843f2fe..71311c4fc2ed 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -479,7 +479,7 @@ xfs_dinode_verify_fork(
>  	return NULL;
>  }
>  
> -static xfs_failaddr_t
> +xfs_failaddr_t
>  xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
>  	struct xfs_mount	*mp)
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index f3624532b023..d120675f6c07 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -27,6 +27,8 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
>  
>  xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
>  			   struct xfs_dinode *dip);
> +xfs_failaddr_t xfs_dinode_verify_forkoff(struct xfs_dinode *dip,
> +			   struct xfs_mount *mp);
>  xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
>  		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 169a8fe3bf0a..8ebc8eaf9e03 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -366,6 +366,13 @@ xlog_recover_inode_commit_pass2(
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> +	/* ri_buf[1] may be absent or shorter than a log dinode */
> +	if (XFS_IS_CORRUPT(mp, item->ri_cnt < 2) ||
> +	    XFS_IS_CORRUPT(mp,
> +			   item->ri_buf[1].iov_len < xfs_log_dinode_size(mp))) {
> +		error = -EFSCORRUPTED;
> +		goto out_release;
> +	}

I'm going to push back on this sort of piece-meal validation - this
is not the place to be doing random "is the log item valid" checks.
All it does is make the code harder for humans to read and
understand.

It is inconsistent, it is not applied to all log items, the checks
are randomly distributed through the decoding and replay logic, and
it's impossible to tell what checks might still be missing.

We have a solid metadata verifier architecture for a reason: it
centralises all the metadata verification for an object in a central
place, and it always gets run when the object is first read from
disk before we try to do anything with it. The verification is in
one place, and it is easy to audit to determine what parts of the
structure we aren't actually verifying.

That means when we actually got to do an operation, we already know
the structures are valid and do not contain corruptions. Issues like
the log format structure not having enough regions is not an inode
log format problem - it is a generic log format structure problem.

Addressing these issues piece meal in each log item decode in pass 2 -
after we've already parsed them in pass 1 and for readahead purposes
- is too late and too random.

Use your AI tokens to do something properly useful - add an object
verifier layer to the journal recovery code that robustly verifies
objects before we perform decoding. We already have type abstraction
for items in log recovery (i.e. struct xlog_recover_item_ops) and we
already have two passes over the journal (XLOG_RECOVER_PASS1/2), and
pass 1 is used to set up state needed for the actual recovery in
pass 2. IOWs, we should be using pass 1 as a full object verifier
pass in addition to checking CRC.

This would allows a clean separation between validation and decoding
of log items and their formatted structures, and allow the recovery
logic to be simplified because it is no longer mixing recovery with
validation.

This will allow us to add full, robust validation for all log items,
and do it in a way that is easy to audit and identify parts of
structres taht we haven't verified or are unable to verify easily.

This is the sort of thing you should be using the power of the LLM
agents to do - it's a waste of tokens to be trying to find and fix
issues hidden in the code. Build the infrastructure that makes
verification -robust-, and that will almost entirely eliminate this
class of bug from log recovery.

Use the power of the LLMs to address the underlying problem, don't
waste time and tokens getting it to apply bandaids that don't
actually help address the underlying issue.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
