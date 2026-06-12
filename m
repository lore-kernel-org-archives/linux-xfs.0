Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAC733EAF9
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781253416; cv=none; b=cvE7AxtmaiMyYrFvZ/GLibDCy2qmGzNnZHO8b2qFTQkhHCpVzGviL8vP+HaFi7OhcsS0RYg4SSJ+2nG+YgVzlfHKyFBkoGrxhpzPTRFnqhmafcfAcOJy3I6CDHW7jmDAiJhVeYq/MsewKU1ufU1DVvC/Irszah1jNonC/oN3yyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781253416; c=relaxed/simple;
	bh=ENcn4MGk6NCLpXzJIW+vn+JKj/eIw5hpy5V0duJVVhI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pN77DOFj1BllpgzpM7Y0YmRoT/A8sgE/SCZtRVyNMW5q3NiiSg4NwLU5feJ2XkaQ4TX0mDCAAECS/YeK6vo3YuX0LPviDrJYmWzVKzQrz4a7S3RSCy8HM2HPSrOfVxpjh4Us3XR/Rzn/cG2JyBpf5hzRB+219dgi5qJXj/xxNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6mZPuil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6mZPuil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608D71F000E9;
	Fri, 12 Jun 2026 08:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781253415;
	bh=4iTE3hQsoq6wD9YpbOPFUD5CIHBdXJjf2eBF0kmam1g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f6mZPuilZEMtW04NkxtZ7s3o4yxMK8Wtlg5LXYd+rzmmyNTOHGXT/LpljA6iP6ilu
	 GcvqzIlUOnLcOLF0EPM7gvvBAepwPKKIxqQvvKMnDtMu+nCzJXt1i89BhoQPB/B3D7
	 q89qA2zlb1RaiHujKAGLSm+PiM16FRe/4B4oegKSNzQYxOGFMaQ2sjJaURvsSlirVF
	 xGUVi2nh+hxAknOtjwRrZtQNw8lN5KslI16C4vzBTRMF7EVJCP6SU/L4VKQRQsjREC
	 +RfRfHHDlXs3Q2wvdj3btl9PSLW9sVA2oPTq4GBDPODhlTvBJu9NUjc1Ck3BvKFb1g
	 FQb75zHRIA1aw==
From: Carlos Maiolino <cem@kernel.org>
To: hch@infradead.org, Yao Sang <sangyao@kylinos.cn>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260612024430.253758-1-sangyao@kylinos.cn>
References: <20260612024430.253758-1-sangyao@kylinos.cn>
Subject: Re: [PATCH v2] xfs: shut down zoned file systems on writeback
 errors
Message-Id: <178125341409.29986.5501338776712506668.b4-ty@b4>
Date: Fri, 12 Jun 2026 10:36:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Fri, 12 Jun 2026 10:44:30 +0800, Yao Sang wrote:
> Zoned writeback allocates space from an open zone and advances the
> in-memory allocation state before submitting the bio. The completion
> path only records the written blocks and updates the mapping on success.
> If the write fails, XFS cannot tell how far the device write pointer
> advanced and cannot safely roll the open zone accounting back.
> 
> This was observed while investigating xfs/643 and xfs/646 on an external
> ZNS realtime device. A writeback error after consuming space from an
> open zone left later writers waiting for open-zone or GC progress that
> could not happen. xfs/643 exposed this through the GC defragmentation
> path, while xfs/646 exposed the same failure mode through the
> truncate/EOF-zeroing space wait path.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: shut down zoned file systems on writeback errors
      commit: f4f28ffe09248e747ffd6b752cbad0f7a34af475

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

