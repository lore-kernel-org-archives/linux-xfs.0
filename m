Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5D1A951
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294088; cv=none; b=Pt3pmo/xN9vjVXT2uV2fOl5LmIfU7S5PqhRozz8zeMwsybxlu3ET8HMqLCIG5j4mVYz18NTnhsABMDQeSBwHhQnfVJrkw3B9to74/tkVCVxVVEKpmBcrCzBQqd7nJ7zH3UzOFtZ8E54kfZ0foYj0cwUlNZW2dzoeznDfB8IRkVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294088; c=relaxed/simple;
	bh=UZSwCYMCjjnkcNBcyq2scdLsph+TGbf8Jk1SQPZRsIc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SicP1UXMPDg42OjmTW859GsU44Wljp48TF5k+LPnT4+KNqQL0XD2rnNzUau8144Rd0h3bj65kKhxTjJ6tqiSQyvnEKTC27Ki62Z5b/OPtkVSRaIeCzkCoERiaBnnZkuCSntPCLRSHbMifjMPYqNveZSx0vtZUfX7p6JV+siVe0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ouvi5Pqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouvi5Pqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AAFC433F1;
	Wed, 13 Mar 2024 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294088;
	bh=UZSwCYMCjjnkcNBcyq2scdLsph+TGbf8Jk1SQPZRsIc=;
	h=Date:From:To:Cc:Subject:From;
	b=ouvi5PqpfPlZft9EjycgmjR+DZUgKyp3cXTOU3ybZlB3QcwSRD8Bsw2aLCZyuEegl
	 Ep/nktTlCunmKuQNqFJ364ApETVSBYhsgEnsrEK3nxjrD7TzC0bMRyWn/rEhPuDy2q
	 qFRilS0i5vfwscE+mUIYI5t7EDMG4SlpHo8HP42u9fuBnlF4uTGasxgDA2XnCuYii1
	 W0Ho8NBjcjjyUY9jxpz8YJgK77chyCswTUW0CdO8DxpRXLBAW9/edRLs+ZhSWleTlk
	 9VTSOiMSOReungXnmwL+c8Lw7laIyKtr/dL0gZWAMTumaq9p5rwibZr57fI3AkdNiD
	 3Mmi7ANvlsYbA==
Date: Tue, 12 Mar 2024 18:41:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfsprogs: everything headed towards 6.8
Message-ID: <20240313014127.GJ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

I saw that you pushed for-next again, so I decided it was a good time to
roll up all the fixes and accumulated libxfs syncs to get us to the
brink of a 6.9 release.  A lot of this code are either cleanups for
units, refactoring code in xfs_repair to take advantage of changes that
landed in the kernel, and some new code to rebuild bmbt trees in
xfs_repair.  There's also some long-delayed patches to try to get mkfs
to format filesystems that can handle certain levels of concurrency with
less locking contention.

Sorry about the giant patchset tho. :(

--D
