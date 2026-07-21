Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395F547DD42;
	Tue, 21 Jul 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630701; cv=none; b=he7xQnJzPizo2Prs6KXZLz1B12MNXzJ3ZrtvsGr/l/bwTFtfR8cjkPSFZ2bHiqp8dieFR0SQf+nNoe0WVSk+P9iDoNGL33qLm15jCLvXfKPMX9uUe3YL3uiVOvzZhbjiuUXygLreLDk/zY+qsZ0ynqVRXXbrBsqPWbMma3BklyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630701; c=relaxed/simple;
	bh=oLMx/3RECX9qcAQBUpSvWKB6BLCGpw5iSO2ID+x+MYw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=s1S28ESmdDrdpXPVCdX9Am7rsF4OgQAUPQR7nk2V/xnRph1Uw9cjlufT9PBuCAfbVGH9MpNu8g5i1BoOI9k9WsEBEOsbph+DbHg04eJGewLVKafkyXcgjwZvoF01nw6rSCeX0hVlNBtnUjmYXfSL9r2pIqdzVx+XvCK4ZE3yYiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSSw5sLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSSw5sLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C93D1F01558;
	Tue, 21 Jul 2026 10:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630686;
	bh=U60+HHTgCr2qomir4tGqPJ/lH5f7nv0xKVQW9WDaIbc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MSSw5sLm9BAEQVdiZhY+E09B/bVNjWgHLU5SBA0XA6M8tzvIK9dIcy7hmrElgruTC
	 v4Aatk9E+v21o9AiTKUYhXJU50paPfTKSufz/cCFHqqKm6FmX7JKBD9aqh0hsqpWd9
	 gjwwXgtvKH3uwpIiFDcvQ9ZqrBxJ7xc7vWv3BMTaNvB7sUT2q3lXf9wilGWslPr4gC
	 MCWffriCrImULZS907GiQbkhZa9iQzJWT+PHE2x5uwReGxMcL+LJ4ZYb6r6wVwftyt
	 XPJbQSKDGkFl/TG02VZCcDBz4DyYQ/oCJ3WGsHwCP3H+jmhvvPgDmpFz+x0aHG55kp
	 okTRNp7sLlWxw==
From: Carlos Maiolino <cem@kernel.org>
To: hch@infradead.org, Yun Zhou <yun.zhou@windriver.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260713145002.1627608-1-yun.zhou@windriver.com>
References: <20260713145002.1627608-1-yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-Id: <178463068521.324722.15830636968748784433.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 13 Jul 2026 22:50:02 +0800, Yun Zhou wrote:
> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> xfs_trans_commit(), which flushes the CIL push workqueue internally.
> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> lock these buffers to fail them, causing a deadlock:
> 
>   setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>   CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
      commit: b9ad0b9891dd0ddbfd8d9bfc7a55b0b70e9871f2

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

