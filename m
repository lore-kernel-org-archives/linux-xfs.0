Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3E427A46E
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 08:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739918; cv=none; b=iEm4ZNl4D+QHQGuIu3UXujk/mVRBBajywvl98ursGbJXQhEXN1r36Nkoa1xyNJ4eSAxL5LU8BzY/GuYM2BLR0VzBXf+vohSNrJS+PbVYtIdgTayVNftxTf+Q9gtiTklbiMSM1BCtVMKFfHW2Lx14xGW1+3v2o21BRM5tdkdycyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739918; c=relaxed/simple;
	bh=FAJihucCvk8WfuyLPcWqq2ruOsp+FeiW86w7ghJ0jvQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a4YyZ3krK9e/6Vz5dC0FTySd3D3/cKkjrQQFI17cj75TpSvFKgJcUvXBKSfybOwR6jwMkZvuqg3NH0lb6+dAgZBaaE5skjTWbG2AMNhw9RJlubHVsluDL9g9+VzAxwnjbS3qvxyrrvH18I2dnFRRFLz6QS8vMuD4n+Z+xgVX77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zv9pd727; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zv9pd727"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98331C4CEE3;
	Thu, 17 Jul 2025 08:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752739917;
	bh=FAJihucCvk8WfuyLPcWqq2ruOsp+FeiW86w7ghJ0jvQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Zv9pd727uNx5X0w2aucqoBhuK2fI6JBdNralPxukkGhiOYQRzETjC1hsr+MsDWloQ
	 50NgX7Er1aNtJVDp0u8j+p+CHk0+ZAwVnFlm+QUdAteJOtl9dHTfUyhGwtq/HITMqS
	 MDaZSjuB7zJipQnQYNKfIKBw2joj4+z4GBkt0gXaF/IppGYUCui4rE0mRzmaaKbkyg
	 JnzOwjEgKVacBQ3PWMFPtmMA4LsNH1G6c2zJXL04dlev6UDF27ppHCcuGuHlVHmlsu
	 1bAnyx7KRNJF7Rou4TvJKcWrnApTNiyV+s0troDRfa+BhZIqaul4KKcw6FfLDsEDWW
	 7K1l088weUCMw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250716124352.2146673-1-hch@lst.de>
References: <20250716124352.2146673-1-hch@lst.de>
Subject: Re: cleanup transaction allocation v2
Message-Id: <175273991622.1798976.12844614350494366031.b4-ty@kernel.org>
Date: Thu, 17 Jul 2025 10:11:56 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 16 Jul 2025 14:43:10 +0200, Christoph Hellwig wrote:
> this series cleans up the xfs_trans_alloc* and xfs_trans_reserve*
> interfaces by keeping different code paths more separate and thus
> removing redundant arguments and error returns.
> 
> A git tree is also available here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-trans-cleanups
> 
> [...]

Applied to for-next, thanks!

[1/8] xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
      commit: 8f89c581c0da32ea6a8a1250e7479aa20c4d2824
[2/8] xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
      commit: e13f9ce5bec1273639e6baf2562f01a464e2735a
[3/8] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
      commit: ddf9708277ebe62f84f48f08e62392ff9b462501
[4/8] xfs: don't use xfs_trans_reserve in xfs_trans_roll
      commit: b4e174c374f677132bd5d16e27dffa4a22d6eed3
[5/8] xfs: return the allocated transaction from xfs_trans_alloc_empty
      commit: e967dc40d5017671e5e278aea858516440aa068a
[6/8] xfs: return the allocated transaction from xchk_trans_alloc_empty
      commit: 149b5cf8c7d235ffaa5eef011615f826080e3ca0
[7/8] xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
      commit: a766ae6fe12014ca072b4e8ba194b39c93f45d92
[8/8] xfs: remove the xlog_ticket_t typedef
      commit: d9dbddd143db281a3c6981de5faba7f051382ceb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

