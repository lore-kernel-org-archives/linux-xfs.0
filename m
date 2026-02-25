Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5273016E1
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772010122; cv=none; b=p/XgnLo2dZkbTH3vQaNuYor881CkK9AQ5dqd6oSE8BRx/wZVlp9Btdm4Icr4eBSMa/VCSe1m7fJgrczrdoxteClu2COjSr9hI2rDny2951Hp/FW886AGN8Ic7BJk6EqDbUglTNUEU6UaIaA/wTtcU8ghwKkTH7+lWSMgEMHLqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772010122; c=relaxed/simple;
	bh=jEqph8WvfwZgP2ZSvX1Rz8mwKEdlMZvTTROrv1W5xSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bN+h/U2nwcDbK/30dK22zzIpNUBUeAC/ppn05uxMpieYHRwPKrAX0WRlCmgXF+lyGJDtkopbENbpV0B3i2U2VX8sc1ZlbHpSCkISRWGevKc8psTZUnH6R/1r6ObnX7u7UAcauzWa5kH9OIbdAU/WakRoBQcRPW9U7WoDO1zUhms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CbFedti0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CbFedti0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E13EC19422;
	Wed, 25 Feb 2026 09:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772010121;
	bh=jEqph8WvfwZgP2ZSvX1Rz8mwKEdlMZvTTROrv1W5xSs=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=CbFedti0FUfIupIpbAvu10kNiuMVhRhYp2pEsmybnjchqevP9werk+hrbJnovHltQ
	 BtW4YKaXypA8F4OB/7DpkWfBMvAVph3Azus1pG2VPvfngKMRFWOyI5b7u2uOdfWX/J
	 lNgFcIolXKd2l6ebyetDDNnF91K31/djCbryUsJIF4YOtcs5x/UIxZ5gQKxk+FHLzU
	 HxfBUtjS1fU+Uj6A7c359lgaxS6d55FZMzq38VwPSbHNLkcutGlD2qoG/9OUJ7ciEh
	 CT9xnEOOfZs8QF//mn5ax2/gbMtXBkYO8SgpGWrJYzkwgNsqbm8Rx4PWaYJ1K06WLM
	 sx44xI21955NQ==
Message-ID: <42a5498b-31dc-4ad9-aa76-3d332d6113bc@kernel.org>
Date: Wed, 25 Feb 2026 18:01:59 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: struct xfs_zone_scratch is undefined in 7.0-rc1
To: Wang Yugui <wangyugui@e16-tech.com>, linux-xfs@vger.kernel.org
References: <20260225153923.47B2.409509F4@e16-tech.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260225153923.47B2.409509F4@e16-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/26 16:39, Wang Yugui wrote:
> Hi,
> 
> struct xfs_zone_scratch is undefined in 7.0-rc1.
> 
> # grep xfs_zone_scratch -nr *
> fs/xfs/xfs_zone_gc.c:99:        struct xfs_zone_scratch         *scratch;
> #
> 
> Could we change 'struct xfs_zone_scratch  *' to 'void *',
> or just delete this var?

This should do it:

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 48c6cf584447..d78e29cdcc45 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -96,7 +96,6 @@ struct xfs_gc_bio {
         */
        xfs_fsblock_t                   old_startblock;
        xfs_daddr_t                     new_daddr;
-       struct xfs_zone_scratch         *scratch;

        /* Are we writing to a sequential write required zone? */
        bool                            is_seq;
@@ -779,7 +778,6 @@ xfs_zone_gc_split_write(
        ihold(VFS_I(chunk->ip));
        split_chunk->ip = chunk->ip;
        split_chunk->is_seq = chunk->is_seq;
-       split_chunk->scratch = chunk->scratch;
        split_chunk->offset = chunk->offset;
        split_chunk->len = split_len;
        split_chunk->old_startblock = chunk->old_startblock;

-- 
Damien Le Moal
Western Digital Research
