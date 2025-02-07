Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70D819D072
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 19:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738956383; cv=none; b=EhzVPj0Ktf0tdcFlDst8W7Jqxoe+sraDZWhFg3Ug5Om7/8HGuJZVnQ0MSNf8HImCAGIm2hhmVn7UOcBps+ETM6X38sRdIDlLwMhsNQprWH+q2P/K/P/Fyzz3PnmUm9Qd/Jw1jOurtJAjcUr6Csvy21NiwaKz4y8GmJdITW9waEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738956383; c=relaxed/simple;
	bh=gUIbyIg2bkUiMFRkWR1gViIk2Dq+MWNA7wv1c6OC4lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2SRE6uE0Z62+bJBOggfIndQGbd51DTvkb8EMWGPCd5vV93EwM+hyeS0b7OMGdxahG7iorvA7U//hyEt+PvQjzkspu3eewFcpud5hcDFsIezc32t9RHVqNyORKR+DuZ99kZYAbapUHI1nx5ezSHRyDUms+fyu0NeSnb889bmrys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgSpNPXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgSpNPXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9ABC4CED1;
	Fri,  7 Feb 2025 19:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738956382;
	bh=gUIbyIg2bkUiMFRkWR1gViIk2Dq+MWNA7wv1c6OC4lM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgSpNPXkM9ksBiuVksxNmzSZUzqK1agfpiuVPsd7D4byPcOLG4rnYYMjLg32JNeAM
	 qlSYKEg4NdhxxsU9Vu497Ogq9AImDLsEQ+YdVTy0xaayubgvGZ9kxzL+zDmUOv6c6f
	 f7P2PGq+R/RciRQpATcs4tduUXjw3ncwnsTELIN4RAi86rs0VpBrpQ5dmQu5zFEmuN
	 kxN0n8dZ4HM2RSswSVQBVO5FCZibzEtvNlTQr0gISldDbxg6rXfd/P456X6QIocEjm
	 kGUNOMUaHTzsyOIISyjMggWMNCkUp0oEtiCv7QMKFOOwjWj2+FyH8lF9DgCh41Oc8X
	 BtBbjgzZRAl2w==
Date: Fri, 7 Feb 2025 11:26:20 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: da.gomez@kernel.org, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <Z6ZeXJc3jw-kHKGa@bombadil.infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <20250206222716.GB21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250206222716.GB21808@frogsfrogsfrogs>

On Thu, Feb 06, 2025 at 02:27:16PM -0800, Darrick J. Wong wrote:
> NAME                     MIN-IO
> sda                         512
> ├─sda1                      512
> ├─sda2                      512
> │ └─node0.boot              512
> ├─sda3                      512
> │ └─node0.swap              512
> └─sda4                      512
>   └─node0.lvm               512
>     └─node0-root            512
> sdb                        4096
> └─sdb1                     4096
> nvme1n1                     512
> └─md0                    524288
>   └─node0.raid           524288
>     └─node0_raid-storage 524288
> nvme0n1                     512
> └─md0                    524288
>   └─node0.raid           524288
>     └─node0_raid-storage 524288
> nvme2n1                     512
> └─md0                    524288
>   └─node0.raid           524288
>     └─node0_raid-storage 524288
> nvme3n1                     512
> └─md0                    524288
>   └─node0.raid           524288
>     └─node0_raid-storage 524288

Can you try this for each of these:

stat --print=%o 

I believe that without that new patch I posted [0] you will get 4 KiB
here. Then the blocksize passed won't be the min-io until that patch
gets applied.

The above is:

statx(AT_FDCWD, "/dev/nvme0n1", AT_STATX_SYNC_AS_STAT|AT_SYMLINK_NOFOLLOW|AT_NO_AUTOMOUNT, 0,
{stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0,
stx_mode=S_IFBLK|0660, stx_size=0, ...}) = 0

So if we use this instead at mkfs, then even older kernels will get 4
KiB, and if distros want to automatically lift the value at mkfs, they
could cherry pick that simple patch.

[0] https://lkml.kernel.org/r/20250204231209.429356-9-mcgrof@kernel.org

  Luis
