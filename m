Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794375949;
	b=eGn3gLMS6LdOb6LMpJf1TPCR8WLTRpUTjPH50W1k7jRsyvYuJmEcmC1Q/cWhuJ08uJZD
	 gRLm24vtmX39VqzEDu1fOLXx7C7XpunGpBxtXp7/NetLWFJZbzeCzxFQk0L4KcPcSgx6G
	 Qjh7K9o7mmUZfa7NajzQithnUYyFemsDPHGPlQ6D4T0e4Qu7Bs3fw1eWN/c1YkEUD3mr5
	 LyEVnroaNb7akAm7XZyb1xjo6JgoJAQikyAAS+Pz8YK1eLVzjNi7g9MjMkT00Mt8MjruF
	 wJbg9MGTJSb/iWS307jwyTBVsknSUgkBhgIdf06lL82OQ2e1EK747yFAEUHSn+pOESA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794375949;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=P+q8jJR9MxG8Thx7AIBBIg1m2jFAPwwzRg0y9kmkkKI=;
	b=TtryHSAXuwmRrZ3JIRAKq9oKbNGFx8+uBa6GIdVuZEJJjlJtdlBSJmeVt92myoqY+UU8
	 DkOjg8sMuqMW8RjuD60CgZead6MimslIiA1lsGh4Stv/t5GbN/WT7B+nih1PMtiRoCzHY
	 LwOXujiv7s2C+Op7hpbt/PvwMOuIfUOLAyQYPaF0rhVa3uLMQmi2/qSdJf4d7YmMXIyb9
	 GAbF9PylxDOFUAafV/10vbn/50qzjMSTDu4BPBtjs348UHyqRm9QWcEJlF4Nj3hpWxsGh
	 nUFfh/ZMoMimdKhPW06ECC7qdSxQoVhUk8aMZYEZU9fQe7kSa+FN0WpZ8wJnNObqcAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MG+9y8WY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47449606A31C;
	Wed, 11 Nov 2026 05:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MG+9y8WY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F61F00A05;
	Wed, 11 Nov 2026 05:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794375948;
	bh=P+q8jJR9MxG8Thx7AIBBIg1m2jFAPwwzRg0y9kmkkKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MG+9y8WYQUlVW5DMsZrUP2SiQYoISIhHHUtXPWIS9V03uaceHYVyHeq5KTgbOV+1B
	 nf36xTv76e0RAH7nhv6YIb0aUcGWt3nb4vceSzcB0mzcSMq9U2UO59hO7xQ+XAp8VX
	 b38UbU2bgTBo35rgRP3dXlFLzaaFxH1TwfcaBep8PV88FO8++x3Z4LzIwyBxf4WGFO
	 624ah+ApiNWl+YNL62Cn1Cf6rnw1uTIAAMI+E5dH7rb1cFt9qPcgRXdMiHQaOVZQpo
	 UsLRGu44QsTue7qSZSJv/hvNLNuU4WzoqglZFKwPP/KluNthkGqilsG2JpdQcBL90s
	 CoABLcSMel68g==
Date: Wed, 11 Nov 2026 16:45:39 +1100
From: Dave Chinner <dgc@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, sparclinux@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix unaligned access to rmapbt high keys in scrub
Message-ID: <avQBA_7WKwIobKKC@dread>
References: <20261110223927.558557-1-stian@itx.no>
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
In-Reply-To: <20261110223927.558557-1-stian@itx.no>

On Tue, Nov 10, 2026 at 11:39:27PM +0100, Stian Halseth wrote:
> An rmapbt node stores each key as a low/high pair of packed 20-byte
> struct xfs_rmap_key, so every high key is only 4-byte aligned.
> xchk_rmapbt_check_unwritten_in_keyflags() reads rm_offset through
> union xfs_btree_key, which is 8-byte aligned, so the compiler may use
> an 8-byte load.

Ok, this trips my 'written by an LLM' filter. i.e. long
run-on sentences, strung together with commas and "so ...". I
mention this because....

> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index 68e2847c962bb..29609c5967fe3 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -149,8 +149,7 @@ xchk_rmapbt_check_unwritten_in_keyflags(
>  	struct xfs_scrub	*sc = bs->sc;
>  	struct xfs_btree_cur	*cur = bs->cur;
>  	struct xfs_btree_block	*keyblock;
> -	union xfs_btree_key	*lkey, *hkey;
> -	__be64			badflag = cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
> +	const struct xfs_rmap_key *lkey, *hkey;
>  	unsigned int		level;
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
> @@ -166,15 +165,15 @@ xchk_rmapbt_check_unwritten_in_keyflags(
>  
>  		keyblock = xfs_btree_get_block(cur, level, &bp);
>  		for (ptr = 1; ptr <= be16_to_cpu(keyblock->bb_numrecs); ptr++) {
> -			lkey = xfs_btree_key_addr(cur, ptr, keyblock);
> +			lkey = &xfs_btree_key_addr(cur, ptr, keyblock)->rmap;

The code fix smells of LLM, too: technically correct, but unreadable
and unmaintainable.

Regardless of where it came from, it's objectively -poor code-
because:

- it uses a pattern that is not found anywhere else in the XFS code.
- it costs nothing to use two variables here which would make the
  code much more readable for a maintainer.
- no comment to explain the issue the code has to avoid.

At minimum, a comment explaining why the code needs to be structured
this way is needed. Humans like me are going to forget why the code
needed to be structured this way in short order. Hence a comment is
needed to remind me why the code was written this way next time I
look at it.

IOWs, the code should look something like this:

			/*
			 * The on-disk high key in the rmap block may not be naturally
			 * aligned, so we have to tell the compiler that we are
			 * decoding rmap keys so it treats them correctly as an
			 * unaligned packed structure.
			 */
			union xfs_btree_key *key;
			const struct xfs_rmap_key *rkey;

			key = xfs_btree_key_addr(cur, ptr, keyblock);
			rkey = &key->rmap;
			if (be64_to_cpu(rkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
				xchk_btree_set_preen(sc, cur, level);
				break;
			}

			key = xfs_btree_high_key_addr(cur, ptr, keyblock);
			rkey = &key->rmap;
			if (be64_to_cpu(rkey->rm_offset) & XFS_RMAP_OFF_UNWRITTEN) {
				xchk_btree_set_preen(sc, cur, level);
				break;
			}


-Dave.


-- 
Dave Chinner
dgc@kernel.org
