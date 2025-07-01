Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42201B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751392992; cv=none; b=t28TlrY0knqqvxhpe0qw+EnTAGNAYqzmFA5F72IbhMBptEqwFARpLqibN39ErhPl/8D5LwDTbOPbdPLC52LDI/oBClam0WKBAXlZwIhnNrrTRp/TLrHkDKvgk6ZYnYH55zB4qUsWNBoHTEAlNib2NokfBK3DXr/RV/EajoLaAmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751392992; c=relaxed/simple;
	bh=Jy6KWnUAMZTmxGLYsPaqlOa5qDINCKLuRJbMFOIKNT0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DZ2rBlS24Pg2UiVFBHGmGCZ1kjY0mLRzwosETN6k5e5iBBKLQQsZMV08WPz+oEFyUSQMPTMjzfwOADM81hIcUsEHq8yhKAZ0//OhdUBmn4Q2mhcOgI+pVQADE4vy5rc4lnAXqWxuy2GitqklB/DVkAWrzPHbyT7DsX/YIPZMfRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3ga8/AH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3ga8/AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46919C4CEEB;
	Tue,  1 Jul 2025 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751392992;
	bh=Jy6KWnUAMZTmxGLYsPaqlOa5qDINCKLuRJbMFOIKNT0=;
	h=Date:From:To:Cc:Subject:From;
	b=T3ga8/AHdvpMdFw5NERXhx3TljoqCMGjTwM54IS1W+n9ivs/flNKuQZqPR2D/68nR
	 ENyGxC+oRqLQLFK6QDBpMshuBrrVTeWWp+qr8vDizQVS/L43RvEPGe7LNN7/aZHfZF
	 H+tGITvWNTtSsoP4n2ZftHNa6qO3IDCujk0XJtlyJBkJJXwq/w8n2edSEuiPU2CqyJ
	 eG3vFI9h2B5OWEjufjN84bmUcfg0dYSQb7ghLsI2QMqoSNKI05yt+0tLaXlPjwIlqI
	 77Yan8TM60tzX0W8oaYg766O+dELrPCSRePQRde3NU2q8wTZ3uymJVe57cUP2GXv5e
	 f9sLi37GKNFrQ==
Date: Tue, 1 Jul 2025 11:03:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCHBOMB] xfsprogs: ports and new code for 6.16
Message-ID: <20250701180311.GL10009@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is a collection of all the new code that I have for xfsprogs 6.16.
First are the libxfs ports from Linux 6.16; after that come the
userspace changes to report hardware atomic write capabilities and
format a filesystem that will play nicely with the storage; and finally
a patch to remove EXPERIMENTAL from xfs_scrub.

--D
