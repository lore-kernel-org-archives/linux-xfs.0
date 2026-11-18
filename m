Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992344;
	b=stOq7hBucYbUS69MlfdQjgXD5/THzFtHdd+3eLrhKIgt4mHqgtQ8xmes3RP8xnW962Oc
	 O7Hft/wH7PW6gN0AOWTkzDQJZY0hGBofCThkBtR9XHDt9xxzpr3GG5y8iN4CP2yALm4sJ
	 gHrKpmP6iR5py3RTa5xRsM0VANDDVbKt/qaxoI7Bml3xL+otyaGwVVcu2ZfNpK0hH9TQ7
	 EQM3nO68BCdtKCOk85POvhYa9TGX8qR95VGdwgMJQ05aI+80Oh0IAEBTaDOHGz50MHg8F
	 flTwpVpo762v6i4NZRjh6eLNLbqaZL29KheH7jV5rDnxbQBYq7rz7GiZ4uEtLOi78kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992344;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=p+YG61+2lhYGrgJAqcQyUnj5gjk8KRyHfZQyj97I/QI=;
	b=gUryoR3IMx2uyGzjteKI9kNEsvPPWXPJ8u0DhxEXL8mvyHG+dN0JJIu5IryRMG323JM8
	 Ofeaw+/NEGn2rpszAGbY2X5JJJb+M9oWyupDbJEc4XVLFmsUOzz0HFelMJrGsKTuIr4ae
	 BfG4bHiEuHH7/XZQf8EBhHDy8THdL45e4nN8jR+0YAYNru4uSi+8Tacv/s9M9Lsk6lKYn
	 4gTBdmQ5KZfKJyU+1jl0Yon8u8SLoqSSUXB3dV3ShSNKrMWOc67I0UV6s8Cidos/6KqGp
	 u8LvX+XouBK2Hpt11VIDkISfwC3yeIKIvaGUcLn0Uyo7jr478nMw4Awxb4+3eB+Vj2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ViK/EOUK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4680606A31C;
	Wed, 18 Nov 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViK/EOUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBC01F00927;
	Wed, 18 Nov 2026 08:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992344;
	bh=p+YG61+2lhYGrgJAqcQyUnj5gjk8KRyHfZQyj97I/QI=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=ViK/EOUKalb1prKjUIp7x+NihpSUO/oReTAmeklGFiUWr+JC0CqrTfYt3yRXTQIhX
	 4oYdE62S1oAwTDQ0gd/1pR7AtIvZ1Pa1C2TxvM/jblnWZvFOycCx1NMvMhHq5M/+T8
	 11rVoQd2mzo265y1mli0Wf5ppClHVHQsXEP/VRnvbciDTtOUQgE507GQ2EloPDhoH+
	 ur83Pg8rPt51cN6rPdvx5e0AikGaCBhgdJUWf7D/4EcooUs1f/qtjDL8ud1KpBB0qq
	 49l51TQpZVBgSqlDVgAwGwT/tfzPqr7njAv9P6iZ0Cbygl4Z6hKkT1ZIPRlZKJAeWI
	 S4Z8uYIkUzz0A==
From: Carlos Maiolino <cem@kernel.org>
To: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
 josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 tz2294@columbia.edu, brauner@kernel.org, Chris Mason <mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
Subject: Re: [PATCH v9 00/14] reflink and atomic write bugs
Message-Id: <179499234159.5574.7187095568951429317.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:59:01 +0100
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

On Thu, 12 Nov 2026 16:46:04 -0500, Chris Mason wrote:
> The meat of the series is fixing reflink corner cases that incorrectly
> let you write into the source of a reflink.  LLMs also tripped over a
> few ways to use atomic writes to expose stale blocks on the drive, and a
> few races with realtime flag and extent size hint manipulations.
> 
> Carlos has accepted patches 1-4, but I've kept them here so the whole
> series can still be tested.
> 
> [...]

Applied to for-next, thanks!

[01/14] xfs: don't skip the flush before shifting extents
        (no commit info)
[02/14] xfs: flush the shifted range before changing the file
        (no commit info)
[03/14] xfs: don't change the block map under a dirty folio
        (no commit info)
[04/14] iomap: don't punch delalloc under a dirty EOF block
        (no commit info)
[05/14] fs: validate atomic writes after O_APPEND and limits
        (no commit info)
[06/14] xfs: recheck direct write alignment after write checks
        (no commit info)
[07/14] xfs: test for reflink after the dio write checks
        commit: 3b6942b132033cbc3f6566f698709d9038daf7b2
[08/14] xfs: refuse writes to files racing with realtime inode flag changes
        commit: 7b2438af4d91dcb8fe3de99e55beb06f3c168309
[09/14] xfs: test for always COW after the dio write checks
        commit: bdc3ee45df55d8aa478d8a5d6a7e9b1186f511ba
[10/14] xfs: refuse fallocate racing with realtime flag changes
        commit: f01f70e00770c6d21b468f80b488e6407a6947dc
[11/14] xfs: take the MMAPLOCK in xfs_fileattr_set()
        commit: 230565493938cc0284116ff3795eb5343781eb97
[12/14] xfs: restart faults racing with realtime flag changes
        commit: 03cbbd80a3e7070e8ab63996a94a7815722c2578
[13/14] xfs: don't enable DAX on zoned inodes
        commit: 44e555acd77a839110f3b1e02a75f9165baaaeec
[14/14] xfs: test for realtime and reflink under the pNFS locks
        commit: 855abf2cf8cd69a248362ca4b518de9387dd6bf5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

