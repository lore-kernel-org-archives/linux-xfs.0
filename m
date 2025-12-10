Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF28527380A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 07:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351992; cv=none; b=WDrFuRfrhZhh/teSfrSnzTD+XXnkNX4cJqA2VT4L9qNhtgfxaEddDI0q+cEJThK0mLwTB4v2n/44pcdE3BYr1CbEZ/kT/XxToV3huXPGL1vQ4eFg10qswznuU5a7kJxOk/8WkAFmUsuBKMX9LNHlhZsn8lhSst+pl/1ejQGPQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351992; c=relaxed/simple;
	bh=hSf0ATDC5GcsPRp6v2BjjCrEEClrnElkTVJzYcH6EeM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=MDEfFCdnF/4kWjS+d8zB1ovCBkBpR7Lqtg5WTx2pxbPdYLZY2ig82x5+UxeXORGe7hgF3ITYrPGXZ0A4cvjyleuIiZh5nxmmgDxIKysdIJ/vMGJlQWCSOx8eLsH9JlwqnqLom451QkH6YR/qlEQO1CBV7nZ53lqAfku9VQXT5Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9OisM9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9OisM9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81A4C4CEF1;
	Wed, 10 Dec 2025 07:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765351992;
	bh=hSf0ATDC5GcsPRp6v2BjjCrEEClrnElkTVJzYcH6EeM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=K9OisM9aneHkkQYT20cpL0QeAXJ/OK/Fcf9wo2aJ5KBxxAYUeRBF+Y8rKl4kVNiT4
	 KuBcakzADUdhmWV+iz7rG9yjbAyUv3GIxjNu51ZfIfC9BG18scm8gnPt0IZeaMHkJo
	 h6JnmFrQlijcjafNemFaXLde/lIvEVPI4X7PsoO7lSKkqLqHG4AFNNuAiyNiBM8ukO
	 EMEklhMmUtgtuW6cepxnxCCBxwzmB8OPEGb2hmrzVGwVcGrNWt23bU8vgqgivfk3ep
	 3GgmQ2p3sRfmf1CgkHJzAawvgIw4tpV2TCiGPWF3Kt7h0OkzmkarZpUoDbZYLIxA7a
	 vEJZHR/xE2bhQ==
References: <20251209225852.1536714-1-preichl@redhat.com>
 <20251209225852.1536714-2-preichl@redhat.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, aalbersh@redhat.com
Subject: Re: [PATCH v2 1/1] mdrestore: fix restore_v2() superblock length check
Date: Wed, 10 Dec 2025 12:37:14 +0530
In-reply-to: <20251209225852.1536714-2-preichl@redhat.com>
Message-ID: <875xaex043.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Dec 09, 2025 at 11:58:52 PM +0100, Pavel Reichl wrote:
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
> index f10c4bef..b6e8a619 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -437,7 +437,7 @@ restore_v2(
>  	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  
> -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> +	if (xme.xme_addr != 0 || be32_to_cpu(xme.xme_len) != 1 ||
>  	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
>  			XME_ADDR_DATA_DEVICE)
>  		fatal("Invalid superblock disk address/length\n");

Thanks for fixing this,

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

-- 
Chandan
