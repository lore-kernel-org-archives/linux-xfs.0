Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB07E1
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 11:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746791002; cv=none; b=bB4S9Rremdt6BpBVZvnCnSFPezU0ZkydGUMIH5DrG9x38BMLdfxzrCQzkIOdw4O+wv9BHCWbLqnRh5Qzpw4YDXE4CSBprFNrCDB5ap7nViyFm3O1cmKvkYVQB48ySBWpwJAOSRSojujERonJaRDIs9uVa4oYAaSmFzd2fD0CiJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746791002; c=relaxed/simple;
	bh=8sGgvDsfjn/jUVQVemHOZwMv388FHc1+FNdtj9VeLmA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HkhEnJ/6/rkWmF4X7kNQj+hCp8chQv6HYmVFcjaZr24O4v1CHO9lVJulsyh3O7fj7RjKh9PqkXk/DhjGXm+XeVOAHjOVK16Q4l5i+wSOA4Asq4x+IXs62vYrO94mdORkojhUmk6FM89UGc8XqpcXpZqQj4YwIZJ1k7VqhK17XXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSE8fucF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSE8fucF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C324C4CEEB;
	Fri,  9 May 2025 11:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746791001;
	bh=8sGgvDsfjn/jUVQVemHOZwMv388FHc1+FNdtj9VeLmA=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=YSE8fucFdeRqpf89mljyu9ko4e5rSM26s5fvqdOmrABB1HPR1iotTGh2Ift9Xuse+
	 chbRDSjL+EXaniDu9ZgeFh2AzrkVlU+hB6q7irIgIEP3PUfDh2xpmmK7Ye+XCMIY8D
	 F9nmaDzBCm0LMAOZktIR8lW1ne76O2piTTkG8r69nqVEIFsEkEC+2mO62rNrlC17+m
	 H14eGrpiGShYEhzZ6GCocSDTJfzWl7JPUTIKTcOnaRBwZHdwou2Q3cuONkW8k4HhY8
	 xd+61IsSEDdMr5N8X/shCbCd4GkYXkr3z/FI9VIP1nunbat2uf/VwGjJRzEZzmhDn2
	 qkjkHDVvZWaSA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>
In-Reply-To: <20250505233549.93974-1-wen.gang.wang@oracle.com>
References: <20250505233549.93974-1-wen.gang.wang@oracle.com>
Subject: Re: [PATCH] xfs: free up mp->m_free[0].count in error case
Message-Id: <174679100108.556944.1139496017065953474.b4-ty@kernel.org>
Date: Fri, 09 May 2025 13:43:21 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 05 May 2025 16:35:49 -0700, Wengang Wang wrote:
> In xfs_init_percpu_counters(), memory for mp->m_free[0].count wasn't freed
> in error case. Free it up in this patch.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: free up mp->m_free[0].count in error case
      commit: 3af35b41400cce7317b642c45b762b41967dfdf3

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

