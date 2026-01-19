Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D6736C0C5
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832850; cv=none; b=ETaQlXX3pAELoPIbgwWGILzFwNJPyXhcM0stl8YcUfPAD5sOla24h6GUpMT6X4VzQIXvoGZoCAbFUYYFeCcKO9AeDWiMwa/RzZ4rlvLt5c1e91YdP54D8xwfrKSqib1kkx66PhkY7OipIbRnCcWrKoXm+4gMvN0p0OgsJMovkbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832850; c=relaxed/simple;
	bh=HwF6irlhnoNclOboymalE90Gz8nR3o47TBOuntE9Qq8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fHAgxnNd9oh/y5Erc3lgA+Mj2CHGA8jYpHEFUr2evj2N0nzpfs5fNX4NyV/GpB/r9h9OuIWlV8nxFQY+rDsshEEDuDe+px0g9JdhJz9NqvuNQccp3By3IK2EiMQto7/zTSW3zoiWRXgUa/n0JP6V2yrEnIrah39qDxl6Zs94+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fobFkDFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fobFkDFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC8BC116C6;
	Mon, 19 Jan 2026 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832850;
	bh=HwF6irlhnoNclOboymalE90Gz8nR3o47TBOuntE9Qq8=;
	h=From:To:Cc:Subject:Date:From;
	b=fobFkDFZxfpkDctfqRSs0k8e/9NU/Y9PrdT5J8LmfhKqI+gpT2LElH0NqnLYEM+kY
	 QrKwX5e/3qzmiJYMf7YcFRFbCnYeBGTNlfED7XxY4UKig8hbs7lZr4+mc/iPdBOBqj
	 /3AY6v3brv0mvzFvK0FqstPXMjDSS2SMUqTwS4RMEqL6J4watiRzw8o16L4v7jkwep
	 QKoZLwDb4SgPwZM7S0nEffvYWxJjJl1UggteZtwXU2HSBcGWYzVbWDhNGL90aMxWI5
	 Az4EsW2JMNNtDKGOc0yvSrFrI8VAUsFk85mJvM3i6YUZPPt+V5mRBypOXG4bJeIFef
	 e71KBgTT5Gfgw==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 0/2] Improve user experience with xfs_fsr
Date: Mon, 19 Jan 2026 15:26:49 +0100
Message-ID: <20260119142724.284933-1-cem@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Those are a couple patches referring to a user report in IRC. I didn't
properly test them yet, reason why RFC tag is added, also, I'm
interested on others POV on these changes

Carlos Maiolino (2):
  libfrog: make xfrog_defragrange return a positive valued
  fsr: Always print error messages from xfrog_defragrange()

 fsr/xfs_fsr.c           | 10 +++-------
 libfrog/file_exchange.c |  4 ++--
 2 files changed, 5 insertions(+), 9 deletions(-)

-- 
2.52.0

