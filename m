Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CA733F383;
	Wed,  1 Apr 2026 23:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775087836; cv=none; b=R8fa5qHxfNSo8xVFTj651cD9P4aDd2LNf36OA5AOM4fa9HfaUx4wJrZhHhSYLw1gt46Vt6XPuxFssOdrC6VfVWcKP9DC6e93yU9LFW33VjkVIpMLIWSUi8FTJhX2zlw4BoblM9GJZxpqhdAxVlDxOKTcaQiRGve4CAKygYq3B5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775087836; c=relaxed/simple;
	bh=tcQn0jNvskFSJW+K9iuub+kF7CbhB6AAKIoY7X78kfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pPgqirgA0Y7aLCKM8j1bzWF+Q5nKvhZ1n5dwjXj3YihJCHI75cqw298V5ckAeKDIOTyod0QCe7WWqUJLIBlm48+SoEA/b0V9x0ujYoRjllXlvB3aAx65ikd7j+v5SNNOfvLuEU1OiXHaabB9EzaUKuxc/n1AWJp1yuiOzCEIPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmqH/gYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmqH/gYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E119C4CEF7;
	Wed,  1 Apr 2026 23:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775087835;
	bh=tcQn0jNvskFSJW+K9iuub+kF7CbhB6AAKIoY7X78kfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pmqH/gYS7H3A8WIi5YaQwSPGuloLcc9oof281lzvAWGN4iW/sx8PxnpcmLa0fkTwI
	 VLuQCSdS+pad4iKkwf6iYNFDE3CubyeXY+Gg9/AM262caq/JvUaUw9j3K8YSzBXyO3
	 /8B8BvgqIyeJ3QXT26IHd05FmQsg/BwIrsJXNwDoiYKa/Xn45P1xdC1LR1QKuve4fe
	 O0rVwIHQmzCtvy1QZm33yuuaFlHzDjwoQWgGejb3a8A84Lx1VmzrRtNWZ3YQ39eBYG
	 HYB8qVoDf61xKIhY8HVfbWP+sT3x02HLL0iH5yOeRFZWBdyKrOjTQTwiuyIWlU9A7Q
	 3zO85+iKzq84A==
Date: Wed, 1 Apr 2026 16:57:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 15/22] xfs: add fs-verity support
Message-ID: <20260401235713.GC14247@quark>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-16-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-16-aalbersh@kernel.org>

On Tue, Mar 31, 2026 at 11:28:16PM +0200, Andrey Albershteyn wrote:
> +	/*
> +	 * If this is a block full of hashes of zeroed blocks, don't bother
> +	 * storing the block. We can synthesize them later.
> +	 *
> +	 * However, do this only in case Merkle tree block == fs block size.
> +	 * Iomap synthesizes these blocks based on holes in the merkle tree. We
> +	 * won't be able to tell if something need to be synthesizes for the
> +	 * range in the fs block. For example, for 4k filesystem block
> +	 *
> +	 *	[ 1k | zero hashes | zero hashes | 1k ]
> +	 *
> +	 * Iomap won't know about these empty blocks.
> +	 */
> +	for (i = 0, p = buf; i < size; i += digest_size, p += digest_size)
> +		if (memcmp(p, zero_digest, digest_size))
> +			break;
> +	if (i == size && size == ip->i_mount->m_sb.sb_blocksize)
> +		return 0;

Might be too subtle, but this could be done more efficiently with just
two calls to memcmp():

	if (size == ip->i_mount->m_sb.sb_blocksize &&
	    /* first digest is zero_digest */
	    memcmp(buf, zero_digest, digest_size) == 0 &&
	    /* every digest is same as previous, thus all are zero_digest */
	    memcmp(buf + digest_size, buf, size - digest_size) == 0)
		return 0;

- Eric
