Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372012;
	b=E0iuIdYyioXdHi7ERbrOhO20NmVLiN66Td+X5PSAWUNjiw4S+qQZ8qSraSPipAmubAAK
	 K368m6kF61yrNXpkTCDPaJMDZukmm9Q9IgFnTvQVkmPS5c3ZqxtRgIQWmipmGqdo1xYY5
	 mnZslYxufIkykHX4wNxFTY3Xi70G7xHJJLEaRUcEXTnH1PNxlX/tjGu/3/kRovXr5kn2Z
	 ameUGW89zE1AlL7ly+0n3OO/QLI/AI9m5EhFVM3p6SLxvBmC/1AlFzWEGJbLFPrld/Pxl
	 CK57duhmXcdn4EUaK6cp8PGJl6mtjjTF8Dg8CR7qEu/lwlJ0InbTMXXEnPU4f1rCEvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372012;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=3TtOn0cDTZv6utMUpVam0IdvVpfshqnFhO1Zm/bU5/8=;
	b=ZTO1TDw0XSFLWVAunHBH4eDLj2gnNKw8YgEZXu+uGSou5vul9LWEfgE8+D6YpZwZbEb7
	 8e/T8V8X/XBjbilNP6H8UBJ7i0m1sbuyNfGVCCYYkyT0ejATQvEmAVRYstxhii1d/uGuL
	 nE74MegfzHII/fUp520mjiTIW7CzvRHNQNM67cbJGJOxZHVEH8X93YVjRm84IcVNAa8Gv
	 LDOrKzTUYfD56b72/bFrJMgBzgb0xwdZeVA80O00imAv7H6MvsJtbs6JGZxj12YDKD7EW
	 ZgmWSzl1RMaAI6bwr5D1jZPFYN+sBUU+MsuwqRiZkavCy9IyjI9LbcixCUZ/BIkn7gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkp1lfrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CC3606A31C;
	Fri, 30 Oct 2026 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkp1lfrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C01F00A16;
	Fri, 30 Oct 2026 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793372011;
	bh=3TtOn0cDTZv6utMUpVam0IdvVpfshqnFhO1Zm/bU5/8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kkp1lfrxbkJGXL2Oyech8G12zmBLgH1LLj47TAGUQGDFUGj6P21t5Q06kWhJLzYeo
	 j8jJTj0mqo+4X3SL09XJPM0F2lpiODgx7A4ibI0y4TkwQJCNxbxoHn0geUE7S8t8k6
	 MqHo3la2r+IyANuRMg0oPlToPVQSy6C7Xvzw3UGXw1IwF2Z4GqXRGjqk3dWy1C/dZu
	 yHP+BLc9MN0+ZeoIzlfA1V9jXFVDqDXxHhSUufZClbFDWaAMgu8SE5mSwEmYK1bvJF
	 p/ElKMFMxi60csi8ZPsosp5LE7dHQ36SHASGyXxfEBlkYs08bVTg1/FLvpiamy8yAY
	 dX/Gs78/b1qkQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: "Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>
In-Reply-To: <0e89c49b6f7804081f4041007b81ac620a153830.1793307063.git.wqu@suse.com>
References: <0e89c49b6f7804081f4041007b81ac620a153830.1793307063.git.wqu@suse.com>
Subject: Re: [PATCH v4] iomap: only follow dio alignment requirement if
 specified
Message-Id: <20261030-auszuarbeiten-socken-unerlaubt-bce667f40820@brauner>
Date: Fri, 30 Oct 2026 15:53:28 +0100
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
X-Mailer: b4 0.17-dev-ce4c1

On Fri, 30 Oct 2026 07:21:23 +1030, Qu Wenruo wrote:
> After commit 4025185cf953 ("iomap: follow the alignment requirement for
> iomap_dio_hole_iter()"), generic/091 fails on both xfs and ext4.
> 
> The reason is that ext4 and xfs (except COW write) do not require full
> block alignment for direct IO. They are totally fine reading a sub-block
> range.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iomap: only follow dio alignment requirement if specified
      https://git.kernel.org/vfs/vfs/c/87d02f3e98a8

