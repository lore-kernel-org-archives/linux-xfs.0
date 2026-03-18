Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11391313E30
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 10:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828758; cv=none; b=VbJkPDC2NdLk84t+ctmQIXHTe/KlUdw4fRFivKPJBi5VOC1LFi3gaxC1d1IoCukTWivcJLbjOWWOKJsrWWUoWesIOOmcmy2sdZCX3MFRocaHArEo6eep03JMRAfnjUB3qjNNNf4UpY5VzP4UFuFwIGIuzwi9Qm3gDlPnHebj4xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828758; c=relaxed/simple;
	bh=L4tX2Tt/x6syAFgua8A+Cerkxc6BbZpwM53lIWcgxlo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=j7UfQpSt5gikMWO2Kx3/COQgGRvvpjnVrEVYPHCSJjvfpEOaxhEOQJkQ47Pv7imSF31YCG+DxpRW1tLUFNCmDvTheUehzC+xgplgYUA7GrfQ/KGK4udjkKINycJwXMuOrGKM3eqKJBr/jjVrrpy8UAKqUQXIPBLYQ/GRYHyYfuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POGEJZpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POGEJZpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0038FC2BC87;
	Wed, 18 Mar 2026 10:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828757;
	bh=L4tX2Tt/x6syAFgua8A+Cerkxc6BbZpwM53lIWcgxlo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=POGEJZpLSCL2lRm78xqrgw0j8Mx0xnNIa46XQUoC1fCFx4442bi56QShZGrHHSTJZ
	 bJhAyTvR1ApQ6sGoU819I92hN2c/u7GGx/suM2PIuvM5gDymQt6MB52VoSNUdMuXtK
	 fUwo6vvRuBBR2TeA176VzEMQaeDn3ITH3WBEUnFd7TdcNbhRc6VUm9NX0huQ4mRa1N
	 N28ajWYKXZ83agDMvcrNqVkHDnI0JImDSUwkK/DbU9dzNPyQu8H7ZhW7VgfQMT7QoC
	 i5UsYudnuImikP7F+xx94Cd3cy3WPsd80d6GSfkS7x+Lrl4dsgNvPwkiKgIZ3j+aD3
	 VNi1dXHSAxS2A==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260316153533.1580167-1-hch@lst.de>
References: <20260316153533.1580167-1-hch@lst.de>
Subject: Re: [PATCH] xfs: cleanup buftarg handling in XFS_IOC_VERIFY_MEDIA
Message-Id: <177382875671.271956.727306431903005184.b4-ty@kernel.org>
Date: Wed, 18 Mar 2026 11:12:36 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 16 Mar 2026 16:35:29 +0100, Christoph Hellwig wrote:
> The newly added XFS_IOC_VERIFY_MEDIA is a bit unusual in how it handles
> buftarg fields.  Update it to be more in line with other XFS code:
> 
>  - use btp->bt_dev instead of btp->bt_bdev->bd_dev to retrieve the device
>    number for tracing
>  - use btp->bt_logical_sectorsize instead of
>    bdev_logical_block_size(btp->bt_bdev) to retrieve the logical sector
>    size
>  - compare the buftarg and not the bdev to see if there is a separate
>    log buftarg
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: cleanup buftarg handling in XFS_IOC_VERIFY_MEDIA
      commit: 0c98524ab20193d8772cff9c71b00ad004fb1349

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

