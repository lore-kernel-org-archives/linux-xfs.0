Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489665;
	b=r4/y09Y2V67qI+fvpyDaSffrCmwLQz6YeLUoxdKM+gh10n2qf3YFMEWHYe6vwJvlPrRY
	 wrT8Xu2LvKxuA0rW5gv4o9d8PXLur9WsEv4ovA+AGfBABY9U7qK+1S6vh3jlALtef3cjK
	 DC5FgoKxHKOFynv9LwsOovbgcu3GPVMhr8Hvz3+criX48oshWcH+QWvE+h1V+ESwlACro
	 eIPK+j32lU9cXcHVoGvF6Q20tS0b7qAGzrAF4TEWAaaJuUEl1NAOAvh3aA1lj5x9RKOsI
	 9ui4Y+1KSnMyOGJhAsouTXF7cudH7oIr7orpzefYuMU5/fPcJTdYVXXMvJiOgrQhKLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489665;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2TVb8qDZ4KT/CTu1G3B1wlWvG0RXp8XP3qjnuNYzjOg=;
	b=u700fACwqvVEU56bLfh8WQT77aVbb9Za0mlXenYTObhpIcmBSILWk40+I6+1h1NmC+RF
	 huz/poklpHrmwoDwgjybIIh0AmKpa0U41NrHSPjR8+IclCi5MfsGF61glld/l+Eowd+Ki
	 NqG1oKHSm1vx2uyvO6EJ/DOtfSZ46Y10owoeHL3UDF4vTu/MzdlaIRy+UIEMb00dQuWcQ
	 q4pMD/AEwkxECTtg575SYulwVJEOw2SllwI0Sy4Wzr54DvYBG+SRV88Wi+4gPevbxGbzR
	 ppOKyqwrSFE/arHyDwL3EpG1mFzRmJmrxXYkQG2GLtEBORkFaP1qaC15uaT2hEzc9rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MmvF84R0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC2606A330;
	Thu, 12 Nov 2026 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MmvF84R0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D581F00A05;
	Thu, 12 Nov 2026 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794489664;
	bh=2TVb8qDZ4KT/CTu1G3B1wlWvG0RXp8XP3qjnuNYzjOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MmvF84R0gtLndw24gzSFT3ub5yJmtlvjtQewwlBkOj3aPXQTksQ4drEzrc46OvL/z
	 wo9GRa3UsS1F1xzmaEOQVjwk+tWBf2XT/7mCHBb8HSswe2CPaa8KtfXoHjL9Y0GbyO
	 1efF5XqnKzznSG9DEGEO7OMYE2iaaSETCJ8OFamxUwQlBUJWVpDt1tjvUs4hkM1QL2
	 IWFg+ih4NX2foIqjeWjsniqTNNlHAD8H5+koYNsWz+ArokDl49tjta/Dn88XnGLkGJ
	 3S6OKico8mJafJNwprIMppBt+ZwOOYREUSFE9sMr0CwvZQk9NrRSiDsIISSMrUCwF/
	 4a2UthzwC3fuQ==
Date: Thu, 12 Nov 2026 14:20:58 +0100
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
Message-ID: <20261112-besorgen-nobel-handschuhe-fb3373259b5f@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
 <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
 <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
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
In-Reply-To: <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>

On Thu, Nov 12, 2026 at 01:01:34PM +0100, Christian Brauner wrote:
> Fwiw, this leaks the inode's anonymous tlocks. They're from TxLock which
> is shared by all jfs mounts. txLock() also sets mp->lid and pinned the
> metapages with metapage_nohomeok().
>
> So the helper would have to tear all of that down like txAbort() does
> and drop the pins. Doable, I guess not sure if this belongs into the
> series.

So ok, I tried to do this in a vm. With jfs.nTxLock=256 three rounds of
error + umount leaked 163 tlocks and the next writer on a fresh jfs hung
in txBeginAnon().

I think txAbort() might be the wrong model. It only drops the pin when
mp->lsn is set and doesn't free linelocks. So this would need a helper
modelled on txUnlock().

Fwiw, the BUG_ON() also triggers without this series. The error sets
SB_RDONLY, sync_filesystem() bails at umount and nothing commits the
anonymous tlocks. This series fixes that as a side effect because
sync_filesystem() keeps running.

> All the check
> does is make syncfs() return without writing anything and make unmount
> drop whatever the flusher hasn't gotten to yet. Which might be the goal
> you're after?

I tried that too on fat and ext2. With the check and an umount right
after the error new files are gone on both. If the flusher ran first
nothing is lost. That's exactly what happens without this series. If
writeback is allowed to finish nothing is lost either way.

Skipping these superblocks in the flusher is no better. ext4
effectively does that in its emergency state (ext4_writepages() bails)
and the stuck dirty pages throttle everyone else from testing. with 1.4G
stuck on ext4 a dd to ext2 on another disk crawled at ~1MB/s until ext4
was unmounted (cf. [1]).

[1]: https://lore.kernel.org/r/ZEnb7KuOWmu5P+V9@ovpn-8-24.pek2.redhat.com
