Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14973C068
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 11:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715946170; cv=none; b=g0DU9Hx44fvPKErzMa2u/t4D81SLj+kPx9wFaTqGj7Ttx0Xy0p0feMX+hsV16SnhL3QW3M9KGbiaiFoVw1pISmBXNtjvywuSAi6MhMnsRpspUWFm9UAtwiytEZDLXwUYIMzjzJXS7vfvXgWtPNd+UQCWYvlDq63ZHepM/VQS4s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715946170; c=relaxed/simple;
	bh=me+VbK0kerW4Pm2UaHvkg/9iGjimMkVTO/pPu03lKQ0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kyjSBtQXoR5e8uI9CxGpsvLikU2RS4n+KxuXMZtZM49rhBUqDHdfd+5q7Eaq6NdHukSJWrdiHLDfOnBW9mUalMVV1FlcTaypatG8vcU1dx06xZatx9kZ5Qv9N/UMo8Bi4cV5XxfvM7k3yD4OOlZDOc8zK0f52+C+JB5l8D+hAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgWbZkKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgWbZkKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05DDC2BD10
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715946170;
	bh=me+VbK0kerW4Pm2UaHvkg/9iGjimMkVTO/pPu03lKQ0=;
	h=Date:From:To:Subject:From;
	b=kgWbZkKZUIkJ+vdkjyaG98vIjZ77ZD/C/GnNVFCqiQg5UdJqHkLPRLxhaNXaVhGRS
	 hU0rZdjQMbhyk+Ph6A/+n5ZNsRwMls5XS6+J67mExGfytH3ooCnYENm5OQoODx4k6l
	 6ZasWk0owGRpI+Z+ES2Vjh/1k2i6eWizGBk6mPLKfY7gCYYJUvgV1YpE8To5+DapWw
	 cSMxQ39oE6yKV5PYjajSfduVYaqMlqyoZTtRhPtqCdkdcxNVRfICy3xudShqAnV/Ty
	 Jxi7Pbqsr7HEQjMoLICSSGnBfRmKXZIENQKQWS/QuSK1GEoe0kzkHmIn6+l6d5/ADZ
	 9EWWxvHa2o/AA==
Date: Fri, 17 May 2024 13:42:46 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs v6.8.0 released
Message-ID: <qhwd5uy7lmaxuc74vxaqwu2h7n2xvtsq4exr5btbmciqkrwsfd@zbqoopx6pday>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

df4bd2d27189a98711fd35965c18bee25a25a9ea

Carlos
