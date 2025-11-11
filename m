Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2D23546E7
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 11:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762858817; cv=none; b=ae39+t5myYCzabNvUkK4ZiO67AWgnclH5XmDXBd8It9A7auuWFTlge+TIiHjUprxpaVuk0NcgQ2OIRrMvnNXI6FQ2kvyZRXsV9gOvxdiBLiLqlXGAWTLMAFjJd9NXsqvBpiO5c8Ms+mI+TyfPrk6uRb0Ph94JZbfLHPK4VqNtCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762858817; c=relaxed/simple;
	bh=UvzHInQaVfhNpRGwATmz4b8ocEs7MnjCnbwVrW3cvd0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y42HJ0c65yY0tn21ssyUnosvfXey0Mc3Ms180HGXfnkPwgt9aXgsFcBH8mBs51ruKeesJG30LJZcObu7bkh/dQvPJz6vfAfvZ4u/NQM/JFLVWl6/uqhGOqFSkYEAaXD1Pbif7s/kyf/hNvCd4dpHe31U5VBKTJUIFq4oquXNZ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyL7qyV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyL7qyV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E87C19422;
	Tue, 11 Nov 2025 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762858816;
	bh=UvzHInQaVfhNpRGwATmz4b8ocEs7MnjCnbwVrW3cvd0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KyL7qyV+1Yo3J+yYBsT+L6j8oBu9iCnvIWtH9Ql0ekBESFff/sTtWC985d5hZ9FG/
	 yP7rExss3G/1BCCiU0neFT+NT97zg3V/ysrurB2oFTgeuNmU5kphqzwDlKiIr0l/v4
	 LLbNWxM2KkWeIi/OeSbvz8zgESicmTmZzN0+/2FK21s3SnfQBVodAnL8PyF2ox+2xM
	 rUAwX47dGT4eHGe4HKB8Cwc17GTGmGHd3wE+P2GDT+tYxcJZfvOSkbPXAvOuJgX2gq
	 3co8B6j9+7EKaoSnKRySCrPY5qpca3Ii9vxuIK2lhI8yTOFPDD/kLSrHeCN5cAU19v
	 oUWK1irj9EnNw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20251103101419.2082953-1-hch@lst.de>
References: <20251103101419.2082953-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: add a xfs_groups_to_rfsbs helper
Message-Id: <176285881543.619206.13442471352853089740.b4-ty@kernel.org>
Date: Tue, 11 Nov 2025 12:00:15 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 03 Nov 2025 05:14:09 -0500, Christoph Hellwig wrote:
> Plus a rtgroup wrapper and use that to avoid overflows when converting
> zone/rtg counts to block counts.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: add a xfs_groups_to_rfsbs helper
      commit: 0ec73eb3f12350799c4b3fb764225f6e38b42d1e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

