Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5813C4577;
	Mon, 10 Aug 2026 11:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362944; cv=none; b=JlpeDm+cMP0/MrSX4tMH0LGAElNmDOzCN0qyhbPyw8kdwPKQGfFJ7GvQ3b5UdFnII0bqsW7FJrqjsZAbTXwwJyz4OdoHHFmD8mpiHNRsNhvrZ46xes7r0ykFri6Jheox+2pu2/ZFspCGt/wI/4mCyJD7CRByRI/axSwuuDXPvYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362944; c=relaxed/simple;
	bh=9lrskCaJKWpcm5omYAZ58pVzHQZxu+5Cs47qsj/67ng=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=olH65U0Il08Wh2X/GQcIxCRb9SevgQx4ZznhDoJSCtC38o1Q+OV0tRKjHRa0GIpkLSBF5AEdwFPAmkbIdb/JzD8b9TnDfhXls+HoLt/SsKJUMYiU0AwkygSnAJwK5woBDacanFVdbX6GKrxTSGr2EIbhIaL8u+tm88mzPvUXhrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaYFFy0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaYFFy0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C941F000E9;
	Mon, 10 Aug 2026 11:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362943;
	bh=N/H+0T/Bhz4b9F9EG02HcXCmdrXRUaFEwtVVTgzvSJc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=iaYFFy0rAKpNSkTkxgJ7Q6uRZ4lBNNTEPmwRNQyRBhidWUHNpfJcZ7RiKSPCHFENZ
	 n7QFbcJaVnji3lx77IZO7QaoBXdF/SKIEHC0hqC9g40EUKJyfD1j2IBQVLnGHERVCy
	 FKdbz9Ays1VEyl5IsQfGTaqPgkxaYRpa1lLDsk4YxIoaKtt9Zhupy3XxOZayfl84OJ
	 S7LVwe7eQsrRqJwY/Zearj21TWYliyTJFEQ/beD5zb0Mup4su5LLVOsks8DdBRLst+
	 q50FVGk+yrqrsclM8+k8rCDYENNF4TAIf357F4YbhxElfv7BM26yPghzWfx2opBy/I
	 Oh8wjXLMcmSuQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, leo.lilong@huawei.com, bfoster@redhat.com, 
 Hongling Zeng <zenghongling@kylinos.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 zhongling0719@126.com, stable@vger.kernel.org
In-Reply-To: <20260728074340.84166-1-zenghongling@kylinos.cn>
References: <20260728074340.84166-1-zenghongling@kylinos.cn>
Subject: Re: [PATCH] xfs: validate attr entry pointer before field access
Message-Id: <178636294070.58486.5392695616314292202.b4-ty@kernel.org>
Date: Mon, 10 Aug 2026 13:55:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 28 Jul 2026 15:43:40 +0800, Hongling Zeng wrote:
> xfs_attr3_leaf_verify_entry() accesses lentry/rentry fields (namelen,
> valuelen) before checking if the entry pointer itself is within bounds.
> If nameidx is crafted to point near the end of the buffer, these field
> accesses can read out-of-bounds before the bounds check at
> name_end > buf_end is performed.
> 
> Add explicit bounds checks for entry pointers before accessing their
> fields. Use offsetof() to check that the start of the flexible array
> member (nameval/name) is within bounds, which ensures all preceding
> fields are safe to access.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: validate attr entry pointer before field access
      commit: b7eea80be25f3334f131d52982b3131aba77b97d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

