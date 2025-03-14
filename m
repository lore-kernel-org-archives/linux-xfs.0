Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6DF1FF7DE;
	Fri, 14 Mar 2025 13:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741959192; cv=none; b=bAqOQetFUvqvOmDpU22lWA8CbBOS60dY4ENCpbaz0GwVlcol0zItVpQBjt6a/6zrREl3FXTFDUe5v2zWb41a9QCuZeY3XavhPNkH6ddxJ/rCk4axCViBJv2GTjVI1VgPmfw2BqYUCgehJhLpe5MBISnKGhu2275R4NvnGfydJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741959192; c=relaxed/simple;
	bh=BSnSZqRt/0w5UJTEpxT4MQglJ+LM6rk8hI1q1YBLf8E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iauCodgjXV2EHCAPK0cNW5kYpIPdpgndGgsKmxI7kBpV2DltUa/S8nLAdcHvgxfLHNBny9FYHdQ/nBw4HzxUsgACgkkoWYIq+dKK4gjlKkc8HlD1nzoDzRcHkYHphwc7aIkxgupDCOuJhF4xhqj8ImhvVe3Zboy92Bebk6Qfqhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArWT0PnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArWT0PnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FEDC4CEE3;
	Fri, 14 Mar 2025 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741959191;
	bh=BSnSZqRt/0w5UJTEpxT4MQglJ+LM6rk8hI1q1YBLf8E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ArWT0PnT5gHsCu6M5ZXvejjz0Tph2f+XYO9Eg/oL3yHFhgHs/kTP9GIZNfm+cmkrj
	 kEvhKR09llOGhIxkqdDpkFOUcC8I69PWWU6Fv8gpB/Ng/8lMokrZaxcoHE7AsYj9zz
	 1HqpQdNJInaY/zUbOwyAS0vJWB10exY5fP9g+bloQbgvCOgO4PUPk+OX5cze3vUMj/
	 L7CGHUaYG3k0bM6UysXrLBV/yLZlFSin6AkW3/fkYSowgUtVfWYKUzTn0sOZP1e91Q
	 2VXOanibJZSbv0e3JSyjfr+NSqGq9eHiN+xBCyyEgs11wn2uQCGWDKPCErV+Oks7LI
	 kOjRrrwGmUKxg==
From: Carlos Maiolino <cem@kernel.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
In-Reply-To: <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>
References: <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH -next] xfs: Remove duplicate xfs_rtbitmap.h header
Message-Id: <174195919020.416412.14635181444042882166.b4-ty@kernel.org>
Date: Fri, 14 Mar 2025 14:33:10 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 12 Mar 2025 09:44:51 +0800, Jiapeng Chong wrote:
> ./fs/xfs/libxfs/xfs_sb.c: xfs_rtbitmap.h is included more than once.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Remove duplicate xfs_rtbitmap.h header
      commit: fcb255537bee25560af03c583b44866e73a8eb40

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

