Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068474C62E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391481; cv=none; b=sA/0fyZS83OUv138BlCa8qIn+qiOSJ6nLpFVy70TGMYScjgRbi40Dj3FIhfI0UJPrJBpmCm+MVFgS61ZcoXerxI+5qX4V3JSBgDyvDFCNV9URwxXF3z0pqiTiKq3u6oBNeM+RdQILeMTLKbHFF1DSpXu7JStA//VTujIhJhb5V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391481; c=relaxed/simple;
	bh=V3PSxwrjIWr+kK8S3i35+nxbrj07MScg04UCnVig2gY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AN1oxuN7oIvO81v7vnDmxNjKu8ZkY8dAkE/UvlouQE4vtbS4HPwheQT9LPXfknlddNAofZ11YtDUgKlVW6GapJBxstbGK/HBg9ObX7kQl3+QH+eRMY8Iii2Sq4lD8Mf0eUO4DKgFbwIkfmKx5ZDhgLET+jTJOiNawfawhwo5Zoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKbSxabu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKbSxabu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9258AC072AA;
	Wed, 17 Apr 2024 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391480;
	bh=V3PSxwrjIWr+kK8S3i35+nxbrj07MScg04UCnVig2gY=;
	h=Date:From:To:Cc:Subject:From;
	b=MKbSxabuc1N/57O1VegxV9tpNkIjmIc0B7v5XE+LlcZOZtz3Bs8PtyIFFhcbNPo9j
	 hn5xWza+ySNhh+SmUlch5zWx9mTxa+W3kB/sbhYyplygTyzwR1/5GPfj/2+Gwa0Vix
	 eqYPEIgG08ucosjY3TBhZ6Mec7QAYJHeyNzQB84bPIqdjfUYvIwgLJFLrRb097hdxN
	 Ozr+zGR7ZsXN73Hx5gLFDeLu3cJoF2SyU5GvaRDgvUIEwxIDaRD5G6LYc5cwtq0UHh
	 qcclsuc5ELCYfYAyZa+QAPj50lBUEzsWP8QHdhrtqjdqI1v0fb+xBBbK81yAujoYyu
	 coxXoqUAT+y8A==
Date: Wed, 17 Apr 2024 15:04:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULLBOMB] xfsprogs: catch us up to 6.8, at least
Message-ID: <20240417220440.GB11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Please pull these branches containing a series of bugfixes, cleanups,
and conversions that didn't make it for 6.7; the 6.8 libxfs sync; and
then more fixes and cleanups for 6.8.  With these changes, xfs_repair
gains the ability to deal with extremely fragmented files; the ability
to rebuild a bmbt if the rmapbt data look intact; and slightly faster
btree index rebuilding.

Everyone else's patches notwithstanding, this gets xfsprogs to the point
where it will be ready for the 6.9 sync and more enhancements.

--D

