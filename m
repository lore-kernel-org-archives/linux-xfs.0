Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792975944;
	b=Gg/4CO7bTUFC1RLr6IDMepyCXXyt5266Zsbkh9eqZx+KoX8/ePDMWpAxhNdkArQNZbRP
	 5xZo2nnwPKHHE6NPj35AKNEkBR9T8pbOWCzw1n1B94YdwxlyM8aQ68OQStFwJJyFX2lnz
	 7DGyJpw74Xi2mjtyILfdUvkhCKvQrPMsIVEfV+DTH7YeViiYmD1FIj3TV3ZP7NAhdKo7h
	 trcivi6FIXAZsUAp+pbUaVnu6q2hNJ0CjKhIc9MNxEidCpIN8rwpajsXrtNyGXv+pbSRT
	 9hulNFqeEwrDWvg2JcQ5ZbVcYZRVfJ5jWXv6EeZXoQgaEeSx/BiqhTNbIn2dvF+CDFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792975944;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qvpsncNcsNQRgF9/5zAE8s7AVZqAhMma8xP0LgAsieE=;
	b=SyNhIUj/ErUdbuCG1Qw4HufUyxTetAnoPKWvoFBAExdUf4RKzJ5BWA75cRNBApXhpMN3
	 0ZWpQ1chRqU4bXdDeWux4FLbqAyPj/8/Cx3aeNpcebluXBZ9IFoUV4OW51z3yim5Db/bU
	 WRDL/XMk55upzIVRT4oAM8VJ1AR53n9xS0iCya85MjoWhTbDE93SYr4q59zTI1au8xvmX
	 M7sHcseSqY0cDv+gxSE8bFMwhrdcXsEEFHNd0NTsha19cmJM7gVrr8J8rggbTWCh8fcUZ
	 HDnDVcKVtwJKVbqnm/fDsCTpCjqXyrVsr2rsQwlSafuW6cOWXjyc253WtVdB7J0tDJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PKVH5b8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADEF606A31A;
	Mon, 26 Oct 2026 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PKVH5b8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044561F01825;
	Mon, 26 Oct 2026 00:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792975943;
	bh=qvpsncNcsNQRgF9/5zAE8s7AVZqAhMma8xP0LgAsieE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PKVH5b8FiTz9s9u4KMMRr03j5aO/hkD5b1ZBAJ+oytbOiT/Vl60FMY+Rzz5MTXgJL
	 nBBfp+bfdUCtHdgwXSrakhgI5rx30/ikgxQumS1XoW6s6kYebpfXJUU8CrAxY4Vcog
	 2TDMaJjn2ayXH8+ZQ32Skdnbyd4r4LBPPSF+w9hpdM35bN29WcuqLhYNcQuwEV+5Wk
	 xmAyO0/Xu7zAUL3iVO9PCCkElpAA8dunhhVmlVMk1abzysybX7TYp/0MU1LEGcPgm3
	 I8OCLyU04qPwvGsce+OcphQ4lXXupq8IFnxysCX2wl20TLTepOT5rX81xvm4X9cLh2
	 6+xhJii+DpmKQ==
Date: Mon, 26 Oct 2026 11:52:14 +1100
From: Dave Chinner <dgc@kernel.org>
To: Jiale Yao <yaojiale02@163.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: drain in-flight DIO before buffered writes
Message-ID: <at6kPiFePQYAh85g@dread>
References: <20261025124115.3178287-1-yaojiale02@163.com>
 <20261025124115.3178287-4-yaojiale02@163.com>
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
In-Reply-To: <20261025124115.3178287-4-yaojiale02@163.com>

On Sun, Oct 25, 2026 at 08:41:12PM +0800, Jiale Yao wrote:
> XFS_IOLOCK_EXCL prevents new direct I/O submissions, but asynchronous
> direct writes submitted while the lock was shared can remain active after
> their submitting threads release the lock. A buffered write can then dirty
> page cache before direct I/O completion performs post-write invalidation.
> 
> Wait for active DIO after acquiring XFS_IOLOCK_EXCL and before buffered
> write checks can modify page cache. Return -EAGAIN instead of waiting for
> an IOCB_NOWAIT request.
> 
> Fixes: acdda3aae146 ("xfs: use iomap_dio_rw")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  fs/xfs/xfs_file.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

This doesn't fix the page cache dirtying race condition. Write to
the file with mmap() instead of write() and the same thing happens.
Because ->page-mkwrite() doesn't use the IOLOCK, it can't be
serialised against DIO submission or in flight DIO.

Regardless, overlapping buffered and direct writes to the same file
indicate an application bug that needs fixing because the result of
such IO patterns is not deterministic (even with this "fix").

Sometimes the DIO write will win, sometimes the buffered write will
win. Either way, one of the application writes gets lost and so we
still have data corruption from an application perspective...

IOWs, all this patch does is shut up the warning that tells us that
the application is doing stupid things that could result in data
corruption.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
