Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153E22A7FD
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 23:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742513303; cv=none; b=Vw9hVV3zFG+Ygc7g6Gt5x8qD0jVsVOFtMeeR+YylAxSfFCelKV3UCHszzWvA4Cqm6qdYCPARzZkrhYBtSk3gq5dlTk2KeNNAH7Pgl5sQw6rH2dXZNJWGwJQZiXZixefi6gXLcUbuw13KeBpf7O3LeKqVWbVnq+uSDCffTg8fhIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742513303; c=relaxed/simple;
	bh=irvWg0nYg5F91Q6xNq42K6RcFnWJqN13fs9Rg9cmIXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X82c7POPQt9ixvOMQQxJxmOatqOwMTKUfRnqcaJ/bfr5Ilk8mnutWpufXZ9tqf6eeDlOZ/O85p2DKb+zrWejqc3ZmJQq84+DtFStv4MOu7WuClqujvVHTfSKgrjQHYlvVVSVfEpQYVap08PrH19dptUWf/Wri9E299asdHLnAB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=R2SbmA4B; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=l/vu99kj; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="R2SbmA4B";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="l/vu99kj"
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7C817254010C;
	Thu, 20 Mar 2025 19:28:20 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 20 Mar 2025 19:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1742513300;
	 x=1742599700; bh=PcL6wYXnmHRWo6BMi+tOuIgYonhoSuANE0YRxo5lDCM=; b=
	R2SbmA4BLdvvnqHUPyxri+vSC3zQ8KViZBuunIaZ82ow7nbx7/Mf6h6C/Uswjo9F
	rcAUCf/4F3Tk1HuJ+SF6n4TIeo2ZQ5CkZEi2BJcne8cPwK10udMO9U4GWivSe5lK
	FHc0TFrNF3MxDt4jNjz6eidx64Kg+d9blz5KoVvZlBfcp0e5wHf3NWBuMFHvPsXY
	4EKzFc5OxbxAdlZ2AB7x44GHRAqqJvkolNecjevTt1FaDwO5dpbv7dQnTpq+RxUC
	aSJRQkvxpxw4WekJiGGVMAjocKbhMw3QjRNSXyOcNA7LUOZ/kVpvZOvbiqr7jPr3
	GTemVtKaJkpAoKK6Ou1mFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1742513300; x=
	1742599700; bh=PcL6wYXnmHRWo6BMi+tOuIgYonhoSuANE0YRxo5lDCM=; b=l
	/vu99kjrKBQBwbbNjFkKa4kibvTdZpT3JP/ssWhqVFdLkcB/0sHmggV5rNFBec/A
	Lq2EfwpnUuilSOPl1rzO9pq4+0xqDNhckGhxTkzNse7BtAsPzidjNVJGsUrE1+dG
	oxQLxeHfJMgmBJFiuVaFh1UoE8iIZdgNN3uWM664DtWl3iMR4nFb/kZuT3BvTq2z
	5W/6I/TbhMsyAMPKflFtlgVS71iuFk1/t7QGFMpKNacLBQmOPFgUNXiuq96KuDk4
	Xjb7qXHlm0f2+7q34btgy4T+4rwDgQXA8WtvcrcXWcGcjyIOkSHFebSWrGsfNdxv
	XiqX90XxF7gBGWlvOmO8Q==
X-ME-Sender: <xms:lKTcZ30Y5yPUPfDbLJ2O6_0znRvl35dAZRrz916QFnxSSaz1hwPQVw>
    <xme:lKTcZ2HXlyqs60YCGn3CfLhDyi7Mzvj_cbvK15-BF4cl56b2kzIsDsUtZw2ehT7oN
    GLHo6dQ0wpadb7H9KI>
X-ME-Received: <xmr:lKTcZ34y9DDBJTV19lFzA0PdqpGQYbzNyFjioD6aJI2fdoRUilPl5kJazDg8ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddugeelheefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepsghoughonhhnvghlsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:lKTcZ80fYlIoZDRfwmxTY16AL4dIFQe_FiFejGez4ApvBTcif3h8hA>
    <xmx:lKTcZ6F8mY8UU4vUoAprbrc-3JY8pF47qGHYgb0bS3YARd8LPSPN5w>
    <xmx:lKTcZ99SpQ0IKWtj3te26dBjERsENJXoiwCt-8Y8kdScrPEkBPwLig>
    <xmx:lKTcZ3k0CpKsJqtzMGsmMEqDRLhBWAu66sZ-le1SxxdcXEs5Wge91g>
    <xmx:lKTcZ2CVq9GpTEwgeBehPreW-qCCiRxPyJCmz5-7xpzAfYgytWSKJasc>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Mar 2025 19:28:19 -0400 (EDT)
Message-ID: <2692c652-bb23-4a5f-be74-bbcea4a91827@sandeen.net>
Date: Thu, 20 Mar 2025 18:28:19 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_repair: handling a block with bad crc, bad uuid, and
 bad magic number needs fixing
To: bodonnel@redhat.com, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org
References: <20250320202518.644182-1-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250320202518.644182-1-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/25 3:25 PM, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> In certain cases, if a block is so messed up that crc, uuid and magic number are all
> bad, we need to not only detect in phase3 but fix it properly in phase6. In the
> current code, the mechanism doesn't work in that it only pays attention to one of the
> parameters.
> 
> Note: in this case, the nlink inode link count drops to 1, but re-running xfs_repair
> fixes it back to 2. This is a side effect that should probably be handled in
> update_inode_nlinks() with separate patch. Regardless, running xfs_repair twice
> fixes the issue. Also, this patch fixes the issue with v5, but not v4 xfs.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  repair/phase6.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 4064a84b2450..677505d45357 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2336,6 +2336,7 @@ longform_dir2_entry_check(
>  	int			fixit = 0;
>  	struct xfs_da_args	args;
>  	int			error;
> +	int			wantmagic;
>  
>  	*need_dot = 1;
>  	freetab = malloc(FREETAB_SIZE(ip->i_disk_size / mp->m_dir_geo->blksize));
> @@ -2364,7 +2365,6 @@ longform_dir2_entry_check(
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
>  		const struct xfs_buf_ops *ops;
>  		int			 error;
> -		struct xfs_dir2_data_hdr *d;
>  
>  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
>  		if (bmap_next_offset(ip, &next_da_bno)) {
> @@ -2404,9 +2404,11 @@ longform_dir2_entry_check(
>  		}
>  
>  		/* check v5 metadata */
> -		d = bp->b_addr;
> -		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
> -		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
> +		if (xfs_has_crc(mp))
> +			wantmagic = XFS_DIR3_BLOCK_MAGIC;
> +		else
> +			wantmagic = XFS_DIR2_BLOCK_MAGIC;
> +		if (wantmagic == XFS_DIR3_BLOCK_MAGIC) {

So I guess the prior 5 lines are equivalent to:

		/* check v5 metadata */
		if (xfs_has_crc(mp)) {
...

and that will force it to check the header, below. And then I think we hit
the goto out_fix; line, and it moves the contents of this directory to
lost+found (at least on my custom repro image.)

Curious to see what others think is the right path through all this.

-Eric

>  			error = check_dir3_header(mp, bp, ino);
>  			if (error) {
>  				fixit++;

