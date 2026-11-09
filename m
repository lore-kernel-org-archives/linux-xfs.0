Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794260516;
	b=TC9z/GSgPYgrNpUGnv4OVwmjUw9Uk/N/VIyKbFm6cjPqc6VcZozHM/5KiiTfN1A4nsOV
	 sWg5Y0qWxrLACPBQNqnHUxwLxgoGAGUHHpFHUq7nw4K39w89TnxVQ6fluNaysLauHlzBP
	 efdqSEjBlmwc6/UtvjWtIYIbQyCd+T85w3XeB7vI5jKusmCJUB8a7EWYf6BPE54oIij4u
	 t5CuXosFjfyL9wIdNV/kNsKSzlIP/pIo7wLr6kXkHpDV7bL+7nwzHrycYFmromH3EvHUQ
	 1QW02dgYZIVR3WcXza8saT9VtrUcEqpOW1jdKIpdaTSea7TfYdwCL1jgcgX/RuRihqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260516;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IZINy4OwDgZNdHUDl0i+CvZrDD2MfC8EuKYPhxS0ou8=;
	b=xhYFCCcPAkCd2q4CqJ5NW3fPnaivutnnEOTmOOK43vo2LpiARlsqC4Ql2Ynlbw65af9A
	 u3+5690rw6Zvu7OGO9slymUobH6ETHJnYCadFABXWs5LGghqoHT1/WbLmOFJRBl/wMC3y
	 A+l5/5bBIuOfXBk8HVy0d8eiIAebdcT9BZ9Vao/6DOSagUn+yCE0Qd3Iyo8nDXHyG7DJo
	 HiOfPyztVsX/C+BBdmg0evyYlZrdVzZqdAi1MdoXdpB9lOWQyJaxrwSHPSbaQIVa4hYx3
	 AD77ps0BPyiOJ1Hn+IdfUULmgKuEBugEFMRlAOGEDNSFc/0Utnq2Vpe/Aq5iOXLNVug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PbQYdfks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64674606A31C
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 21:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PbQYdfks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5731F0089F;
	Mon,  9 Nov 2026 21:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794260516;
	bh=IZINy4OwDgZNdHUDl0i+CvZrDD2MfC8EuKYPhxS0ou8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PbQYdfksHrpajIAQJkvd4edb7T26vsHMoUWA8X6eb5GCjbw8MUceLMM82CjhHvrxQ
	 QTXbg6Oee/rRRbZOrJ40qa5mK9NE9QoV/8ETxER9MY4UtZo7zw6T1ixZF3owyGejVH
	 +4N/zwuqNihiX4oYt+iJmIssGX8BVz0rJhP6PNr6r/+6AotN8CAmkuqM/Nbs5j5DE/
	 A1o4NI7c8rvLAQTbtusdVb117iT6Ik85+E97RYP2/rSAuvgnNZN7VaZm5/B2hZq65d
	 7utm2O3pqdXSDHWfuodNOd5SPD0882xqfH6fO7+sAgOOLysTYD3FKIG93rCazOmFnC
	 7kQX5rNSXOKhw==
Date: Tue, 10 Nov 2026 08:41:47 +1100
From: Dave Chinner <dgc@kernel.org>
To: Guikun Yang <yangguikun19@qq.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check the region index against ri_total in buffer
Message-ID: <avI-G1JsBZZjz7ze@dread>
References: <tencent_ADBE1F465A9C5A4CFBA28A7D6AA39C527509@qq.com>
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
In-Reply-To: <tencent_ADBE1F465A9C5A4CFBA28A7D6AA39C527509@qq.com>

On Tue, Nov 10, 2026 at 02:00:00PM +0800, Guikun Yang wrote:
> Both xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer()
> walk the buffer data map run by run and index item->ri_buf[] with a
> counter that is advanced once per run. The number of runs in the
> on-disk bitmap has no relationship to the number of regions the log
> item actually carries (ri_total, from blf_size), and the only bound
> on the index is an ASSERT - either the mid-loop ASSERT on ri_buf[i]
> or the trailing ASSERT(i == item->ri_total) - both of which compile
> away on production kernels.
> 
> A crafted buffer log item with a data map that contains more runs
> than blf_size claims regions walks the index past the end of ri_buf[]
> and reads ri_buf[i].iov_base out of bounds. The destination side of
> do_reg_buffer() is already validated for real since the CVE-2026-80536
> fix ("... the only thing bounding the copy is an ASSERT(), which
> compiles away on production kernels"); the source index was left to
> the ASSERTs in both functions.
> 
> Validate the index before each ri_buf[] use, in both functions:
> 
>   xlog_recover_do_reg_buffer(): i >= item->ri_total at the top of the
>   loop body, reported as a bad buffer log item.
> 
>   xlog_recover_do_inode_buffer(): item_index >= item->ri_total right
>   after the run-advance loop.
> 
> Tested with two crafted dirty-log images (mount(2) alone): one hits
> do_reg_buffer (16 runs, blf_size 2), one hits do_inode_buffer
> (alternating map, blf_size 2). Both previously produced
> KASAN: slab-out-of-bounds; with this patch both fail recovery with
> the new message, and the unmodified images still mount.
> 
> Reported-by: Guikun Yang <yangguikun19@qq.com>  (bug reports of 2026-11-09, <c40-xfs-inodebuf-item-index-20261109@qq.com> and <c41-xfs-regbuf-run-index-20261109@qq.com>)
> Signed-off-by: Guikun Yang <yangguikun19@qq.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

NACK. Not the way to fix these problems.

-- 
Dave Chinner
dgc@kernel.org
