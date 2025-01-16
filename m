Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C77C1862
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063215; cv=none; b=hQI5XxK/QNpFyaRYC5MnIIBoHQeFYmBzUF0y7A9DaAwT2y3EwIaND6+6x1mzkaVfblAYvxwhp36EJL/Nkx14XT20JEvXtBsQQjgFAPUoufkBTCMMPCrIxcBYBx3IX1QlNzZaJ4xI0yVhn895e/PTygD3p27i4k/A1Sjv4KzqnrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063215; c=relaxed/simple;
	bh=PKCCMcu/fN+TKLdf/9qspM0VERUHj8VHB2fQsqbqlLU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VGAMkkU2LWPz3ofFTLyKRQFgfibN2PZmjAf+olht3NcEfWZlmnx9Oyz82iXQYfjdYcX5OnyE4om/26oEVRH6aF54xB/4yW+s5cLZb7vFXlQ7Yk0RwxqTO5XkMRIZf6d0d/+NbIaOq3xLtYiJSBlWD6bIQxJXH4B96PhYmV3UaAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k81Cu//c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k81Cu//c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21F5C4CED6;
	Thu, 16 Jan 2025 21:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063215;
	bh=PKCCMcu/fN+TKLdf/9qspM0VERUHj8VHB2fQsqbqlLU=;
	h=Date:From:To:Cc:Subject:From;
	b=k81Cu//c7c26NxKnGgdlgI4UJJ0nxWd0eL6tpBA71O+MuUF2qhvtXCc10lQhikC4A
	 ir/sluWhSGihBlO3Azsxz6o0iKM8Da0lnoPuxOh1oUoEkU+xtVwvDw6SG1Px3CybZk
	 H72Vq6UL6vdJl6XAC8H289XohsBHTg8d+wMvdoilmJ+AKgQy9beo0DXmJThnPgWdcA
	 6sCKzvTbpDq0cV5dSE5oJFM/PSbVn9ONygyKKQ55GFhVnfrfKBOyoOKwGmbQubg5OC
	 G0Ak5n2EM5Epl27+dGko834mYvbsC163B32W5aJG1YjZbjRheWMpTSaUpVeWy/vbNH
	 BfEGakHw0awVg==
Date: Thu, 16 Jan 2025 13:33:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHBOMB] xfsprogs: catch us up to 6.13
Message-ID: <20250116213334.GB1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

This patchbomb is a roll-up of all the stuff I still had to send for the
xfsprogs 6.13 release.  Of the nine patches, the first one is a libxfs
sync for something that went in midway through the 6.13 cycle, and the
last one adds a piece of missing functionality that fell out during the
rest of the 6.13 xfsprogs review.  Patches 2-7 are bug fixes.

The entire pile have been reviewed, so there are pull requests at the
end if you'd like them.

--D
