Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D18528EC81
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850639; cv=none; b=LC3XEG3anLJMtBKY8d0xc6T4chT6lOKAY9A7lwlnPyATzatnqFaI/gfzbxKpNw6KvNtRfZducS6bExm1+j9klEnEFrV3bhpQsMQottRXLQfqtEZdhvI30s7epoh6HTT7Wwphgsj/7ysV7w1bv+STKCZeCI4nSuUbe//KomzHDlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850639; c=relaxed/simple;
	bh=ilM3OdxAh6WDB2cjMfEco5UG/oA5WpPuKCDhylx9mi4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tSYnl7UCpm+kJWe5hM7N5abqfiig1q5vqz0tsy8HlpjtBcuO0FOCiA9PMv/D4tFt9T0AQwAPBMOAjSpSCVjfba4/BrJ2rdwUirLXxgQD+JMx7KwZxKEkJQGku9q9Y60+UmrnL5v7WLU+57P0Qqsy6C8xCpIqr93VhqaxNC2oZFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZgzET54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZgzET54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBC2C4CEDD;
	Tue, 14 Jan 2025 10:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850638;
	bh=ilM3OdxAh6WDB2cjMfEco5UG/oA5WpPuKCDhylx9mi4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=kZgzET54sRy3Y3IACPBdNR0O9oOor0eRnmFXwkA02lid1Zs2kHFPNrGwq4B0IHESl
	 8k9+rIGJOV6b1SAwuVGhr38hMiOWNafi3oYyRX7LBc1mE0ERfwvK17hnkjGBY1L+vd
	 uhDwb//Xeg8OVEeL1qZJK4Itba6CRuw5AmnNVRtHM1TS9NXyclpBZaLxx5WVU9YWUe
	 Tg2TppyMF/AeYVWzUc2C86+OfcZgNGVIlUcXCp2rbOKBSuPBXZVIy75o2G94CTercT
	 i/3vp2b83Yvaim6KbQ8AHdWXBOFKQO0OvGM4niDpssz8eajVYOHVzsXZ+MbX0vvNMv
	 q4Gttq1+GwQUw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20250113043259.2054322-1-hch@lst.de>
References: <20250113043259.2054322-1-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: don't take m_sb_lock in xfs_fs_statfs
Message-Id: <173685063761.121209.17729122722776561258.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:37 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 13 Jan 2025 05:32:58 +0100, Christoph Hellwig wrote:
> The only non-constant value read under m_sb_lock in xfs_fs_statfs is
> sb_dblocks, and it could become stale right after dropping the lock
> anyway.  Remove the thus pointless lock section.
> 
> 

Applied to for-next, thanks!

[1/2] xfs: don't take m_sb_lock in xfs_fs_statfs
      commit: 72843ca62417a0587ca98791b172e4c3b3f8d3a8
[2/2] xfs: refactor xfs_fs_statfs
      commit: dd324cb79e54d3a61621f09c346ee050315a4d2e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

