Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71781A8F9E
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 08:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793120; cv=none; b=snNQRsy6rey2u0IZWb4K7iN9kzx+NFEUdwIqOYgUbE00MlwiTLI1h1bo/UUUTuHztpRnRGirLtITOby7WYAfUKFgOuporRGQVu1TfwMKpvwlQehcHTgBBzuDmqF6KQeEGDeBfUR0oEMlOPpH5KaURCZ8WU4W+xN+f1kut3Jpj8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793120; c=relaxed/simple;
	bh=uCGCGmLCC8k0w/aPN5ycOxJySbIk0eSuLlzntd16ODY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DdlApo0zwFOHleAp1cpIjr5IB0LfpH9CiNZidLDWPREWGQNCnNOuQgClTimEs/PZ8J6AZwg/0tGPpbIJA4QiZDTQ4oOODsTLY5E/t/Rw7A+AFHjp7lCbSJocWiaiV+a6E4JPDhvPMK8LSQ+8DeQ7mXlvQEihSSU7cdamUghQVoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGPdaFCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGPdaFCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36698C4CEE2;
	Wed, 16 Apr 2025 08:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793120;
	bh=uCGCGmLCC8k0w/aPN5ycOxJySbIk0eSuLlzntd16ODY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=QGPdaFCxeDialFdrhAWcOzlKMGoY0/ILk/Akvyma90gRS+8gvqRXz/nhcNugQhxbA
	 GptFxMVk3BWLQAEqv+CUGkubMRkPkEids3u6KF03tWwVvTMxYrnI98BuzWcuBir45R
	 +Mu9JmUPvlb+jCZAOBAH/v54NrzIWySt7pmZByu/35I16vRgm+LxyxtU8foZZd1/9L
	 Fh/0E3Xqnyv619VwVXqQTYs/XSxUirqG+OeDnXWcD51xa2dntaNy8gkU6TJHYTeUjT
	 k1gJ0cF8hfhM/sEsvYndBSFUZtZz7vN183euDlTz/8EapGlH//gpZ+ksWSHoyFOiIv
	 m4dUSUxlb2rdg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dchinner@redhat.com>, 
 Dan Carpenter <dan.carpenter@linaro.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250320075221.1505190-1-hch@lst.de>
References: <20250320075221.1505190-1-hch@lst.de>
Subject: Re: remove LI_FAILED buffer pinning
Message-Id: <174479311889.188145.8940895390861588227.b4-ty@kernel.org>
Date: Wed, 16 Apr 2025 10:45:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 20 Mar 2025 08:52:12 +0100, Christoph Hellwig wrote:
> this series is based on a report from Dan about sleeping while
> atomic and removes the now uneeded pinning of LI_FAILED buffers
> to fix that.
> 
> Diffstat:
>  xfs_buf.c        |    1 +
>  xfs_dquot.c      |    3 +--
>  xfs_inode_item.c |    6 ------
>  xfs_trans_ail.c  |    5 ++---
>  xfs_trans_priv.h |   28 ----------------------------
>  5 files changed, 4 insertions(+), 39 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: remove the leftover xfs_{set,clear}_li_failed infrastructure
      commit: b73e05281cd9e37b5525641ca6f4544867372533
[2/2] xfs: mark xfs_buf_free as might_sleep()
      commit: a1a56f541a8f634007de4bcb45aa3eaf803154a8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

