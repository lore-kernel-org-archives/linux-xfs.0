Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3535963
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752768238; cv=none; b=DfbmWzY3KojQch5Mkh72YTBPn7I2rpE9+AzZHtSjkDcXP4NxQteJNP8SOgiyKihd4zGVGiaqUg8fKzYimQ5E0eSLqGyiY0DA/OlUXSdZKymLNm3xCfnuI5CabTBLeB0nSAzTce7KBTp98VO/p3dTpH0nMq1NWUFkuIjpc0nUS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752768238; c=relaxed/simple;
	bh=HoR30XefTE+r7B6n2vi9MZvzLWm7u0i5aYaxUO/fscs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZtgnUb2eC61MK44q1mP4Ww9rCEdBoQdQumQIxpXu+3JFOFjtDpjEGkGNNYZJjloehLkBwmKBXpxXdIKHZrePbA+JtdIPT7XeC2DtyKEwjzZb8rJDOiF0Fl/IdWDuBmhyU4xYDjBWMTcso88a4MaRL3e4hwm0Y8CTnt0X4ujy4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQlAXxOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQlAXxOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D35C4CEE3;
	Thu, 17 Jul 2025 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752768237;
	bh=HoR30XefTE+r7B6n2vi9MZvzLWm7u0i5aYaxUO/fscs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQlAXxOq0DnQBuPhy4cUdPG0n+uzw2UKN/G/YpY87dmKVJZLe+C9gklJuaMVIH8hE
	 NYv7kyI+GUZopk2HJI80oDoWmbM/+LjTI+PcQcYtga5TbtDOIw06GRmOzQz7zHSMUu
	 jfdgSxntEpL17InRWaXWStNN4c+vSwePrM+17tMBGFlOvxn9s5NplXUsQHii5yBtU+
	 32P7Lo5nMcdumoRV1C9lAGlXAznedgokYf2wDFzn8nuM0cyZInbqhjquvjnaLHn5iN
	 5To4chuREMovCqsyC14xmkJ1xNLjeCU4j6QVbc1iQX+6Hj44SbOrLSt/mQpXxt4efM
	 q+rK0WakG7gqw==
Date: Thu, 17 Jul 2025 09:03:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: a deadloop(?) when mkfs.xfs -o rtdev
Message-ID: <20250717160357.GQ2672049@frogsfrogsfrogs>
References: <20250717081332.E87F.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717081332.E87F.409509F4@e16-tech.com>

On Thu, Jul 17, 2025 at 08:13:33AM +0800, Wang Yugui wrote:
> Hi,
> 
> There seems a deadloop(?) when mkfs.xfs -o rtdev.
> 
> # mkfs.xfs -r rtdev=/dev/disk/by-id/ata-MZ7KM1T6HAJM00D3_S2CXNAAH600026 /dev/d
> isk/by-id/scsi-SHITACHI_HUSMH842_CLAR100_0LX0JWVA -f
> meta-data=/dev/disk/by-id/scsi-SHITACHI_HUSMH842_CLAR100_0LX0JWVA isize=512    agcount=20, agsize=1221072 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=0
> data     =                       bsize=4096   blocks=24421440, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=41799, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =/dev/disk/by-id/ata-MZ7KM1T6HAJM00D3_S2CXNAAH600026 extsz=4096   blocks=390703446, rtextents=390703446
> Discarding blocks...Done.
> Discarding blocks...Done.
> 
> It did not fishish after 10 mins.
> 
> # pstack 5785
> #0  0x00007f8df5efc01a in pread64 () from /lib64/libc.so.6
> #1  0x0000557b7bbfe9c3 in __read_buf.constprop.0 ()
> #2  0x0000557b7bbc3030 in libxfs_buf_read_map ()
> #3  0x0000557b7bbfe1ae in libxfs_trans_read_buf_map.constprop ()
> #4  0x0000557b7bbee7ef in xfs_rtbuf_get ()
> #5  0x0000557b7bbf03d8 in libxfs_rtfree_extent ()
> #6  0x0000557b7bbbb322 in parseproto.lto_priv ()
> #7  0x0000557b7bbb7643 in main ()
> 
> And,
> 1) more chance happen when kernel 6.12.36, but yet not happen when kernel 6.6.93.
> 2) it happen on both xfsprogs-6.11.0 and xfsprogs-6.4.

You /could/ strace the mkfs process to see if it's really stuck, or just
issuing IOs really slowly.

--D

> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2025/07/17
> 
> 
> 
