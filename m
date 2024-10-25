Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608FB13049E
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837563; cv=none; b=ttVTVEKdadw5kOG6f40SbQ9ZYRrkzLVq8EIy+L71KdBvDeNCqKXIk1OXqg+DpaYioEqDZk7yzaY2LqvATl/CIKwjR51CSQscDCI5VQtgRSi6SEsQ5yHbdHVfb+cErGnRrMELsVmpe5Vip944VTqDVuto55e9g7J57LjNjf/BxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837563; c=relaxed/simple;
	bh=9vhntuSxz2ngT4imWWDAVB7gNTqcF7TalPvz9cODmKM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PjoX8/9PzdaiJk9/R+f/zumwIwbSfe7UJtDEGMg3222yeXY7tWFc6iYM7wLUN/tbvgYNCn0rFuxZt25NG+KJ1C/B2y2Nop3o5DeYCzt3U3rCrUwf0oD16eSHp7Pw+mWqFM7xl6DP6OVEhBxbX7pT28+3QQqek5Y9ubUASjOkoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/sXYhM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/sXYhM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6188C4CEC3;
	Fri, 25 Oct 2024 06:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837563;
	bh=9vhntuSxz2ngT4imWWDAVB7gNTqcF7TalPvz9cODmKM=;
	h=Date:From:To:Cc:Subject:From;
	b=r/sXYhM3+t+/mHB/ZdKWT0L+an8ABicIta8E2bBWky7BDBtgWlu2ErxKFRx1odZdI
	 6XPeVhKnPOkCyKdznVc1NyIWGuCghLlKJmyMfM+C1NF8HAmWFW+IggCj9SiFx/+XkG
	 w2f0gr8giwWGZMIrz35OZSmPpGWO4u3Bl16RQsYdSUSgokAdZDA4Nt05lFIw0TQfzn
	 PKpWYiXMRtFvKyy7CkPSieAUY/UVeiQXtGHao+UJa/XQviw5NgTY3iTNjhxHUtA7cP
	 r7ztdGgTXJ+hRFCyQFpCMyrY5AbhiVzYnXUxJOvJyeuH18TI961q28PCpuVuynQZEa
	 2e/cY4Ms/VAOg==
Date: Thu, 24 Oct 2024 23:26:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB] xfsprogs: utility changes for 6.12
Message-ID: <20241025062602.GH2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

Here are all the changes to the xfsprogs utilities that I'd like to get
in for 6.12.  First we add support for the new exchange-range ioctl,
then wire up xfs_db support for realtime volumes in preparation for
future rt modernization.  Then there's some refactoring of mkfs, and a
bug fix for xfs_scrub_all.

None of these patches are reviewed.

--D
