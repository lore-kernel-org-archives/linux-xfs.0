Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0E522D7BB
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741029374; cv=none; b=lPuvVWuEHpQxaCt/Foaq+JOEud09/CrIk9a/wVDsa4Lodntb9V09Af7DjCSWDpFcj+EBD9/VaMBQAQg4R9u5QSEp2rdvNUdqEhRZ2R0K6HsP/WQGxaL/V8Y0eiPAZhup9PTM+oulFqxKWVcvQgtRbADCmYVbWDhiwBxXIBcNMBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741029374; c=relaxed/simple;
	bh=xDHPTDcU7JOtnk2h5axwCRAd4fjiJ0RCzCwV/NkQarA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqjzFEoWGt56LxxRcfJPF5r9hggF2r7rmhEBfoLyY3CVztadDvenYeWieyFVlZLnZogC3usrkPiCdj/t/B5zvRkoTBhwvcLTY1wzct17PDmyC0pMmp9dFwydKPqr2xlwFEqDHLzUtHn3+V17lpfyia+0d+bRZCZQdjfOX0Eb5zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=dMDF/br4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=P7d6jIaP; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="dMDF/br4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P7d6jIaP"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 3958F11401FA;
	Mon,  3 Mar 2025 14:16:11 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 03 Mar 2025 14:16:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1741029371;
	 x=1741115771; bh=F5A86TR7/zKGkjDW2nNwD8jiHofjaqKxsR1+4cUdhpQ=; b=
	dMDF/br45LQxkrPYqVulnZhry8QdHqvwRZ2zoZ7RdPd2jHkpfIwIvcheZ8wdOtU6
	4dr1w2hwARUM01ZoKYCi2eQ2/yV8UdSFXrpCy+Yibq9KveByam+XOZ/204efysvO
	5t1lvGyA8YBEn8/gzdQMfnwFQT7WTNjMPKMV7zK8Kt+aJHF3BDkww+edjlgmlXQH
	ne50HEqBVfkO7Y+2DLRwJk2tLGsGexlaQ13MnWX2cInTK968I8Rl2HnhYl7l0u8s
	1nrk9J3G2YOC8oug+UBmkjBzy7VgnlkqKPG7P6nn4U0txVyDXBYmsDnxoZxoXipY
	TH31Jt/HGLTjGvfxXxChAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1741029371; x=
	1741115771; bh=F5A86TR7/zKGkjDW2nNwD8jiHofjaqKxsR1+4cUdhpQ=; b=P
	7d6jIaPrNeyGQjOwKBA6E9WP0io0TmNkXzWllX4Xttz5x53R9IS1E92hILu/tSKS
	S1wisOi+xpyP6c8we/2t6vsjh9ghOkEGMfC+FEL5srlvZs4ddiNdJCrurHlpGo/T
	PPCbnfccQirZTQyqobx8WcgtNtZe39UnaJjjn9EJ/XU3O94PF7Qgb/dMZrrBjYCi
	zIYYDzuF7vCJ3e3+67Rw2NzjOSl7KHGfflakysx0hEquG45J7UqMiPn1FjyDlDOF
	EzSW05/0HzzndBwW4iShinPOt0/3+i9TtGSRIiSdVCTEJWtNBPpF+pkBUWsAlZtM
	MiDNCG5cZa4tvPpAn376A==
X-ME-Sender: <xms:-v_FZ4bPuSWjnaM0T_la40YgcvZGuLdgwQcLCN0MhinTWZBYUSUFPg>
    <xme:-v_FZzbcDcyGGVii8d9fDicStIn9YKsRq04e7T4V_65idlbdtnnoJdfYVLtcgiO7M
    I8qVYkHcxX45SNa6cM>
X-ME-Received: <xmr:-v_FZy-f5yIDOn1vOlscTirOt5C2jXEromgYi27SvpomOvrkBZw_5wXlIW7rbIJFQtjoVU8ZxNTQF8KGbWa6MmMKRIbdKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdelleelfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvg
    gvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepveeikeeuteefueejtdehfeefvdegffei
    vdejjeelfffhgeegjeeutdejueelhfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshgrnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgs
    pghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhi
    esihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:-v_FZypt2ruhnpUcqoSZqec365nC4kM6Iw3y1BWjcirzX-9GG3H9vQ>
    <xmx:-v_FZzr7D4XeUOoKtmQ1KZF-yItWobxVfSGB8PeAEiXQ1nAZVpsI8g>
    <xmx:-v_FZwSw4mkj2EkBzK57t9rWLp7-GCf7NYvsXpAoa3GrfgGYlhXsdA>
    <xmx:-v_FZzob9u1vb0_873IQqf54gE9qcZ2eFjozXH-dH4n3-aHfVwbqlA>
    <xmx:-__FZ0kX9tHASOHgvEJattNxylc-CXd4LXzppnmimqrVVIjwbBvLZpj0>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Mar 2025 14:16:10 -0500 (EST)
Message-ID: <29458d93-77cc-41ff-bb5b-37809c89abdb@sandeen.net>
Date: Mon, 3 Mar 2025 13:16:09 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Use abs_diff instead of XFS_ABSDIFF
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20250303180234.3305018-1-willy@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250303180234.3305018-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/3/25 12:02 PM, Matthew Wilcox (Oracle) wrote:
> We have a central definition for this function since 2023, used by
> a number of different parts of the kernel.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

<random list drive-by> ;)

Looks good to me; XFS_ABSDIFF was added in 2005 or earlier, abs_diff got
moved to math.h in 2023. Makes sense.

kernel version has better type checking, too.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3d33e17f2e5c..7839efe050bf 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -33,8 +33,6 @@ struct kmem_cache	*xfs_extfree_item_cache;
>  
>  struct workqueue_struct *xfs_alloc_wq;
>  
> -#define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
> -
>  #define	XFSA_FIXUP_BNO_OK	1
>  #define	XFSA_FIXUP_CNT_OK	2
>  
> @@ -410,8 +408,8 @@ xfs_alloc_compute_diff(
>  		if (newbno1 != NULLAGBLOCK && newbno2 != NULLAGBLOCK) {
>  			if (newlen1 < newlen2 ||
>  			    (newlen1 == newlen2 &&
> -			     XFS_ABSDIFF(newbno1, wantbno) >
> -			     XFS_ABSDIFF(newbno2, wantbno)))
> +			     abs_diff(newbno1, wantbno) >
> +			     abs_diff(newbno2, wantbno)))
>  				newbno1 = newbno2;
>  		} else if (newbno2 != NULLAGBLOCK)
>  			newbno1 = newbno2;
> @@ -427,7 +425,7 @@ xfs_alloc_compute_diff(
>  	} else
>  		newbno1 = freeend - wantlen;
>  	*newbnop = newbno1;
> -	return newbno1 == NULLAGBLOCK ? 0 : XFS_ABSDIFF(newbno1, wantbno);
> +	return newbno1 == NULLAGBLOCK ? 0 : abs_diff(newbno1, wantbno);
>  }
>  
>  /*

