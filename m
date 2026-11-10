Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347453;
	b=e9kTbo3y61VyQ0WDcsTKzUli3Y5t+iJ5DTQ1jQICrBiFB8y8DHdJMBb7V2b2IretXy8K
	 vX65BOB64OsFOgScK8frBsGRMsLvETsVaUSw7jPlanb4YN3VBDcDqy+oziZx+5JMSo3mu
	 SjTjz9xV34SMrOeSOKIAN4QovEoS33epFt0qgr7eF65mq3ceriyONNr6N+5QxILiMSl7z
	 keeAUVOcz498WjLhwsMvJAqYNdF5iIxFrMWWUVEmQSoKz167ZBYrPpIOowUsMlmktJUeU
	 FM7O+kSWbkeqxKe0GM61YSfqJwUa71Aml/ZKJTnFllIl1oMSeSr3Od6lSnyTtfv94vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347453;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jBjh6Hk100+KrECKKCLZMsdZH69ww17QHoFNGmE10pk=;
	b=bn2TqeaGyHV/+dXGcRqcuCxNl3H3gmW+rjLnK0WaNSzS68kVUXTtPwnxkaSizhCFUTS9
	 IKCYLqorhJbRhqL1bWkyBDXOYtRLg/hErtk30OXiZ0jQZg+1tBLTlZrYglWNB/Amh7wHH
	 gnBiORP0pXAz7LFMzl64vj06V7uqOuhZzR4YaQOrcYlYCROgiRSPmp+JFiH5+XTPqgAO2
	 hDR7I3s/xJR++WGNM0pWUX0VTUxBNS9TT7xQvI/A/8jHYXF1QldvsIG2xbPsJFNPJFQMA
	 opPTH65Ys3cRqhvEVfA9uQoW9YqwgBJEf1Kyg09asAvHt6gSlsksa2J4GhRPHl8xF+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KO/XKzwP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582A6606A31C;
	Tue, 10 Nov 2026 21:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KO/XKzwP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2361E1F008A1;
	Tue, 10 Nov 2026 21:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347452;
	bh=jBjh6Hk100+KrECKKCLZMsdZH69ww17QHoFNGmE10pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KO/XKzwPaQTyl6+FijRmvYt7OfljTwf6lBoi7zd24R3KDOXd9HAGCZNC7KAYdyUYj
	 hBJJdYiiuBfGwwWCOmpZV23Q4HudsU1yoE9Rhgry0hTKqHF+nkqklf5TUTaEFUD6GW
	 niIPAXt+6OcJkFypr0b38UaCjrqEIesfHfavg1Y9gYKtIjC8fTa6yKcpG+wwc6ZeTA
	 +T2K7aictElGKSFlX8kES5nifGp4/GVkQJk7tj2mA58Dkifk7h1fG13cfBeo6mHXLD
	 iFLabsTbOzjUzu/9Krncuv56JNmgiwYwErGw5k9p1piJLK7fKkwVgKxFsoVF59iQ+M
	 jJRcPY1T7tJnQ==
Date: Tue, 10 Nov 2026 22:50:47 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
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
In-Reply-To: <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>

On Thu, Nov 05, 2026 at 10:22:07AM +0100, Jan Kara wrote:
> So shouldn't we just modify the sb_rdonly() check in sync_filesystem() to
> use also sb_emergency_ro() and don't bother with modifying individual
> filesystems?

The VFS patch I posted in v1 thread did that. I dropped it because
of jfs. jfs keeps anonymous tlocks for every allocation that writeback
hasn't committed yet. If sync_filesystem() bails after the error nothing
commits them before evict_inodes() and jfs_evict_inode() hits the
BUG_ON() for a non-empty anon_inode_list on umount.

Which is what happened before the series because the error set
SB_RDONLY. jfs_reconfigure() relies on the same sync_filesystem() call
when going read-only after the error.

jfs could commit them itself before evict_inodes() but that means a
->kill_sb() wrapper and a txQuiesce()-like walk over the global
anon_list filtered by superblock. I don't think that's worth it.

> Also if we have the check in sync_filesystem(), then freeze_super() is
> generally going to fail so this check could trigger only if
> sb_emergency_ro() was set after sync_filesystem() ran and before we called
> ->freeze_fs(). Since sb_emergency_ro() checking is pretty much guaranteed
> to be racy (it is just a best effort framework to limit damage), we
> probably don't have to bother with checking in ->freeze_fs() handlers.

Ok, I'll drop it. ext2_freeze() then writes the superblock with
EXT2_ERROR_FS in it which is fine.

> Is this really needed? All the xattr operations go through mnt_want_write()
> / mnt_want_write_file() so this should be caught in VFS...

Not the ones ecryptfs does on the lower filesystem...
Hm, maybe we should make ecryptfs get write access to the lower mount
instead and drop the xattr checks from the filesystems. Not sure.
