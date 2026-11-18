Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992330;
	b=4AxY1NHjHk8YxQCe2ZSNXxZxhDsZIx9YBhwe6cgPQ+OG56274DF7pAg+Ecs2TAV0iKcn
	 REHnvggr/r0tklSVNWOTJWxYsH0FqTYZBgwGJR+DkIfxCAaGUIj58Xus5CHYUBdfFw0uJ
	 Z0WAes2Amp5+zetuwqNg7jcRpJmS9MippwH5aBsSVWAElku0XukNMTs9ta3CJ6FNm3FiI
	 d8CTUEF5JbF1UUqMHnTKJNTOBBWECKepQC+bwfi0Lo95Ki4C0nkZWS6JGNNcNCeWirtfq
	 twwnwwB9J4dSFzKlbs53jRYVVa0dx+JbiQ093gNyFoD/fP950mcYaKrgU/gAOb0x1hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992330;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=RTTCF8568XkltgAqgTZzFr2FWC0CGyJ3HY1uzqOXIq8=;
	b=2boRk0UXJ5Ck5FZyyYHaSzTXdqVDgzZcdP6btcV6lv7dDLKXe4RCh147N8jA6xg/kHc1
	 M78y7MIGx5Yv8klmCLT3OyTMBfhVJ5S+nF+mHXc9dIgfLRS8q2QjYC4andif0gFhNrsss
	 IzatYWeOT1PucHv49e91xu1yxznxAvzDuHBjsgLVKKuiKDaweICNdsxcY907mIokqqMAf
	 fuk3buFV0M7uaNqN6ZVVje+Gfjh9gLpbxIeYzHjlgX8GzMWPtmU24TFt4siwQMRDv/05s
	 KCeglOzWi64o04R3N92gh9kcyCXsfjrmXjJhaWgKWJFu9a9+QdHW/EwhmA++PC0sFUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzO6zLxX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81F5606A31C;
	Wed, 18 Nov 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzO6zLxX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98F01F000C4;
	Wed, 18 Nov 2026 08:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992330;
	bh=RTTCF8568XkltgAqgTZzFr2FWC0CGyJ3HY1uzqOXIq8=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=jzO6zLxX3njqOLXwahPKUfVvDyYjS5LU6MWTWNqR7Cgim2hwhVt1AqJBjAuPcRboM
	 4/fq9im7485E7W5r6kUj2PAhB7EnfsmEcLzFu5ykyBWkzxAv0NJObpIJDYNpOxGVjg
	 WEHjIWTAl6c+bxFA4kHRRGGxEwlS/cVcqCHAbnLy2fLn987MO7IANZyRJiMccfdoSn
	 JD6TlRlnKsh+JBXHwkjMNusqCv+F3eO6QjyuitNqgN1y1eMXs4G6BuA9nHqxbY0Ier
	 RvU3AKauGZiamADH874iNOvsq5fs1ltSe0vHAPlJ08lN0AWPpDbBRP7oQXNzwVDMNK
	 8ukNpQmA+Nb7g==
From: Carlos Maiolino <cem@kernel.org>
To: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
 josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 tz2294@columbia.edu, brauner@kernel.org, Chris Mason <mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
Subject: Re: [PATCH v8 00/15] reflink and atomic write bugs
Message-Id: <179499232752.5574.398287961322700808.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:47 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 11 Nov 2026 20:02:29 -0500, Chris Mason wrote:
> [ the send command got interrupted apologies for the two dups ]
> 
> This series did a few rounds privately, but looks ready for the list
> now.  Carlos has accepted patches 1-4, but I've kept them here so the
> whole series can still be tested.
> 
> Except for Christoph's patch, these were all found and fixed
> by an LLM.
> 
> [...]

Applied to for-next, thanks!

[01/15] xfs: don't skip the flush before shifting extents
        (no commit info)
[02/15] xfs: flush the shifted range before changing the file
        (no commit info)
[03/15] xfs: don't change the block map under a dirty folio
        (no commit info)
[04/15] iomap: don't punch delalloc under a dirty EOF block
        (no commit info)
[05/15] fs: validate atomic writes after O_APPEND and limits
        (no commit info)
[06/15] xfs: recheck direct write alignment after write checks
        (no commit info)
[07/15] xfs: test for reflink after the dio write checks
        commit: 3b6942b132033cbc3f6566f698709d9038daf7b2
[08/15] xfs: refuse writes to files racing with realtime inode flag changes
        commit: 7b2438af4d91dcb8fe3de99e55beb06f3c168309
[09/15] xfs: test for always COW after the dio write checks
        commit: bdc3ee45df55d8aa478d8a5d6a7e9b1186f511ba
[10/15] xfs: refuse fallocate racing with realtime flag changes
        commit: f01f70e00770c6d21b468f80b488e6407a6947dc
[11/15] xfs: restart faults racing with realtime flag changes
        commit: 03cbbd80a3e7070e8ab63996a94a7815722c2578
[12/15] xfs: test for an extsize hint again under the ILOCK
        (no commit info)
[13/15] xfs: resample the extsize hint after taking the ILOCK
        (no commit info)
[14/15] xfs: resample the COW extsize hint after cycling ILOCK
        (no commit info)
[15/15] xfs: don't enable DAX on zoned inodes
        commit: 44e555acd77a839110f3b1e02a75f9165baaaeec

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

