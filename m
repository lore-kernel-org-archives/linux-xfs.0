Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E938194C95;
	Wed, 18 Feb 2026 07:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771398574; cv=none; b=Ti7kcvHvgNg4hcpCLaVV1n8H6IWkcJe2brpyBQwu5v0YV+XaTazCij03SZ6MCsKxdbf/iZJRN3zXxSdzV/OrqoxXFzVBtprJV6JY99qtRMfbMnLof/YevobVNr8bz+VnJAtEOdN9Lc9A8zL971ub56bEfTyN9NJF8Qatk80sUaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771398574; c=relaxed/simple;
	bh=E+JXX/D7nVzCbXMojQr2+ZsL9vr1MB+pmBhAmWQe0k8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=o99xO4lLDVQItMCN403VnqBEFAbH/0VwFEmPbe9Ey8jfEeK7mQLXGte+tmUbnNTsSD108GmQOS8zozwpjZUMe40ISR4vPdr7dXYaCoHZC87I18iKT79qRivEUrTH8hTapLnNeRTmhgNDIQf/EgRLng9CGdos9FsU1eHSCNbcJlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDHuZRUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDHuZRUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BAAC19421;
	Wed, 18 Feb 2026 07:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771398574;
	bh=E+JXX/D7nVzCbXMojQr2+ZsL9vr1MB+pmBhAmWQe0k8=;
	h=Date:To:From:Subject:From;
	b=LDHuZRUu6OngjnaydxbpkZ65GQxnOAfkhQO6/chsr3A1tIPlWufr0b1+Y7Ho47hp0
	 CU84Xv58/u9Dz8KmeN3Es/448wrPKHHoODhG4UPNWfCpN0R1O5kdwP/nTSbydocZyx
	 W64Zm3P4v/79C02NVpxZLHnbBh5jLc40so9xaLbJ3YGRYI4RlHMzhz6U33KDg8hofT
	 +nnCDnYd5CuN6ZjVS//p+IFJXqdAVOmmHJObxpIw7o5Q14hLvOwnJaQDVJccjfBSeg
	 aVhJxskiaXZ1QcFtIFoML2Bcu8DjMTFwmwx9n/YUWowbKgHswjmMyFdnpo2Gcw2V4F
	 BRk+idOUs470A==
Message-ID: <924998a5-9786-4868-ba9f-726c4437cd7d@kernel.org>
Date: Wed, 18 Feb 2026 16:09:32 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
From: Damien Le Moal <dlemoal@kernel.org>
Subject: Zonar v1.0.0 released
Organization: Western Digital Research
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This is to announce the release of zonar, a graphical tool for monitoring and
inspecting the usage of a file system on a zoned block device. Zonar source code
is hosted on github here:

https://github.com/westerndigitalcorporation/zonar

Zonar currently only supports XFS but we are working toward adding BTRFS support
as well.

Command-line tools like xfs_bmap already allow getting the disk location of file
data extents. Zonar allows the same, but graphically, and for many number of
files and zones at a time, which can greatly facilitate understanding and
visualization of a file system data placement decisions.

-- 
Damien Le Moal
Western Digital Research

