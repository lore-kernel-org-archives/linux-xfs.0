Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329325;
	b=SgXHmGX+FX4gOcv3c6xsoIaVuTK8HY4AyhgfqddQKWeQU9/UAwjbql+qfoR5OZtkUYss
	 O/7FQHdbqXgzCLe89TOn8uJfsUeerVwvwla13/fEYkO4Ojv5OftLEV9iPNls2C7+69dC2
	 YP5ABzjMFOXBtsvZAQKz6v/4+9yaOIdBQobZnsHJ9l7HjLaOrafWpVCGG3osJQtaPGepI
	 wkFnxOwKSmBuzhBSh9sQCdYR3VsNKfTk6S0xEkjgu+QelXm6xsBETEQ5pNzGdqdavEiEx
	 mvqvnE8EPHZsw/oN+iy8o0+bBWkEtjCtzFi+M6jsBDzcDnGjscY2zTv5wr64DLnBdgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329325;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CHLQ7b2LcR7am1RKbZkh1e8kwZYbJ2OrwqImdsIBbbw=;
	b=WBILiFV1rgd4C6QPWIaRsicvbBJJOQCkxGY43DnLonmpm9BOGZwqAqYd3XxlLQrcI9rQ
	 9rrjP5oKv8hDDQUElKEbpUerwPcqR7liZ6RBqraQY+iB1OQXhmZHZls5Qn+GTHaD9fml1
	 HGZIfhy3Xxo0+UJWoN3vNpcDAR5a4dOUGHA0kESG/FcaHDn8GObL7A21lO+il2q8O3BjT
	 y1Hp1v0nyHNK9D4XZWRW4qYgueGFDaNKPeyH5Upg6wpkJilOY1bz9h88IVrwTceM6/q2v
	 vCoYOtSyIdAoLOoFBepz2WnKl4io88yUmkhcKTKwI8F/ZVE96gZCKljRVm174eYOOiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P3EUpEDX;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E82A606A31A;
	Fri, 30 Oct 2026 03:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E82A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P3EUpEDX
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793329320; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CHLQ7b2LcR7am1RKbZkh1e8kwZYbJ2OrwqImdsIBbbw=;
	b=P3EUpEDXjFYc7t9vYYRCz1pheQWh2OCsVgQHajoLYY7mar314/KyFODZ1m/Bx3732YPlUX/9mgkhkxHtZvlKaP/r8tG5iUFYR6RjeVEzRHEvZlb44qO001lYjE8WqGw+itEsYWrea5uNPR7AtSB9r2wsmY6F8l5pa5OuFFW0k30=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDkxfAa_1793329318;
Received: from 30.221.129.214(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDkxfAa_1793329318 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 11:01:59 +0800
Message-ID: <736cc238-0af8-417b-bf3f-5e8b002badaf@linux.alibaba.com>
Date: Fri, 30 Oct 2026 11:01:58 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/34] ocfs2: don't set SB_RDONLY after filesystem
 errors
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/26 12:07 AM, Christian Brauner wrote:
> With errors=remount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
> without holding s_umount. If that happens while the filesystem is frozen
> through bdev_freeze() thaw_super() leaves the s_writers rwsems locked.
> Writers hang and so does umount because ocfs2_shutdown_local_alloc()
> needs sb_start_intwrite().
> 
> The soft read-only state doesn't stop modifications on its own. Every
> read-only mount sets it and those still need transactions for recovery,
> the local alloc and the truncate log. Everything else was stopped by the
> VFS because of SB_RDONLY. So call sb_set_emergency_ro() instead which
> keeps it that way, and keep setting SOFT_RO for the existing
> ocfs2_emergency_state() checks.
> 
> The xattr and ACL setters get a check of their own because ecryptfs
> calls them without write access on the lower mount. It sits in the xattr
> handlers and not in ocfs2_xattr_set() because chmod and setfacl store
> the ACL through it after the new mode was already committed.
> 
> Quotas aren't enabled at mount in the error state because that writes
> the quota files. ocfs2_sync_fs() doesn't flush anything anymore and a
> remount to read-only doesn't suspend quotas. Q_GETQUOTA, Q_GETNEXTQUOTA
> and Q_SYNC can still start transactions. I've left that alone.
> 
> Writes through file descriptors opened before the error fail with EROFS
> and umount completes instead of hanging.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
