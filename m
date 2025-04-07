Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D977523A560
	for <linux-xfs@vger.kernel.org>; Mon,  7 Apr 2025 11:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744024060; cv=none; b=kJv+6lOZKFgZIHSXb2uIOfyC9NOjCux9JQKxhtvwrjCENsAMTC4pIbCF25BORzwIyaNyQDGCK6H/OW67od9g82nzLBnMlDzaX6XhhcZoP9CYUnWYofNCdTrij072rs3R4wJSXJUZBg57H6RaO+3I4svgjL5y9KBH76YFosuxfEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744024060; c=relaxed/simple;
	bh=UA9UKGImSLOtRlsMnEhPc58Nrg/CVHnkxS8m/F7RIpg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JcuObzJ91T3+iEcwiMVc0OHiwjwIbQ5GaZMJJQUBy9/6bVXK24SpuJl44GyDw0imT/0K7Vf1ZSQ9pv41htYUkuTCwiEDK+0CvxVE8Z0v9US4b580Lz0QuMQcyD9t6SHSbUFCYdNiFwlpD8QzBst15rlV95wNwzdqm40o0xjk640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ga2UDs5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ga2UDs5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B356C4CEE7
	for <linux-xfs@vger.kernel.org>; Mon,  7 Apr 2025 11:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744024060;
	bh=UA9UKGImSLOtRlsMnEhPc58Nrg/CVHnkxS8m/F7RIpg=;
	h=Date:From:To:Subject:From;
	b=Ga2UDs5xEAXCZOJIPkpmYgJplYVJuiDSVUu25eht2IPXDnxMz7qel4eXubraGyuQw
	 yCIhs/lhjNsuKKBfB2PX8jlbsQoz42f/ifSCC+SWBIFFSo2nSMO359YLZ5SYgGtvwI
	 aY5ZSZ4IQEJYeAIkxIJXM8t0M8eWQe5QQl/e84Q8mXyy9lvUMyEpMOSrfYqDcNsup5
	 W3GBQ7C30tQpuK/yRZpnpAAICZW6Tz6d+QYBhP+VxK676SCZt4yzeilCdHBRfWf0MS
	 s1J5RsfaQPhDdTMKaLfj9XkKXthrb6d3wSy/Fd+tTxNEyiIiKVycawnHxzkkHAse44
	 TQ4BeRiKI6jUw==
Date: Mon, 7 Apr 2025 13:07:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 71700ac47ad8
Message-ID: <vx4o4o3hfvpuaogc37zq2uubj7zk2ephqdylzrivej5lj4wgbz@th3meafqu5bp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

This just synchronize for-next with Linus's master branch, to start 6.15
fixes development cycle. No XFS patches have been introduced here.

The new head of the for-next branch is commit:

71700ac47ad8 Merge tag 'v6.15-rc1' into for-next
