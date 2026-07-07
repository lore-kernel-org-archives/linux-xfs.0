Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA9D3D812C;
	Tue,  7 Jul 2026 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783422378; cv=none; b=FZgWjNWSPsnIRQVRTg59tCMJw8BgyJDXz1puEPMZ623n8Bm8te1HAzr6XXeC10TnXkGm05nOycFRsv7YEmxtve8F20NJdia/6iBoc3iokaZjAnYnPWLuEUsuL1X/rCzhb5E/QAde+c7C4FHxvu4lq2OQE867FhsG73xsPWClzDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783422378; c=relaxed/simple;
	bh=5oQBslVXVyGoBt+yGH7KL6hP/GNNUnSmmKKmAhRb7hc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=bn8BubqVxSqaBJsALeiUSzomb6m3MXkqxZebW0QB3A6wTDmJwH6z322IwwlhA19HzyLGTvzZ0c+IDb4WGy9I+WlUNulpBVMQQFuPkF/zoOR16e3eSlu2fWL3K63eoYp5Q7mRtm0WOwmTeJ5s2/i3+ZxYZQM8DK1TRUQGVGg6KM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyMp04QI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyMp04QI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ACA1F000E9;
	Tue,  7 Jul 2026 11:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783422377;
	bh=JKxHYicutn9lHYVVegEG1F9eKWFhJlIjTLa68GjK0l8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=gyMp04QITLFRFc5jTjaImw4fF6NT0FHjfTsZpl3YhjEEX+9DzUkH/tskh23b9e6WW
	 LouAB5fIU6xJ+gd/8p8XpuLtntt+xWzybr3l5cb9jM/MxrB9bAjVkdjgn9t4ac4mwF
	 Dh899/mDheHU+6MkH9kTdbEBUj1YKv6BN7KhTP3L60xhM7LUjFLB2M/IpF13ZBGXtN
	 V8NpCTqN5KKS3aKBB+Wi/QEVQzqQCmLOb640Tyk92cE3Z26ncZmpHBdIEwH6imqUAu
	 VbHMZVrr86CCcfS0u50bf2IEcLV9W4elOrfc/ECmdvpr5JjSP5VJvAmYh7N/agUuUU
	 eiwfs3SF7GxkA==
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] iomap: consolidate bio submission
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
 Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
 Joanne Koong <joannelkoong@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
 Sungjong Seo <sj1557.seo@samsung.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, 
 ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260702102705.GB6252@lst.de>
References: <20260629121750.3392300-2-hch@lst.de>
 <20260701-davon-kniegelenk-gedehnt-96476b242a09@brauner>
 <20260702102705.GB6252@lst.de>
Date: Tue, 07 Jul 2026 13:06:12 +0200
Message-Id: <20260707-geleast-bemerken-zollen-dbee3cf1939a@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=970; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5oQBslVXVyGoBt+yGH7KL6hP/GNNUnSmmKKmAhRb7hc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT53F166Ypbtvjzjw9+WiVKHlG+m/XX6FyTmpj5sce8O
 nnTXzPzdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkdiojw6wZ5x8nJ71QqAj8
 9VjoeHBFpkEC35eNX9f8zVJvWLzkyGmGf/ZC2Sk2qmXmf45YsK/f37Z5xoTH/OtXd3wKqdp7/+l
 cXw4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-02 12:27 +0200, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 03:27:40PM +0200, Christian Brauner wrote:
> > Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> > Patches in the vfs.fixes branch should appear in linux-next soon.
> 
> Hmm, both this mail and the merge commit in git reference the first
> commit instead of the cower letter.  Is there an issue with your
> automation that made it miss the cover letter?

Yes, your series aren't picked up by b4 correctly - I always take care
that your cover letter is actually used but the tooling trips over it.

I thought about telling you but then I thought it might be easier to
first try and fix the tooling. So a week ago or so I sent:

https://lore.kernel.org/tools/20260701-work-b4-naked-cover-letter-v1-0-f651c2ffb63b@kernel.org

The issue basically is that b4 expects 0/N for the cover letter whereas
you send "naked" cover letters.

Konstantin is on vacation though.

