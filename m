Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC97E1;
	Fri,  9 May 2025 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746791005; cv=none; b=rekryA8rKfGg2Am9jvhoe+KJwdAnvSGjdJnzi8+mYbyB8rumegylBq66/htZNQgoDRBn1jJMHLr3ePxofmoSkSqrfK1uPQL0eAvP1mZPynTvLHzA2j49KHa7JJvS3rFNe+BM+Xtnn1SNOIU1HS+bGGjMTxiUeERtcR4BVt40aJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746791005; c=relaxed/simple;
	bh=pXq8xRM3r9Lvv1wVFngQCSXL1x5RF4IQd+aJrNn6jdM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AG7Of9zl+mmX0jhN2K6mwsVO0BZuffc42R4Lt6sAjoptxGRKo6DiQ+sx5rQQGQbnnHmZ0NvnzVQUNV1xTCFVezsnlOaNroEp+88vpnkrfNi+YpIF+OGtHT1W53lshurWLuPVt7nfiasqPIst3anOMSwBm0U1RHYD1Q2BvGZ1X7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+TU53PS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+TU53PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828CDC4CEE4;
	Fri,  9 May 2025 11:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746791005;
	bh=pXq8xRM3r9Lvv1wVFngQCSXL1x5RF4IQd+aJrNn6jdM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=j+TU53PSfUr9Y0hMZ6P00HijLGw6ENEFXNrBaZ9/0HKKceFbITvBcUPvppuXJom7P
	 Swlrgu1NGa3oir44B0NVpTlYxmOgzqdbPKSTrMnXozfDsqBO4BiGTRg5lKc7LjSbBg
	 LFn7nSXyA3V+SZMxMtxrSfv+QYAL2h3LGpsTuPMBBKTLMKpt/vSmK3V0CzeG3cNSNN
	 8T3pgh7eh5t9x8KfcOpaKb1XnKfOhKLi+nzX/dQGdEnPAFb8qgfGhUHs/GAlycTzmr
	 m3HRTwjNANKAfng79fxTH5hOJ9iIoPg3xpnTqD1+lLPQT2GTHYbjg933P7iY+eGEMg
	 lHnIZBZtbP1fA==
From: Carlos Maiolino <cem@kernel.org>
To: chandan.babu@oracle.com, djwong@kernel.org, dchinner@redhat.com, 
 osandov@fb.com, john.g.garry@oracle.com, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 wozizhi@huawei.com, yangerkun@huawei.com, leo.lilong@huawei.com
In-Reply-To: <20250506011540.285147-1-wozizhi@huaweicloud.com>
References: <20250506011540.285147-1-wozizhi@huaweicloud.com>
Subject: Re: [PATCH] xfs: Remove deprecated xfs_bufd sysctl parameters
Message-Id: <174679100223.556944.12054181296984574578.b4-ty@kernel.org>
Date: Fri, 09 May 2025 13:43:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 06 May 2025 09:15:40 +0800, Zizhi Wo wrote:
> Commit 64af7a6ea5a4 ("xfs: remove deprecated sysctls") removed the
> deprecated xfsbufd-related sysctl interface, but forgot to delete the
> corresponding parameters: "xfs_buf_timer" and "xfs_buf_age".
> 
> This patch removes those parameters and makes no other changes.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Remove deprecated xfs_bufd sysctl parameters
      commit: 92926c447c606dcf2fb6d0c3e32491775f4eb123

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

