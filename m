Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AA939E9AC
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791477488; cv=none; b=t3rYYqplLWzNizLrqSxG/vI/FGR2pjll6eHDbLa5SwMEpxHaZ0OYgXaWIF4mZ4hQp/utVU/UStJ7Ke5OjOFnYf4XCSoTxPtrxFLoKUDOTcMA1g4zun3ygVHzoksbUukxhvsUwcfUbyBBKZB2Svjufc7CF6QyhibmvH5QaiDviCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791477488; c=relaxed/simple;
	bh=fG+OW0+Rc79UROgONMqJ3MjzgYnuVC6qrQ8HSpnhLFY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qR08RC2vYmb5WDaPOVNx5uBWIdM1TvhpvLEUiEYjBQnIj6bZjoTEysOamyo6rem5TVLlNua7eehYf0fJSeQwDVHgaTMG19bSSwbTenmj9XS5GMRgvhkqsPwNp/Cn10/SAah8s1NbBZzHubEuxspAaJUS6koUEVnj/SJwiHg4oto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV68JSC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV68JSC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5351F00893;
	Thu,  8 Oct 2026 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791477487;
	bh=NayZRmRBMpCIYxMfMRzYi5Xi/arHIBWyBRHJXVRTNzs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=YV68JSC4rl2/8QL14sSMAS7O2Xi/REMzHgsN0kBrbUB/GvF6uX0uVPHgjCWv85NVC
	 OjakXHwvyei6F1HUhbuXVVmQCIi8ybfVYbQ80Oc23fWZMcQbST3i7ch1D/sn1ZmnD0
	 RfkFE9RJyZZtMhZO9FSR11wuunGFYi30PA8Aqp0Std3KSLbvW8Nk8ypoOCU2qXznSy
	 gj7gCDzPjud/9xtGwZ5oMqAl5BGjDrapZduk30VZL1Gf5iSlGePiCVDL0Um1UdslxT
	 otB3UKiVTUUWabifQaOoVTKyyBPgjEWme+h9Kek799SSvOsPWBVAUNgtpHICaUjhSR
	 gGqE1/t/rUnaQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7CB51F40066;
	Thu,  8 Oct 2026 12:38:06 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Thu, 08 Oct 2026 12:38:06 -0400
X-ME-Sender: <xms:7sbHauhr3BCZEZ_g93kO8-31VOY0CQBz8gU_2gsHnQfEsZSJ8XA6pw>
    <xme:7sbHap01O7x0LOfie7dsS5MYhT57J_6fY0P8OAqOotNF0KPmiLNIMCv8hUF_aKa9h
    lLQh2WleA7_rGeXGlH2jfOw_G_OtkerLHn2ih6rcIMVUWkoQSzOnGCY>
X-ME-Proxy-Cause: dmFkZTEGUMQdW2KWbEUtbc89N/qCyyJWW8nH8rVuuCYGTMA6vcJ4Yjmx7wtmUI6eKj1dct
    WT5y4BG4lZvYL+zvhTZDCEXzl5Psc3RZfQfEiNKb9R0ZoQn4y+wdNfYm7Y3iYIGSnC92Hf
    YSHY9XtbpuEcEPzXLFGZpnKVzj8A1dcevRwHMMzpRzKgHgk5qzHCngrZbbL1b0+w18dOrD
    +IE29P9Wa1wu7ed/YV/ZNVvNutMPDH0BuwWi4VPF+XksjfON3Bqi2WDVVapyx4eTd0flL8
    sWOeRlABwkfEmxlcxBT5DpGPajY8CvFK5OvNDJ9wFNovd1d6Kw2/mQsgbnoKrOYw9nPzpM
    e9+6fkJlejdCKDUmrROk4Zs7lZu+soG9LdnX2DQN07/wr+nh+WBHg0D1UIS+HFulX1ti/j
    JwiLUsvezD1ZAV07zeeWzeT2AY5z6R1kE2lvE9LadN2NRhJIsnpqV3FHyhHJB18vmz9tV1
    i9E9lSD4mVXBLzEXsOKJ/xW/c9qn2eIbulOFKo3uxYvgeiT+6Z9FROun0Unb4nzj8jBvbb
    Y3yjJp+V+diqhY2v625xwVEYnAzYVw4ONwxACmrP1xeUB6LiJJ3Djb0WIf5D0wLpcMlvbW
    mrqDPV697rM6JlbiOT+zRgBiANUNAD22T6TZxvn454PGavJPhJ8rS+X7UWfw
X-ME-Proxy: <xmx:7sbHaiuPi_rvPTGLnXdvL0YH8HCN-l6hs1ja4uAps6czavISee365A>
    <xmx:7sbHajZW9Z7zG936vyrxGe8gqYPwxDZzug7xpfGswJzsfsbDhVzpSw>
    <xmx:7sbHaj7VkyogBemmaCNKjO4GbadDwbcH0Qg4kIaqnUePBFoC_mwQCg>
    <xmx:7sbHajlYVW41EdDeYZgkLnss2bwE7HzCzghbVQpbbyYADrK70Jl0bw>
    <xmx:7sbHahF55XaUOIyK01_Fk9R83RBMoxUBRvxT4P7Ml_mxiegEa7fiFTw4>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5CA43780070; Thu,  8 Oct 2026 12:38:06 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ACJwmNvOgsp7
Date: Thu, 08 Oct 2026 12:37:46 -0400
From: "Chuck Lever" <cel@kernel.org>
To: daejun7.park@samsung.com
Cc: "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>,
 "Carlos Maiolino" <cem@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, "Dave Chinner" <dgc@kernel.org>,
 "Sergey Bashirov" <sergeybashirov@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-7-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
 <20261008-xfs-nfsd-map-blocks-v1-7-560026cdccb6@samsung.com>
Subject: Re: [PATCH 7/8] xfs: map the whole range of a pNFS layout in one ->map_blocks
 call
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Daejun Park <daejun7.park@samsung.com> wrote:
> If an allocation fails after others in the same call, the error is
> returned without the inode update and the log force. nfsd then fails the
> LAYOUTGET, so none of the blocks allocated is handed out; they stay
> unwritten, and blocks past EOF can be freed again unless the inode
> already has XFS_DIFLAG_PREALLOC or the file is empty.

The same freeing can happen to blocks a client holds a write layout
for, AFAICS. But that is not new. Commit 527851124d10 handed out the
same blocks.

This is however the patch where a fix could go.


> +	while (nr < *nr_iomaps && offset_fsb < end_fsb) {
> +		struct xfs_bmbt_irec	imap;
> +		u64			seq;
> +
> +		error = xfs_fs_map_extent(ip, offset_fsb, offset + length,
> +				write, &imap, &seq, &allocated);
> +		if (error)
> +			goto out_unlock;
> +		error = xfs_bmbt_to_iomap(ip, &iomaps[nr++], &imap, 0, 0, seq);
> +		if (error)
> +			goto out_unlock;
> +		offset_fsb = imap.br_startoff + imap.br_blockcount;
> +	}


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
