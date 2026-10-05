Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058654D17A0
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223613; cv=none; b=cz6F6xTNJA0T9TdH/OVwGqi+UnECF/tyn9moKrPM75YY4K+RuIe9uZ9jtvGHM8ykjiaU8hYfvBBF0fdWrPVq+6SbNZoatUqwgkDNYZ7IS90+RxCv1iWbzfw6tfi024Vsm7UN0xQs7C6GyDeZRyEdMzFfSrqnW+bjYgpwop2/ZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223613; c=relaxed/simple;
	bh=kMGi6Vh2YSrwdkPBHuVnJO/M/Li0fA3DcXlJRKpabMo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iy5vSAE7iK4jCSCrIt7PlTFfrNPCLOKj20marFJ23eNJcyFVllzLYRZ1wEXAn6N+J9kCcDFr5kuMJbdub+Q7pIROO/+sKSknEdsYWCYaT7Crbw2iwZ6HViGZIQUhskYALtSZDAra5D+CqNia1FzE7I7V9guI/6wZJD0B2eDT6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmMe01+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmMe01+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247F91F000FF;
	Mon,  5 Oct 2026 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223602;
	bh=tG98TxIcQXwwtg9Nfpbf45BU05ELrNV5XXUOvfLQXIo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OmMe01+Kh5BcFQx35WLWHIT6cHOT1z7ABoPvH4E5pTSF1kg9Pxxogve6MNQHxTqoZ
	 5bOVjceGiZ+z303GhWrUhh3m85j+KP3buJzgQft4JJBa4kEtJpSbxdO5nOfgU66ETG
	 D/6xixcPxKSGBvQB5bxfz3KlZ4pDgc9bU1OZC+suiwnzNRUuv8fQk3ikI4/JdN0p+a
	 YOqz08RxpFbThBar87uYVMEO7zvQiktZUI7CeM3/QfH7jXmv96eq75YpRBJ0i4J5do
	 OOZ4Q1JfACyqOD+H/NhdCYE/nF4o2mS37YRJjndCpl5FcjwiEd2HnLnE6yA1Y+9Zic
	 aZwS/Zt6QBaBw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Subject: Re: misc cleanups
Message-Id: <179122360182.102066.17704825354522092607.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:41 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 24 Sep 2026 11:57:01 +0200, Christoph Hellwig wrote:
> this series has various cleanups developed as part of the data checksum
> series that should be useful on their own.
> 
> Diffstat:
> 
> libxfs/xfs_rtbitmap.c    |   79 ++++++++++++++++++++++++------------------
>  libxfs/xfs_rtbitmap.h    |   45 +++++++++---------------
>  scrub/rtbitmap_repair.c  |   15 --------
>  scrub/rtsummary_repair.c |   15 --------
>  xfs_ioend.c              |   81 +++++++++++++++++++++++++------------------
>  xfs_iomap.c              |   53 ++++++++++++++++++----------
>  xfs_verify_media.c       |   87 ++++++++++++++++++-----------------------------
>  7 files changed, 181 insertions(+), 194 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/9] xfs: centralize setting of buf_ops/buf_type/magic for rtblocks
      commit: c110639a1c9f36ce5382e9e70fccaa3f922ef35d
[2/9] xfs: factor out a xfs_rtfile_initialize_buf helper
      commit: 724b5e3a549233bf71e3ff5a90255e8c04dfed1e
[3/9] xfs: add a xfs_rtblock_payload helper
      commit: 46db7dec8bae04b2721c9d3e9e4fc75c14654754
[4/9] xfs: cleanup xfs_verify_media_error
      commit: dfe2d2d92df34f6ca9e19548fcc26b2e52a38552
[5/9] xfs: use bdev_rw_virt in xfs_verify_media
      commit: 89572b7fdc7bf10806e1bcde0d9aeccc0d8b3fdb
[6/9] xfs: lift setting the NOFS context to xfs_end_io
      commit: b5a96a9877a5c7426054ccf82528d5de795cb25a
[7/9] xfs: split xfs_end_ioend_write
      commit: 0c94f5499d694a99c2fae3106daaec66971b8b1a
[8/9] xfs: factor out a xfs_zoned_fill_srcmap helper
      commit: b74d34fa3cc7e8f35f1b969c68837ae99566749b
[9/9] xfs: calculate end_fsb later in xfs_zoned_fill_srcmap
      commit: b942c6919ac39870f8327d3123a2912d96e7e617

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

