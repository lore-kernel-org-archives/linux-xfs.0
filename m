Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794260437;
	b=voE0RFdNFRuSZRc5sENgYzqI2RtEN3B9C6qcuRuYxj7urmIS71sLykPe2IymF0bdwoaG
	 LemOffK0Bzk88yWR4p4AzM59zMv8W7ZLBfds742FaX++ZKBdIt43LTI15202zuCxwmpG4
	 40unBqeXtvgC6n9ShtUqqcdVF29HprjuBL5JUiBHikRN3qyYQbtH8BiX0W1HOELZR/yHH
	 x7Mu7qvKA+a1y+SjY6T+Vj1iMO5UsdHY+omXNq6fvnvvrkg3+Zm5ZbNjd8Vr8rQftEObk
	 4psOsubF/EpTbrpmj/7iaNhR2l2kh/SRF3syLQPIcGLnFtB2WE9/RQyFoSl0iLK0abQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260437;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LoJnZn1Il1sWKFvMJMPHOvzJNNPDmZXqYG4FvZ/7nwo=;
	b=KhAom6n6Ojdfb2e/XwM27dc6oTAH5KYsifhBXmdVxdizg4gq3PU95EFlZrQ1x4buzNy0
	 nEzom3VNtco4k0A4v8JaZnaHmUZ7DwzGxW8JgmiByS6N5lAt0awq3Ij7rwSyQFSs505v+
	 /zlN1ZIObGdQmUtK/uE9bRpXEX0usKtp1f6Zezf5l26kJVLNzEnMtskbGF98SKU+GhYpj
	 +PTYIegYc5ULVbSzqUQyZowhcYSzB3qm6pSJ51NFxPJG2MhApw2s4HlLTk5vlSqS6NJV1
	 s1o653GNNnyp1pInyIWms5lCEqh5uGKedMHwW54fn33ozH+im7S3o5gZQsFIW8LTaXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddpLBIRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36378606A335;
	Mon,  9 Nov 2026 21:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddpLBIRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287431F0089F;
	Mon,  9 Nov 2026 21:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794260436;
	bh=LoJnZn1Il1sWKFvMJMPHOvzJNNPDmZXqYG4FvZ/7nwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ddpLBIRFALacXUpP337oA9bvFrqBIgu86DmWbayhwPmBQb5wSW6+4zk9dRrRXw7Hq
	 POXgqIU6C1/vbtTtcwJlr/eLY7vWJ1MLYOcaM0fVdz16LTbUahtSRlDqAMq74fa4j7
	 RyhHI65b9UG81jxDJR6FdP0nyvbT8QoxsmTyMcvru2S5mqpW3enH8pLJeOhP7qty2p
	 h0hrlxV97X5+gcSl6B7wy8eUR8xoR7NaAKF8go6reFbVvT0h6f7bX1RUQ948XmuD/9
	 UsJaFFG+I5r0YwQtZN9Kyu0k6B8kRTExS0Tjq+pqr4sA0uJ0MEU/c8UbJFx072pbMR
	 wT3prnbX/oGaw==
Date: Tue, 10 Nov 2026 08:40:28 +1100
From: Dave Chinner <dgc@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: read rmapbt high key offsets with get_unaligned()
 in scrub
Message-ID: <avI9zGQRG_kh0l2w@dread>
References: <20261109134853.1659991-1-stian@itx.no>
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
In-Reply-To: <20261109134853.1659991-1-stian@itx.no>

On Mon, Nov 09, 2026 at 02:48:53PM +0100, Stian Halseth wrote:
> An rmapbt node stores each key as a low/high pair of packed 20-byte
> struct xfs_rmap_key, so every high key is only 4-byte aligned.
> union xfs_btree_key is 8-byte aligned, which lets the compiler read
> rm_offset through it with an 8-byte load.  On sparc64 every high key
> checked by xchk_rmapbt_check_unwritten_in_keyflags() then takes an
> unaligned access trap:
> 
>   Kernel unaligned access at TPC[105a54d8] xchk_rmapbt_check_unwritten_in_keyflags+0xb8/0x160 [xfs]
> 
> Use get_unaligned() for the high key.
> 
> Fixes: 38384569a2a8 ("xfs: detect unwritten bit set in rmapbt node block keys")
> Reported-by: Jan Engelhardt <jengelh@inai.de>
> Closes: https://github.com/sparclinux/issues/issues/115
> Cc: stable@vger.kernel.org # v6.4+
> Signed-off-by: Stian Halseth <stian@itx.no>
> ---
> Tested on sparc64 (T4, 7.3.3) by scrubbing the rmapbt of a loop-mounted
> image: alignment faults per scrub went from about 4000 to 0.
> 
>  fs/xfs/scrub/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index 68e2847c962bb..d0578800f3e41 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -174,7 +174,7 @@ xchk_rmapbt_check_unwritten_in_keyflags(
>  			}
>  
>  			hkey = xfs_btree_high_key_addr(cur, ptr, keyblock);
> -			if (hkey->rmap.rm_offset & badflag) {
> +			if (get_unaligned(&hkey->rmap.rm_offset) & badflag) {
>  				xchk_btree_set_preen(sc, cur, level);
>  				break;
>  			}

That just looks wrong to begin with. Decoding an on-disk structure
without using be64_to_cpu() to get it in the correct endian order
first?

Oh... the code plays "I'm too smart for my own good" micro-
optimisation games by endian swapping the badflag variable to avoid
needing to endian swap the rm_offset field.

It seems to me that the correct fix here is to stop endian swapping
the badflag variable, and endian swap the rmap.rm_offset fetches for
both the low key and high keys, like all the other places that
dereference rmap.rm_offset direct from pointers returned by
xfs_btree_key_addr()/xfs_btree_high_key_addr().

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
