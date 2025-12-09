Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A7B262FC1
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313418; cv=none; b=k6em1HQ4V+GEc+aDzTmFsKVTrVZh22DECQC9Ibv+D5SnNn+VIF4eUsZppI3PUwYM8VrAoGEAC3SFAqQpyo1guZzjODcmN0cC9E1cp7RMZBnT2Msshbd8alZX8aQQdqKV31iyzt2BzJzw0oy8hTyNp5D/1g4Vfi+U8PnGiToblBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313418; c=relaxed/simple;
	bh=nrzVJz6p0Umwj1UxI56bu0t1qObn9Koit8kPMMXhcu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAC6vSnHfMyePsv8oCxJrsuNDF25Fh4bLhNj0tfWB/pcuzN8+NIIKEIFuLf+nnSia394a5eX+RGISfiaeEZFT2NBR+T90AuFzMo1l7lEzaWkiquTNoQjoyah2VBuXbkf3zRTiGqDFHA7c4YPLbLwpuJlVQV3y/Zzag8ljcmydIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nU2C/+Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nU2C/+Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1A4C4CEF5;
	Tue,  9 Dec 2025 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765313418;
	bh=nrzVJz6p0Umwj1UxI56bu0t1qObn9Koit8kPMMXhcu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nU2C/+FjsCXX8iXQSEq4c+hOTRYnxaQm5ug+GBogANiZnvB52LuVS0EnItZii4zRz
	 BelywKpgkmVjw6v6W89epPeLwYDHtx0tFENEQUrax63Aj/K49poUUCX3zxk95UX0qf
	 ERstJ81emtpGnQKJtS8mpw0+rZcExn3VLpHv3+7u1HkF7DMcqYlhB68XhJnK5LCnVN
	 PfxJV9cq4GTsR4aGERYfrBckRMPwjUKEQiYWKpVKQ+AeMp47IVGWfFxhyyjcgpU/Eb
	 IxAp+auZ54fmChT/FgHfM7kbvTKaFJcHUUWtmimm7iwtuLXtdSAVtTwpSqa4+OJTvr
	 gUHGljo2WdnwQ==
Date: Tue, 9 Dec 2025 12:50:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org, sandeen@redhat.com,
	zlang@redhat.com, aalbersh@redhat.com
Subject: Re: [PATCH 1/1] mdrestore: fix restore_v2() superblock length check
Message-ID: <20251209205017.GX89472@frogsfrogsfrogs>
References: <20251209202700.1507550-1-preichl@redhat.com>
 <20251209202700.1507550-2-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209202700.1507550-2-preichl@redhat.com>

On Tue, Dec 09, 2025 at 09:27:00PM +0100, Pavel Reichl wrote:
> On big-endian architectures (e.g. s390x), restoring a filesystem from a
> v2 metadump fails with "Invalid superblock disk address/length". This is
> caused by restore_v2() treating a superblock extent length of 1 as an
> error, even though a length of 1 is expected because the superblock fits
> within a 512-byte sector.
> 
> On little-endian systems, the same raw extent length bytes that represent
> a value of 1 on big-endian are misinterpreted as 16777216 due to byte
> ordering, so the faulty check never triggers there and the bug is hidden.
> 
> Fix the issue by using an endian-correct comparison of xme_len so that
> the superblock extent length is validated properly and consistently on
> all architectures.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  mdrestore/xfs_mdrestore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index f10c4bef..71c2bb9a 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -437,7 +437,7 @@ restore_v2(
>  	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  
> -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> +	if (xme.xme_addr != 0 || cpu_to_be32(xme.xme_len) != 1 ||

xme.xme_len is the ondisk value, so that should be be32_to_cpu().

Otherwise the patch looks ok.

--D

>  	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
>  			XME_ADDR_DATA_DEVICE)
>  		fatal("Invalid superblock disk address/length\n");
> -- 
> 2.52.0
> 
> 
