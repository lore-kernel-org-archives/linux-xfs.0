Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D7371D17;
	Fri, 19 Jun 2026 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781864187; cv=none; b=nffZ2orLrDU23uyJTFED/7ojILt/g7kRFV1xjCBhTuYvGRXy+6z+jdCIe0Cu82VXP4OWECgg1ZHX5qf9ZlK+4ZTQ9I/wxVjXEppF4oOCYdBgxh+GfTDvgunX0H6MoG5qz1y6eYIAsL00zUAPjtgDbtst2JqVlJdR8nsnnT2gY58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781864187; c=relaxed/simple;
	bh=tn0AV2gYpBnl6skQdfrlTXr7GXWTF+FHRBN4aCvCt5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDoFx8cRSFgo6EV3giamUlY0sbOgh48pRS+8pn9Sv4C218+v41xXrm2BQ7rn+lPe9dVem3a0C9rRxFmXTlrkRD8CNusaDrA4Em7mmhMOcbZMEUeyb4SB6BMQEAjHHgThvLVgjDLfvBtksQ9h+d8e71cSjPFpv6w2INMX93Ez8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWzW85yS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWzW85yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E291A1F000E9;
	Fri, 19 Jun 2026 10:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781864184;
	bh=T4Ku6vxk8hJWYI5hTD/JvplJiBVBM2hA5xPuKUywqtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWzW85ySRdjp0ho+faIX+ktbjM7q0E71ZtySVmHB/lVksOkWs35ujR/kmWxc8PucY
	 d57zq/tQ0SpuUcEsoTMhQjfDBNpBccmyqE0960iJZvb7wPhVcCsnVwOk6EJFUS48+W
	 23W7iGHjVNZ7wvPZmG/w0ZOETozKdf20KjzfaaepQ2z6Pm+bztuSfNf691rYrTrtVE
	 ZbygRWbI7Chha4MkTeSYI04PFr63DUfViiz8/ix+pexFnGub2diHQMuRG/Ra6pKcWu
	 Cc6twnKRPzc9n2sX330e43I70bDRH9RmWYM7GSDuvj70NBSTWfQ7+sYeW8UMyWjYCg
	 DamksD6HmZNVg==
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: submit read bio after each extent
Date: Fri, 19 Jun 2026 12:15:56 +0200
Message-ID: <20260619-kundgeben-hippen-abrunden-643fba56e35d@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619050105.439956-2-hch@lst.de>
References: <20260619050105.439956-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1368; i=brauner@kernel.org; h=from:subject:message-id; bh=tn0AV2gYpBnl6skQdfrlTXr7GXWTF+FHRBN4aCvCt5w=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSZin2KPFU0f2ZCVoTv/yyj999qeNO2TPv1csPWjGUcZ YsMU4XsO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSvJeR4bHukrfPUs2Dan+e sT67jWeTzn5FpivTp9zfrJbuWrcpew8jw0ypS5991LL4kudO+cE6a1nLxunxkZl5pm8nLNQqYc8 S5AYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 19 Jun 2026 07:00:53 +0200, Christoph Hellwig wrote:
> Currently the iomap buffered read path tries to build up read context
> (i.e. bios for the typical block based case) over multiple iomaps as
> long as the sector matches.  This does not take into account files
> that can map to multiple different devices.  While this could be fixed
> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> over iomaps actually was a problem for the not yet merged ext2 iomap
> port, as that does want to send out I/O at the end of an indirect
> block mapped range.
> 
> [...]

Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap

[1/1] iomap: submit read bio after each extent
      https://git.kernel.org/vfs/vfs/c/dce5617fca3a
