Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86407417BF0;
	Thu, 23 Jul 2026 09:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798856; cv=none; b=uR6d/nKyAB7FFYvtkKlWAf2fzk8Upt9vlyxSnJ0b358wLOqcid83lPokMyrDf39ZfvSTPZYEQz+tvnwM9gSpvz1qLTwJQ6t4/uYPFr8pp8WhUYQZwJNBF9w7o+2yGVkcXysgqkANaU9FYpnn6tQUFOHyE+K+IZcCcueHkhrpmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798856; c=relaxed/simple;
	bh=M3tBdIhDrudci+bESlMDrTVE2IifgmKkbOidBwobrnk=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=a2wldlN90spWClJaX8FEGWtVaKfiGUtn8CG2qDLimLQvwXoXPjbiSIwd63VlBZQzwj0U/1hClHXHlmP6SKDCbqirEQSj7nVBJ4Nssu2xp9eqMUzxrFNP+VL4vzmv1ErNp/vb28fUyEvIscdhVOsUZ1y7SFfGMsHS9wjWEYad1l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJFQaJqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJFQaJqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4340B1F000E9;
	Thu, 23 Jul 2026 09:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784798855;
	bh=OJFzBPZGr85DL163GmJsaiQV0EroZQIfiII+A9U3D0Q=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZJFQaJqtSS3mYcn8jdrnjnuP+lJWo9m/S/2FyHOFG4p3c0h/DgDpD6+kvGmvAWM2n
	 aCo455EfPSMkRRU8tOxW8Wynn75ByaDkqP2cQWfTpQOOTF7EIe28G4ldrNCx2/nVa2
	 133T784ziu4KUh2bEeEfDIVumanmSTXzcYhMQuW3L0aVbAQw0BlhryNPFpiNXvTZiO
	 ZgwsBy7irhXukn8TXN6V4odyfxE8JDHeT321QZSfk2TcSfNMl/hTT7Z8eOozlxq7Pl
	 32WJxnlOS1JyTV9/yzUF33sy8VQV7hfS5TaEcJRllaBevqgZDC2EYA8JE3xDIcq/4y
	 pW8/jyG9eXl0w==
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 0/5] iomap: trivial fixes for ext4 conversion
From: Christian Brauner <brauner@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: brauner@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, djwong@kernel.org, 
 hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com, 
 yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com, 
 yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com, 
 Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <amDiuuX56ChS6LO0@mit.edu>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
 <amDiuuX56ChS6LO0@mit.edu>
Date: Thu, 23 Jul 2026 11:27:30 +0200
Message-Id: <20260723-explosionsartig-getestet-element-b6f720858755@brauner>
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=310; i=brauner@kernel.org;
 h=from:subject:message-id; bh=M3tBdIhDrudci+bESlMDrTVE2IifgmKkbOidBwobrnk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl3mtWSzhy+zuT9oulM6oVGjSvL+y/eMYmSPBt5XEfl
 cnL+y+s6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIszYjw4n+N7ycmydN2Zjw
 lSPr4vzbh5936cxXSP5x8MPjCqWA0I8Mf7jM5Bou3/zq4KPlwSu5O/l1Zvy9uV+3x/TsWqTCt0C
 fgQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-22 11:34 -0400, Theodore Tso wrote:
> Hi Christian,
> 
> These fixes are needed for landing support for buffered writes using
> iomap in ext4.  That won't be ready to land this development cycle,
> but could we land these fixes now?

Yes, absolutely. I had it on my todo but just came back.

