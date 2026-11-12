Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794484901;
	b=bmDDCcw77wIxWcFvO2VZsmtypk3dBAY68z1q5/YO/KXz9bZgorLr5x4PUnyx++QGF2Kx
	 4lfBBKQl0LP5jhx0Jfn2UFMk90O5IfMagFW4rFSOvc4Sh5PaMdXdn6bCHOWn78palPH2J
	 UobA+bOjXZSY2sHQyRbzeVmAGKDdV6bJUa6UVhHYApoXxe8VbnS3FlNUFYGNb3w+Uiqae
	 AqHLu6eDCeuuPzn04luG9VJgsX3sKW8xkDur03hmXB7BxdJr4xVHS5CKt94Y9XmFuYdfb
	 LuYzotHiM3GbX6UYzlGnBc3x1Bg3yeTWAu9acgdaZD9GwrE+K/SUV406qHNrHNmv1AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484901;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=54I5bKtP4WSw79RGADSyevDuBquelpIbRaI3K1RVgo8=;
	b=SRdLbN+3Cdgn7G6uU6Wy5X/mMytQ0PVlRRGvvyzwEvlrwK3LCpuwXLf5AiEjlIDRHpEQ
	 28EFvUZmSiH862dBo56Ij/dFwcwJsPw0ukS5uJoG4ogVoE5a50kuwUH/RJIvzZ+zKt+iE
	 +q1LXx52aQIvRwhY/EL6oEor1I8UGSk4Jx4Ba+1BDJcFo16wBBBqCpuho05pyzjQQmFMR
	 AJ5uBJ0gDGtitPZaFIVjEGTbX4J8WeLtboI0IeoSvTpyzdQW51wlmoibI7HFQLp2DhHp+
	 /duaZWrejqy4h36Ma3Xer0Js3HwvW/I44CEirOzwZWdYAEjaBWYHfhSkX9viXij5Crw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QprEbjuf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77299606A896;
	Thu, 12 Nov 2026 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QprEbjuf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA7E1F00A06;
	Thu, 12 Nov 2026 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484900;
	bh=54I5bKtP4WSw79RGADSyevDuBquelpIbRaI3K1RVgo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QprEbjufNb+tvrOa7rBrGmxplqbmNy39Rmf2KUfr+AHg8IrdqKnppWAi/6c1jQ5lw
	 1qQwMsR8fpHwFmAmOjHt6xx/GSD6lfIfUEbOqwxFxYqpUqqxaGguK/FgeQ9b4yse7n
	 X5Gu+V8HvIKolxJnQl0GAY0dMopIoY1Zswfa1hVJnxH54H1V2CcTIR0C3XNIO1kYQQ
	 jb08MOlodWLAKvfmxQBVrfP5uY0qBjF050j5MxuY9KrdgN1iuTLU+0ziIbWc5XAA1N
	 31t4iwXyBD3El+zm85fqmePh/BsB9Y9+wkUwIt81ymt+t2A7BgUdE1+/gxOp3PTE+D
	 sGRcdsQZ5uAtA==
Date: Thu, 12 Nov 2026 13:01:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
 <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>

On Wed, Nov 11, 2026 at 03:15:11PM +0100, Jan Kara wrote:
> OK, so instead of BUGing in jfs_evict_inode(), shouldn't JFS just do
> something like:
>
> -	BUG_ON(!list_empty(&ji->anon_inode_list));
> +	if (!list_empty(&ji->anon_inode_list)) {
> +		WARN_ON_ONCE(!sb_emergency_ro(inode->i_sb));
> +		/* This needs helper in fs/jfs/jfs_txnmgr.c */
> +		TXN_LOCK();
> +		list_del_init(&ji->anon_inode_list);
> +		TXN_UNLOCK();
> +	}

Fwiw, this leaks the inode's anonymous tlocks. They're from TxLock which
is shared by all jfs mounts. txLock() also sets mp->lid and pinned the
metapages with metapage_nohomeok().

So the helper would have to tear all of that down like txAbort() does
and drop the pins. Doable, I guess not sure if this belongs into the
series.

> So that JFS doesn't block everybody else? Because conceptually, once sb is
> marked as emergency read-only, we really want to stop writeback so letting
> sync_inodes() run seems moot.

Meh, but a check in sync_filesystem() doesn't stop writeback? The
flusher doesn't know about the emergency state and keeps calling
->writepages() and ->write_inode().

And kill_block_super() calls sync_blockdev() after
generic_shutdown_super() so everything in the bdev mapping
(FAT, bitmaps, inode table blocks) gets writeback anyway. All the check
does is make syncfs() return without writing anything and make unmount
drop whatever the flusher hasn't gotten to yet. Which might be the goal
you're after?

> Argh, also NFS I assume. OK, that won't be easy to get rid of AFAICT (we
> generally don't have mount available there).

So nfsd_setxattr() takes write access to the export's mount via
fh_want_write(). So this would get EROFS from the VFS. Afaict it's
ecryptfs and IMA? ima_fix_xattr() only checks IS_RDONLY().

-- 
