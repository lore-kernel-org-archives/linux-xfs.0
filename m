Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182495;
	b=hGuBWi1OW4j1f1KctnQcTLV50nDgDxorC8LsYrOWj7MuSurSE/qGKW8LgYzgqnA8pMqW
	 HAAdbR1xaPhLfe0nxaYwKK8GIvrOt86ZasrdesjQE7yPsN77gfyGsXpY9K1AuWPNOAdNM
	 ewkLV2wNZGlxA2ofg4AJ3AUCPBoQyU+AyMUmPdiGF5D9WK1S9PW+32cjZ8wu+Nul9675D
	 ywUKegp0itjAtc6DW/tN2aDaMP/zKzASpMFf2itkKu9SJwzHUTZJCoB2ZEISHAKrEBnTS
	 XB4nxIQ6rQiKCwoafypoYT8jLR0tvlWwHXTIx5bsIg0/5GSUnhCBTGAP6W+JttBkcBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182495;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yorVyrvEjsI/pI08tOMR7k/hNLNcrp+wcKXtqgKnxic=;
	b=Gv2bIjNkDqpaw/3vsHLYnKzjltHZXCnqfd2IEggHpxpfRp5NgaCM+R+NnP7QtKJ4S22y
	 rxvuGLWH13BA/nG1qtp3aVWmyfWRWYtgGVf2Bha3UuSG+N7/pg73szO4iLm74aLz1L5dV
	 ku+D0vGpHDZRWvI3OKO1VTT4LK9LS4+DQPmQO7CoCv9Fk4OFmHrnG/b5s9S1+67ENiR5y
	 ozwfqteNrLjHN46vFHSQIOxX6hMK9sA8FWO+51gxGT5U43SRXc8zvNJOpK/5B+8+HQY7z
	 l+qKixkFP8AjvpVcfkLvCTiOeB4GwY24v2rXl79BRCfhKflCJB0BvdCsDg/7xoQaeQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gjNKNbCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796BF60A2600;
	Fri, 20 Nov 2026 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gjNKNbCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A131F000D1;
	Fri, 20 Nov 2026 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182494;
	bh=yorVyrvEjsI/pI08tOMR7k/hNLNcrp+wcKXtqgKnxic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gjNKNbCjycSt+/Uu6JA9sGv396EGxM5YQ8Xic84aS6TCMnHWuQq5ClUiUQKy4G9uT
	 MbjoWqHcftw9z6k2g/MA/e5fMHVe3xa0rAn2d7IHPdhMzcnSvCFEa5o6dFBVsM98QH
	 /qVg54D/kNX02CrSEdVaYfXHDfUTq8VpVSXhiEMK27BmVbAXzUgf5AmlGTsJA9QG4Q
	 TavsgG582d39DAXSuKX7xRl05YAjJ73s8EJYsnk8sLlwgp1hFTJC61RnJBLVupUbfp
	 pdAhROrD6SFV1C16QZRi7p2rQC9OFwyovQ2O/ph/EYdwglGcIHSSH3flsZLAIBEzOs
	 GjH7kDuRTv/Ow==
Date: Fri, 20 Nov 2026 14:48:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: Viacheslav Dubeyko <slava@dubeyko.com>, glaubitz@physik.fu-berlin.de, 
	frank.li@vivo.com, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	vdubeyko@coreweave.com, linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v5 1/5] iomap: add iomap_dio_end_io() helper
Message-ID: <20261120-flach-befanden-notaufnahme-b0a663466be3@brauner>
References: <20261118004844.3849979-1-slava@dubeyko.com>
 <20261118004844.3849979-2-slava@dubeyko.com>
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
In-Reply-To: <20261118004844.3849979-2-slava@dubeyko.com>

On Tue, Nov 17, 2026 at 04:48:40PM -0800, Viacheslav Dubeyko wrote:
> The helper updates i_size without any locking, so it can be used only
> by file systems that issue all direct writes extending i_size
> synchronously (IOMAP_DIO_FORCE_WAIT) under inode_lock.

Meh, this should really not be named so it looks like its the default
completion handler. iomap_dio_end_io() really sounds like it.

Name it after what it does. Plus, check the rule. With
IOMAP_DIO_FORCE_WAIT the completion runs in the context that still holds
the inode lock, so the branch that updates i_size can assert that:

	if (size && i_size_read(inode) < iocb->ki_pos + size) {
		lockdep_assert_held_write(&inode->i_rwsem);
		i_size_write(inode, iocb->ki_pos + size);
		mark_inode_dirty(inode);
	}

> +static inline
> +int iomap_dio_end_io(struct kiocb *iocb, ssize_t size,

This is an ->end_io callback so its address ends up in struct
iomap_dio_ops. Please make it a regular exported function in
fs/iomap/direct-io.c instead of a static inline in the header.

> Several file systems implement an almost identical ->end_io callback
> for direct writes: if the write succeeded and went beyond the current
> end-of-file, update i_size and mark the inode dirty (for example,
> ext2_dio_write_end_io()). Add a generic iomap_dio_end_io() helper for
> this case, so that file systems don't need to open-code it.

Hopefully that gets a follow-up patch right away and converts ext2.
