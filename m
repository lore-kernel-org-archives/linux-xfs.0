Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F441E4BE
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 12:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727179603; cv=none; b=g53T6CME26Dv6+BjJniMmDAxwhWihD7xiyuAsS1y6413WGUXY6uQmvFgz40bsuK0/h7PrGD59ndVYP+eUe3nJu+XTqEI845OXwsvjlnBGu3nG42RpsJoL6yHiDK58hgEAhYGIfbblFxKu/ArNdjc5wPsfP+bG9MK32Z8b2Ijq6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727179603; c=relaxed/simple;
	bh=jwCKwcO190eIPXo1XxmopGINDPFtrFXqSXfr2woO0Gs=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=u5U4AB4g5CS94DcjKn4aU8q8173Yw44/dT/oDI4K/85d1NtnGfXdShNtZ1ychnJrFpQh8NQf8LnRsbC1etQtpwReYleQKKGVMKHPAJLui86x/nTZDn7K4JohcYnR8zftn4sx4xmXMoFE11Y84bLu7Fg1yW/KDJ/lhbb4sEgscsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMuT5lAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMuT5lAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2515FC4CEC4;
	Tue, 24 Sep 2024 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727179602;
	bh=jwCKwcO190eIPXo1XxmopGINDPFtrFXqSXfr2woO0Gs=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=IMuT5lAWQ+euZgYm9t3OaiAnAjiSzXlNh9LikDIsS+7cXIBRL7zSszOx3GXcjZIE7
	 xzP0aX5hLAOK4/TpPQ0KVzg0HjIg9zxeDUHND5rxysya0ES1ujVOxftGv6g4pkIkRq
	 VX9uNUnpo/McgbwBGTzIVC3tHsE89j3Q/aeL9v9nP79+9iaPlyftQDQOcyw/s6Z/Je
	 RYfGJf6n7ZPIAi99KoYpHfBJWnLJj3p6N2zdUZIudCiXI4KRvEAYjy1EnhFpgEcJI1
	 S1/hSzIWbvTw7AaIaAnpbuom9ob4znJHlU5bS+0lnoQDYVu5DzzGGxwMiM7eMe1EKS
	 6wE7+bxAiSoaQ==
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
 <20240906211136.70391-4-catherine.hoang@oracle.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 CANDIDATE 03/22] xfs: fix log recovery buffer
 allocation for the legacy h_size fixup
Date: Tue, 24 Sep 2024 17:34:25 +0530
In-reply-to: <20240906211136.70391-4-catherine.hoang@oracle.com>
Message-ID: <87zfnx6ysv.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Sep 06, 2024 at 02:11:17 PM -0700, Catherine Hoang wrote:
> From: Christoph Hellwig <hch@lst.de>
>
> commit 45cf976008ddef4a9c9a30310c9b4fb2a9a6602a upstream.
>
> [backport: resolve conflict due to kmem_free->kvfree conversion]
>
> Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
> mkfs") added a fixup for incorrect h_size values used for the initial
> umount record in old xfsprogs versions.  Later commit 0c771b99d6c9
> ("xfs: clean up calculation of LR header blocks") cleaned up the log
> reover buffer calculation, but stoped using the fixed up h_size value
> to size the log recovery buffer, which can lead to an out of bounds
> access when the incorrect h_size does not come from the old mkfs
> tool, but a fuzzer.
>
> Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
> into account for this calculation.

Looks like this commit has already been backported to 6.6.y. Please refer to
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=c2389c074973aa94e34992e7f66dac0de37595b5 

-- 
Chandan
