Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347312;
	b=x7tmk5loUDbceqZBHqzClpsQW8+ZGu7wfyHhCzC05uMyyYbzA7jHZH/4UpXYSk6Aqai7
	 Eh/qIPdNyidzpMMMsQ4+Vt1rfZQbqHU7qRpdoRShjzxp7ALzaQVYhHPdCJNnZMjUS2Y6+
	 zEzMXzjN5odekYra7ASKPo53rREpim9xPijO+1goMsx0/dcqtybFdqTsERrmFdN5GfyYe
	 dyusZwUf0Az5yiS1YWs8f+KAWxASfK5Y1lGRK761Pn2fDxVyja57ADUriJ1GiK/v0nL8B
	 hn6Z95wdMYt5mDsPskZCkm74IQvUtF3y9uzEN99ZYSugJ0wo3HjTvpGSUTEsZZftvAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347312;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S2pPMf68MKLxuySWp5Wno+q1xTo+NPVvk6DAmNFSvFk=;
	b=jEweQJ+k8Folssbr3YmwQp8GHujtIxGrXunioA5KsIsMi2aeOUdxy7eDx0e7LciMqoXr
	 CTeNuvWgtL5e+3z6rotYj1J+uNfyGwD4HEPcyaX0eHPYwB6g+D07jeunTXw5s41Bb8Vyk
	 zIyUJodKJCKb1kc33A084y4K74muBaSXen6nOT0SqRUMATyawXr5Q+lN8E3VXBGI6eL1a
	 1tMZ5MYRfEPRJqcATAecXcA9lL26uQbNftU29nKmCw0pXTOWI0m0U0EsmKVyj2aoLp9HM
	 MXDsfnF4exA4nMAEwDy/FDmhJMpt2WKWzsHxvahlA4dQ8ZAEWEWND62dfZMtCTWXSpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oC9iFwgo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE22606A320;
	Tue, 10 Nov 2026 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oC9iFwgo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688451F0089F;
	Tue, 10 Nov 2026 21:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347312;
	bh=S2pPMf68MKLxuySWp5Wno+q1xTo+NPVvk6DAmNFSvFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oC9iFwgoyNF0avpSzP+LujPrHBL55F0iQ1+eh40/xaQGCsUJwyZj2fPS30ujin4Dm
	 SVnQqpZ2SjogMiMYXPEzvfYKJzVMoBv+Df3csdKCA801hOuiWqyDvQl/FCA1PveiKn
	 dlzsj5berdJeLTvrfRf1tn+APYZX4HAekqypgq7yh7KMtnngVzBJ7X+HDQSs3Y/Ves
	 YrQKw6AR2dcxgAuVjhMouKyxBmBPILui/uSJqFha6vIpd35V81aHP3IEK9IhKRSlAC
	 hI/LC3SWGPGbDDIpo82LOorhqYu1cfTQEirY6vqyc6wT1nSwBig0OETsSsx225pPq2
	 gh4ZaFXCqLkVQ==
Date: Tue, 10 Nov 2026 22:48:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 03/34] fs: add a generic emergency read-only state
Message-ID: <20261110-person-fischen-gutmachen-7b04d2256799@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
 <gm5ays7o5ps2gcokxw6giymwwalixk6dychwlqfgx4brjohfth@cyrrjbycqjnj>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <gm5ays7o5ps2gcokxw6giymwwalixk6dychwlqfgx4brjohfth@cyrrjbycqjnj>

On Thu, Nov 05, 2026 at 10:00:02AM +0100, Jan Kara wrote:
> Maybe it would be good to mention here that anything that goes through
> mnt_want_write_file() or mnt_get_write_access() is treated by these changes
> as well (due to the __mnt_is_readonly() change).

Agreed.
