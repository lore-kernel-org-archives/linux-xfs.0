Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C038E3D3CEF
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989969; cv=none; b=Jqr3lR5liYKKm7WA8DfF/zIBwqhnRfi3cIwQzITWKetqARzR2e4P7OmMhvGKt8+r3pOREB9oI5j7gwK1ftUWTLSIm5Kr4hJ4y/2zBPyt2VGwEz7twZSBlXgLmuynDPXdR+PhrR+4Gz7Qb8MmVaNyONGSmW4238lFBHvV6QK1Xfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989969; c=relaxed/simple;
	bh=7CMqPC1akXpRYe/kp0aQ1mj/o9zMBpa/0ZojZHVXk/s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LHZoTm+LQBZOiqYRIyWfMKhNhAHlMcgZiPJuaVXVbZRF8Qn3OqN4DURMR5NwswPfwrwXt33M74/yPRiWN0VdNSxQPrYSFPUo6wsyrEO6SU7sA3Fovui3IDqPIsdRCj1PQJoEmsQXkq4J81gQlPDNvf4jAKQ3WdHNeerdYeWWU6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J87OYZdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J87OYZdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2671F00893;
	Tue,  9 Jun 2026 07:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780989968;
	bh=VBZdKfYZpoHn7Rt/D6OC0yMiEM4K5uosRXIA03J7xus=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=J87OYZdFvBqWzajKngpuIX6TchNrFQjWUJE+MAYBUmwzxAlcLzeyOG8rTPtT4arP3
	 8l/iEwp62mVEBlSXPfPqurGCAsU5yv2hU75vwhbBvCtWMa00+xhFFww+0jZMr9RN2P
	 hUbEb5ilrUnkof0avld6x2mS4fia0HzU+aWuJFPN0HA/Xm+Ez1R1rNz3j3A3bitsxP
	 9R3vvmK7S3GqnvjL4ES8j14xMKqvmJ92qGqUBtlXV/hEyNIzvkQSFe2scpX+lFOlvM
	 7h+T8bJ+9O1rx0oGs9OZ+UJLzJZBEFHrUlTM6qf7SAYdnu0wh0h4hdXU3VevA1AwcB
	 5Vb5K8Pcn4DZw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Subject: Re: remove struct xfs_inode.i_ino
Message-Id: <178098996781.72840.11279627351190491626.b4-ty@b4>
Date: Tue, 09 Jun 2026 09:26:07 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Fri, 15 May 2026 15:50:21 +0200, Christoph Hellwig wrote:
> now that the VFS inode i_ino field is always a u64, there is no need
> to duplicate the inode number in the XFS inode.
> 
> This series first adds a few helpers to reduce i_ino reference, and
> then switches the rest of the code over.  A new I_INO helper is added
> to shorten the dereference and to make userspace porting easier.
> 
> [...]

Applied to for-next, thanks!

[1/9] xfs: add a XFS_INODE_TO_AGNO helper
      commit: a22166add624818a6c43b807d37f99483ba268a6
[2/9] xfs: add a XFS_INODE_TO_AGINO helper
      commit: f46edc9f1310d27710e2b39bf561ecef51f879d2
[3/9] xfs: add a XFS_INO_TO_FSB helper
      commit: f8b7c9a8b0a9e43b054981d134b426d9464264f6
[4/9] xfs: add a xfs_rmap_inode_bmbt_owner
      commit: ee237a900ceef00c8d1ca17a5cfadbd50fba67e9
[5/9] xfs: add a xfs_rmap_inode_owner helper
      commit: f882fc7dd9f04f73d94379deb9e68d8db613c976
[6/9] xfs: add a xchk_ip_set_corrupt helper
      commit: aa7cfdb6e16b474328c79736f9b9dad09addc81c
[7/9] xfs: convert xchk_inode_xref_set_corrupt to xchk_ip_xref_set_corrupt
      commit: bef4cee25fbc26ee8b07028e461190fa57b02788
[8/9] xfs: remove xfs_setup_existing_inode
      commit: 79c1363d33c170b844706a571f150192ffcefbdb
[9/9] xfs: remove the i_ino field in struct xfs_inode
      commit: 1113a6d6d5d1336f4415fa1367aac0f853f0892d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

