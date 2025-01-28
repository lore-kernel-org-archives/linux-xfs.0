Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6575319F40A
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738061870; cv=none; b=X+ywfJtiFFJTRbPk6AZOTEGv2KHu1kW5pRAAeDBSqToia0lnxChCG+bOFuvzHX5FKxacCjn2x0qjWhksx7Pw8QjM4XUHyJDijq780kD1nRAbmw6XpbjQNFhJ8hZhQSyR2ZD0fwms7IjtbekEsOpsgHg0grzfUCzPukHEj6LSIK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738061870; c=relaxed/simple;
	bh=lyhjVKsszZ3t72sKhn6Tuzegl3MWw51Uz2yHwNX1G2Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QOtAGSnsvQuNnAN/zkpSRGcx1COV78MrbZ6BGp99FJblrXqaWGlRWjR5/RZc+WUtbeyZF9qucwkIEvt5E3OH54ehkAf2b16WX89ddGYByGFAxQF0yuDXjIFp0sh8kHV03bZQwJawmi3qTqHOozsKaK48fVPdcve3adxTLo1PVoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejaalx6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejaalx6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F3EC4CEE3;
	Tue, 28 Jan 2025 10:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738061869;
	bh=lyhjVKsszZ3t72sKhn6Tuzegl3MWw51Uz2yHwNX1G2Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ejaalx6uO+Pt9qE+4pmuK0/lFEfMGE1miCA4ZLxQQbdWdtHA/Co5/teVxD7l81VYt
	 BvtJfwg4i24GZtSIFVbkEKAHgeAfShN4NnNWPV4b0QcUoaewHVFjRRqNPAqhlWY7+Y
	 X4EnczPZkW8Xj84PJOHEYauxVIbna9lVJrh65Qh8DlY5fTLwk3BD+SXbHuazpVAWfd
	 p+i0rUGIHdGCS2uZLCjHd5PquziouLJqjfEZnaa/I1f94gPm8w4fvp6m9oj5LQtW+8
	 VkeAbVhhjmWCaq7vYIbiqXOulCQ04vh9K7fhHKEpEGsyJJvfUh+G6VzTUwdwtxLVl/
	 2tr+jNbsaH+Tg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20250116060335.87426-1-hch@lst.de>
References: <20250116060335.87426-1-hch@lst.de>
Subject: Re: [PATCH] xfs: remove an out of data comment in _xfs_buf_alloc
Message-Id: <173806186885.500545.4547055805305781797.b4-ty@kernel.org>
Date: Tue, 28 Jan 2025 11:57:48 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 16 Jan 2025 07:03:35 +0100, Christoph Hellwig wrote:
> There hasn't been anything like an io_length for a long time.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove an out of data comment in _xfs_buf_alloc
      commit: 89841b23809f5fb12cbead142204064739fef25a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

