Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB2D3CBE7E;
	Mon, 27 Apr 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296389; cv=none; b=BRkezHPdPDmzR7FdmTVldr7CbWa8QjgKYqaVmVeGmo50rq1DquqhpS4MbMELNP2XUhs1xHBGZn1R8o3oWjmYmX6PX+ym8ZXImKaKmUWWXaRV7t8kl1zcv8SLMWKNj1NoQhpzB2CxFcuBDUAQJr6VPGn/x2Orpi+J5poaLXdZRPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296389; c=relaxed/simple;
	bh=Z+13z7MHwZRhu2Tz981IPD7nQ3LpfY+RZ5hZB9mpV7k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Nh+8W21Id8TvGMItItVB1qaCdsafOlogHIa+qtCu2jlGvSKNajVn+FL+9hW6/D0DJGAIvxPmWQhmSdK3eG5PKHRDR+Lcv5btFy77/YO1YsRJxC3VT1zmd4pe0AoWRjzu15UrdBGTSFRm9v4e/6Ks3+6v90cikxT4lJ7XJOgV1uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uUNwpkgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uUNwpkgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB1CC19425;
	Mon, 27 Apr 2026 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296388;
	bh=Z+13z7MHwZRhu2Tz981IPD7nQ3LpfY+RZ5hZB9mpV7k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=uUNwpkgmAM07mZNyoLcxMEGMYf2M2rnRsARvw/663swz6oebKcd54rtwPfNw/yAY1
	 9grknnkPTXrIHvonsMLciCbtp6G9DVHE0yc3Q3w/+nKyOR7uRDJJVm2wnaqjuaVOpL
	 m1pNvTXmJOMDDgapCojyjOz+pnciHXNytbIEXhl2CaUaZSJCxvQXydhtUP0mL1HCLK
	 bKNONx14M9CZj+pcOwPne0Mz8ePtLFU06seQ4HbZTJ5X59HjjKr7/yF5WWlIVFxlzq
	 eFyCYneE/qq31FSlcgyV1HuKAwu8ZAYJW3KPFwpw+uVyeT93Ghx+8k6PyLm2uCpdAq
	 HP9+BFDUUY3Pg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Ravi Singh <ravising@redhat.com>
Cc: hch@lst.de, djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com
In-Reply-To: <20260422073959.10056-1-ravising@redhat.com>
References: <20260422073959.10056-1-ravising@redhat.com>
Subject: Re: [PATCH v3] xfs: flush delalloc blocks on ENOSPC in
 xfs_trans_alloc_icreate
Message-Id: <177729638689.100803.1167697667137061012.b4-ty@kernel.org>
Date: Mon, 27 Apr 2026 15:26:26 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 22 Apr 2026 07:39:59 +0000, Ravi Singh wrote:
> xfs_trans_alloc_icreate() can fail with ENOSPC when delalloc
> reservations have consumed most of the available block count
> (fdblocks).  xfs_trans_alloc() already retries internally with
> xfs_blockgc_flush_all(), but that only trims post-EOF speculative
> preallocation and may not free enough space for the transaction
> reservation.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: flush delalloc blocks on ENOSPC in xfs_trans_alloc_icreate
      commit: 87e63466c9fc30c3d95b8741c3df1f1ff01d7f23

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

