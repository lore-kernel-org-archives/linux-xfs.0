Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF6B3BB22
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302404; cv=none; b=FdwdYZJ1juybywbnoZF/woFIo5mJEy+WvyYMFWgnM2CfdI07qg+JYM6XMfc/ah/r6LPlze6PCN1aHyV0qAJCNhCdboVeJAAuGLaOd2cMwO21MgWeBCzQki1bJT9jr6wPjxirr5m2mMLZr/krzP8yhmQ/qkjuSuxhjlY7odl3bXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302404; c=relaxed/simple;
	bh=5Y8TQmqizB7+H9ncjs205OCWo6ehABy5iRS2BdGiIx4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AYwyLi4l1bjUmfRiitvsvZuJyYjjAAFwG0nsYNZO73y69L+XP4LJ/wclqVvm74M0w2pvx0RXV45IR/WCEf6sscH1ZC+0ErqX4K3EdrsDtGNiFCzmc2cFFHtW++QjsXRQ/htzmr0mADBXiCUDNAbhpVZZDWByo+XLrzFahMLFOug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3UiVYEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3UiVYEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812E3C4CEC2;
	Mon,  2 Sep 2024 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302403;
	bh=5Y8TQmqizB7+H9ncjs205OCWo6ehABy5iRS2BdGiIx4=;
	h=Date:From:To:Cc:Subject:From;
	b=s3UiVYEf9kQcvOX2wXu/zLjZEasYELYJS3osOlhRQ/+kOIj2xXFDB2OsngwpU0pZN
	 ITeNMGBlt/zSJb6jYNTYei+5l/Jy1FInxxtd988nVnll1EnDgcizKWFmp1ffdtPv6O
	 vTgV5bhrZ/SLXPx3pwvWZikWfe/pndHuRBy7tDmOxlCljFQDTVYyEkOYz82LJ0+6nx
	 S9hhCiklE57Uwsjn7jT7gBuIVy81jMJq2GvWtuEffEyEOEuIpy1u1l5wf+LMsHhBbG
	 BnK/FvjAZpGszZF5iSwyItWZlbqA7CsMX9Ydt5gqtM6oX4ikcEpbDRDPCJdRi5vGhq
	 3GTSKHIol3SMw==
Date: Mon, 2 Sep 2024 11:40:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULLBOMB 6.12] xfs: a ton of bugfixes and cleanups
Message-ID: <20240902184002.GY6224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Chandan,

Please accept these pull requests containing bug fixes and cleanups for
6.12.

--D
