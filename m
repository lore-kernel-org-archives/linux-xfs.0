Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795213385;
	b=lO5CAdL9VP9GkoDSkPBpE0sJescQhJmx7eJe5mTYgpUCneJi3hsV755pSGB7wobJb7fy
	 3yEOcnGXYeve1Wwc19d3hPcgEhOEAPVTlcENowxMWERzxWw72zpVZjf6R6rlJJ4hVnDRP
	 1jM6pnyJpJpy7A1GPVHvJilOxNZxkB/Y+NpKLoDrM/42XrV+TNh4I0xoW96QkP1TCLAKW
	 FX4w8KJOhkm4YvsLErn3Q3hu58kwM95t/0NJAWo/UMiD8f3OVLdxCILkyNxfGjqIF/t8F
	 4EnETHnKPaPebMPll/uFMjZ884IO3bjPs6xuwW2QxeJzaWo4kO0YxdevTYkVE5rZKVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795213385;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uS1+xQe3B8rmtkclorvpldO1X/AeJScyduZArKaUSx0=;
	b=A3JECAJpef590U1A1EKNzuZ6f7pIvP+JnEPODw8EyqYy4ZJw3DDNmFZDJf4us+hweHlm
	 qDdRtAyjgUNfUoh46KqEqhewWUPb2+r6Nr30RpprrJI73rRqp3pi4MVaySoM/xUC+u1TA
	 BSUzA5Smd4bMxx8If75OJCqKh5wsywM0DBYPGL1Shz9CjGxat47NjDHCMdP9Bw1ACTBlj
	 RLHsrsFSCspCz3KErjxxrH0byReS8y3aucw3KjJr+mV2xtHNUSSRQ0T5asD2phaotHL3i
	 gdHbF2hWkW/BWqE98cXJ0ZUqIe8QfWZjYuYn53GjaoAU34STysI596DALZLlxwWIMDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgwwjnMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C637606A6B5;
	Fri, 20 Nov 2026 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgwwjnMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0420D1F000CA;
	Fri, 20 Nov 2026 22:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795213384;
	bh=uS1+xQe3B8rmtkclorvpldO1X/AeJScyduZArKaUSx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IgwwjnMfHaRkmfJn07kpFLgVXS2VICq79tfV3PI2EtqmL3PtLYlopaeJb5eXojEn8
	 S61bVEzAJNeJLAoZYfFkWhdUjTGyKG+vJRZvm64NWiOMbYRAAYMtasuSUQ8bSIh123
	 CDa9hkfys7F1E1BCzwBWnXNyA3VrYcdKOsPO38KaW9Lk3TiJiK0T9aEqHx7MD+ptoy
	 GstBPsfrpHJ9lHQ8Px0Ip8gaP2nbW6IrjYDxJejQRug2MkrZgNMbNkDAAc2xvlIbJC
	 R9IyjlocCKAjHIKagXuvaVEhJYU6D9AsyBv3dFlYYPrG/OrfdBh0C04CFxmNKCMq5X
	 uQLVrPdOf+TmQ==
Date: Fri, 20 Nov 2026 22:23:02 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>,
	fsverity <fsverity@lists.linux.dev>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>,
	linux-xfs <linux-xfs@vger.kernel.org>, dsterba@suse.com,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	chao@kernel.org, jaegeuk@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 4/7] iomap: use fsverity_is_building() to check for
 fsverity IO
Message-ID: <20261120222302.GD3048696@google.com>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-5-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120155032.187246-5-aalbersh@kernel.org>

On Fri, Nov 20, 2026 at 04:50:26PM +0100, Andrey Albershteyn wrote:
> As fsverity inodes are read-only, the only write IO happening
> during I_VERITY_BUILDING is fsverity metadata.

I think this is not accurate?  The inode is not a "fsverity inode" yet,
and it can still have dirty data in it that is undergoing writeback.

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 6d843b168d5f..0a176741e7b0 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1930,7 +1930,7 @@ static bool iomap_writeback_handle_eof(struct folio *folio,
>  	struct inode *inode = wpc->inode;
>  	u64 isize = i_size_read(inode);
>  
> -	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
> +	if (fsverity_is_building(inode)) {
>  		WARN_ON_ONCE(folio_pos(folio) < isize);
>  		return true;
>  	}

This function no longer needs the 'wpc' parameter: it can be passed
'inode' directly instead.

Sashiko also found an issue with this change.

- Eric
