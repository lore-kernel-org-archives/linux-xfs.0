Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB04D35948
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734633158; cv=none; b=ug+vmYoYOQE24E2KMpn2/yp/HtGqPSp5eIl6iEfbqM9HzNG5b5Iw08YLr7Tmj+hx0X+JsMy2MFwbwExzsuvKMIp+glGOpRHSGBMJAmU+UAt01hRqnapLBzCfKweZX1+BWNXbqQFGqcKWYeF3fq7NZvR0K8TjxouDM3HpVbg25mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734633158; c=relaxed/simple;
	bh=eIUP9pCb+8j/e4rIF+L4uOzXbfS86zbDhMc/QElEzsw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nuFCzXmO1ur+MLd8Sac2JhygB415MhaQtQce9NuHOyy6noYD8gA+7w2QjBNBw6XejZ22tihUvhRJqzQSDm4J/CzU0ugVMEZR6n+EXy1I4PPXCnrjF+xuwaYsUts4AtjPXse+KSP1Kf8VdjeVT6do+JwxFlRantQyYSPD1C5EjsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCoFoV+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCoFoV+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E561C4CECE;
	Thu, 19 Dec 2024 18:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734633158;
	bh=eIUP9pCb+8j/e4rIF+L4uOzXbfS86zbDhMc/QElEzsw=;
	h=Date:From:To:Cc:Subject:From;
	b=PCoFoV+R/KDsHw7csP+3LkOlJT7cYBts243BBSIvGKkGFSTDRKh7/xhQDheRlzJwR
	 jIVbeK0I8P9XO4K1C/5UkjJ2Akr1YSVBjXi7T77XMXyq0bkMN+ryZlKBt2AsiSAQO+
	 z0db+tMJoQZjoYfJdiiM9pPlfcHHc5ypt+3UbaoqRav6b8Np7+L4NsGZUgMiTJFrfY
	 4YQIpqXajwMN7jg8PXCCGegZeyxjLG2lkf0Ru3UsMFriEMJzxmGzgby1F9M04ZF761
	 aAdqIaS3hXQ98cdCKZr2gHCZgF8jBg9t9xal5DbGNVc44+1qYAxJCBcqROXzom25hu
	 bqfLbmgRWyGKQ==
Date: Thu, 19 Dec 2024 10:32:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: helpdesk@kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: xfs <linux-xfs@vger.kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <lrumancik@google.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: Create xfs-stable@lists.linux.dev
Message-ID: <20241219183237.GF6197@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi there,

Could we create a separate mailing list to coordinate XFS LTS
stable backporting work?  There's enough traffic on the main XFS list
that the LTS backports get lost in the noise, and in the future we'd
like to have a place for our LTS testing robots to send automated email.

A large portion of the upstream xfs community do not participate in LTS
work so there's no reason to blast them with all that traffic.  What do
the rest of you think about this?

Address    : xfs-stable@lists.linux.dev
Description: XFS stable LTS mailing list
Owners     : djwong@kernel.org, tytso@mit.edu
Allow HTML : N
Archives   : Y

--D
