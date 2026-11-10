Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347545;
	b=oy3Pp8fCYfSLmCcQMpF228ZrfVxQrhEWys1RiA2yfJn1KuCX59LEUZ5ZuCrBGMt1Z5on
	 lNyJx3CR7/XEKIyn/G8GuMVsdlZIkZb/wienmn3RcgudQBQI+y+qdzWLbe6IrOM96FNgx
	 VXdw83O7ZE80TGycJNb5/Tvgq4LYdtPFIv7MHh0vVph2Z9LX28z0SX+cmYMoa61Lcg74m
	 13UZD9XYsbuIWrID+ZXDykuVEVmV7FfxD8FPx6PUafppLWFnw4yP+7q+NiDdiP+4qlscB
	 j2mXCJ09vaSezot0aU7pHZK0GCgaZ9TblDs2VYT19K+S8E39vxt4IT50ws7OdRunwOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347545;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NG5N/qv9kqIWaHQubYWcMp3ybQzZkmkmYbSR6qxrMo0=;
	b=P94v6pTT5XcLFSJv2z86ZA4G2NQK9UjT/ujf3/Ai1HTL2wUUK9UJe7ygmLdiEUxfxyIC
	 07fg2KLf/5iwzTmIciZFesL2qTrLgQeooIqGXend15/NHbug3o90cpVXM8bFHzuPHj5fw
	 7oBCdtBxFHjwVXWGBA1Qorgo/c7uWrsWAvvhc5R98lTx1YeoLDjs4H7aVSXL57WHHLxKi
	 vPKiekLQ+2BbbCDnls7qCKptWCS1+XRxelMoE+3YA8yLePsqI6ZzpKBQvaNY4J5Gwd40S
	 e+dNdfo6QCvdrt+QAnNdlZhzwFWwBQXvE+XGdpFDCKvL41wtQG6eDgc/ucmOd3zrFBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acw6ROyl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7D606A31C;
	Tue, 10 Nov 2026 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acw6ROyl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF171F0089F;
	Tue, 10 Nov 2026 21:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347544;
	bh=NG5N/qv9kqIWaHQubYWcMp3ybQzZkmkmYbSR6qxrMo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=acw6ROylAoj6eTCgQIZH1HF5HgE5P5i985FgFa/sQiOMubXxw/4hpDuAimeoYHbKS
	 0SA7cNzKIUClpR0boV9m6svRkVNWvTapQsEiZPpLQHWIu8PhcvqBqPX9y4UUlZ2KY/
	 5fwYfFdUXyOFfzFfZY38g+/FK3zGeFYWShaCqv09SrX3g48zWo0/Idrv0VFBg41AxO
	 WoebTuoM7ofgzaxUvwBHUAS3R/uMOhy/D8K88+u2/Ll+1y/YvTKQAeAJSY4m5TCMYt
	 ONPv2sRQBHG3ZpoZpNmdTMDQx4GhCZL9ou3GR4YFh4AcRI3UVK+GX6nRvFAQH/csHa
	 xf2OIXvo4ErlQ==
Date: Tue, 10 Nov 2026 22:52:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
Message-ID: <20261110-zerfallen-meiden-wacholderbeere-a90ac157e063@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
 <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>
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
In-Reply-To: <0a8576a4-e397-4a49-ab0e-8f0f32bf2642@linux.alibaba.com>

On Fri, Oct 30, 2026 at 10:58:52AM +0800, Joseph Qi wrote:
> ocfs2_reconfigure() decides the transition from fc->sb_flags alone without
> sb_flags_mask test, unlike reconfigure_super(). And fspick() passes
> fs_context_for_reconfigure(target.dentry, 0, 0). So on a read-only mount:

> So it seems we should test sb_flags_mask as well?

No, that's a generic bug. I fixed that in reconfigure_super() with
"super: keep the read-only state if a reconfiguration doesn't change it".
That is in vfs-7.5.super (cf. [1]). This series depends on that work.

If SB_RDONLY isn't in sb_flags_mask it fills in the current read-only
state. So ocfs2_reconfigure() sees SB_RDONLY and stays read-only. ocfs2
is one of the 23 filesystems listed there that only look at
fc->sb_flags.

> The same falls out of a legacy remount whose flags omit MS_RDONLY.

No, do_remount() always passes MS_RMT_MASK which includes MS_RDONLY. A
remount without MS_RDONLY asks for read-write.

Thanks for the review!

[1]: https://lore.kernel.org/r/20261011-work-super-fixes-core-v1-11-c727176c5b53@kernel.org
