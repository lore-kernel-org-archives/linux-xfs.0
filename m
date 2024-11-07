Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408F32114
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 13:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730987653; cv=none; b=Dewo40Yp+CCzIF4WxnBVT8iZ3uWgwsvhaC8uE/WvRpzg3Cs5p3Cgsh31g7bLTuWE6PaEtLSH+jjUvwP5hlQb9hVbrkWyA3w7mkILzB+sANe2HvnHPjRg6S2SzN/ocay3azWDoA2tqa2BoZEJUTQWgsCEC0EqpR+Nguo/8MAjmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730987653; c=relaxed/simple;
	bh=ssiVZa4zwzxdI5Tw0CbTTyO7RmyDEY3QaCxbP9jn1HU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M+PrWdwJCn/h2NW/Chj5vmiKKPLRvE7WtTBaAPGzaj+h7O6nFN3BrvC/1nTlHjUirI7jUNAqA+hHvpI44T6FtNNjffcxMlHP289HfI3NmcfW5bX2iwMlGGCgWMmz3u/+gKZda+z5O6uSJKVvr4/Jt81XV8slWZSlHHTb5dQOTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqUNyDKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqUNyDKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACC8C4CECC
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730987652;
	bh=ssiVZa4zwzxdI5Tw0CbTTyO7RmyDEY3QaCxbP9jn1HU=;
	h=Date:From:To:Subject:From;
	b=CqUNyDKagH8o1o0Ux8iUFY523G7DrabksNsJsIyuVn+57g6czGRQU579cZRiGZrdD
	 WVdCmCg1tZeud+PTFCE/+qVr6ByENFLuUTc9LwgTUrsTWy+ahYmMdoaSSpMXmGxkbv
	 klZHf7A13Ohq/soWzKtt+FOIZLozEk28VJBRpgEgwpLD1Nffwak4oQGO9gBPUNYTZO
	 3MT9uUxgVjJVCPlyKmbak2GD4w83GIglSO/ghPZSveB/LGOAoIvOt2JwSFtTQRfx0P
	 ZgPErGHpQvg6DuQSEz5uMTMg2gGJ6uAfib1v1qLHPe+2GMl+Z8tnyy+MGhQA6eBywL
	 AfJ7kIOsFb+vA==
Date: Thu, 7 Nov 2024 14:54:08 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 59b723cd2adb
Message-ID: <jzhvk2rvqcvf34emik4l7oio52t45qgomrklxt47t3gycqoklf@blsegvox5wz3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

this is just a heads up the for-next branch located at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has been updated.

This contains no new xfs-patches, but synchronizes the branch to
Linux v6.12-rc6.

At this point, unless any urgent bug appears, there will be no more
fixes to 6.12.

Next patches shall be included in 6.13 Merge Window.

Any questions, let me know.

Carlos
