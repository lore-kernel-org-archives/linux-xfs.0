Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F1A3A6EEC
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297757; cv=none; b=ChAK82MJBLUgg+yX3NFR9XRW14lc/5oLhSg3afINgo44NohJiE2t9TRMMHN+qk0zVbnE6+DAMEqo9lRk9WX5nUIrpicLHTmyPJ7aBnL1Emt+GelnVQG0AAvY6v3Mp3/q85/zAPPSTJS68dDtXTr2VBfukFyVW0C7LE/6UoIojDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297757; c=relaxed/simple;
	bh=jBEhMLFuNRabqP3OmmADtoyI8lZzRtLPdcgWxVps7Os=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IIrMpSIBRo5jwImXCPEB3TA4KFLpB91qSV9xRUp1ZcpKbv3rbGi1FiQXOjdCgnvgU5nn6Kr3iCT5is2Dy9NtZPA3DRLzqDt6FqTHCMrfYmLacUie9W+p5cdgvEdLgB6Y4excrLbt+6geYr8YQw0abB/6Q4O7FOo9K5vaK7IQeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpnZrj5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpnZrj5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAB91F00A3E;
	Fri, 21 Aug 2026 07:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297750;
	bh=Xcs7XUSJo4aVGVDMI3zT1YOrWNzK6Mnf0f5a3VsIK+s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=PpnZrj5ZFtrHCRU/oQy3m6KW0pMbjVvpnR8cHEeaVUgy2cUxrQLJbsYUQERcXFsX2
	 izp3x/KCDHi/2mRhHQl8yvp8U77ifZbRqXIIqRxCEBT+gYDvaj1NSh6PyBcIU2VNTq
	 0nTtuov0w3IqeUL/xfm041e6ZKb3Eb0Fc466aT5s4+ZqBFIw5URKL0KXcKDBSBMKEi
	 pkNwNYafgPlCZEws/QxRd08+J6uXjCxJ9ryASRLqZ8GaCoKpAdOnyCKhLORraVaWrr
	 mwiaiOeEivoY45m4KwEzd1fHFn7JBovvY6Ez0IbAh4K2An9IUBLjgflTxhIupvPOWl
	 NgtL+eEljV+VQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260720140921.2269927-1-hch@lst.de>
References: <20260720140921.2269927-1-hch@lst.de>
Subject: Re: [PATCH] xfs: don't flush and invalidate internal RT device
 twice in xfs_shutdown_devices
Message-Id: <178729774951.580975.14022347336117999852.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:49 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 20 Jul 2026 16:09:21 +0200, Christoph Hellwig wrote:
> Check for an internal RT device to remove a bit of extra work.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: don't flush and invalidate internal RT device twice in xfs_shutdown_devices
      commit: 7fc296b379edc0fef83890097af3c9537fbf4364

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

