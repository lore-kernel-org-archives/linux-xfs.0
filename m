Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E94171C9
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543595; cv=none; b=L0l81rSPTnSvcakS6Wyg98G8T1yHvM+gM/QxNS8rj9M0iITHBhZ+C/XGSlu3ynZH3EpGwpUZl35iheuAobEJrRobdl6YQkPlFoIH/Lo3v/ML00rI0E4dQQ6FUWo/RkoRQUGxyp9Gl54zgpESHIChm74iOxKer2ZB7hLBaIvJOf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543595; c=relaxed/simple;
	bh=5pX27+MLvHJoB7+IDcJ8wJ+0x5/Th0STWJPEQn8scqk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=FrSFUguU6psGJ3faVvMEmI9UpX1gY3OIqgynq/TeXOX8WiwVspfPWwtVjIrGjCB0kr0H6wURp9/EKVUm0tIMyTDWp2fdGkraQLq3wXPwZloodFclzYKbKfYkblrm7hO76TFJipJXZoEA9nU8m9cSX18bUL5xUhkHt3EqEIj7dV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsM9HumW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsM9HumW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AA8C4CEC3;
	Thu, 14 Nov 2024 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543594;
	bh=5pX27+MLvHJoB7+IDcJ8wJ+0x5/Th0STWJPEQn8scqk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RsM9HumWv9nrUzoqpbesk66GV7Spf+xrphb+Awvm/8qiBieCKKX+IkZa32hA52ahe
	 Q0/Blf7c77t8IR53ARdpMTuL6oCpA+ySRClfIIj6Cc1T4J/y1/S32ej9LuUdf16lFh
	 /793peZS99QdLM1J+hasTS4cSfYGNQj++awfyEDjt7iuH33EqHqzBHDwxTov9GRcJl
	 5+V8uWlzv4mz7OhWuOB/s3pYfhrjf8tW9v7i7oN2cFI497KCcP0I5OVObjbY96SeaU
	 +cu08ZUlICPpW7dMQJ9CU9EMXe4cRJIO4jrGIsUUdanm0fRx6mX9FR8T8R7QAaYaKh
	 3tB/J3mjElx6w==
Date: Wed, 13 Nov 2024 16:19:54 -0800
Subject: [GIT PULL 09/10] xfs: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173154342678.1140548.5437419680492101461.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 72eae9ba15798bdea27ebd975323a32c3319827a:

xfs: enable realtime quota again (2024-11-13 16:05:39 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-6.13_2024-11-13

for you to fetch changes up to aca759a9b1afc6693cfaaafcad7546298423fd20:

xfs: enable metadata directory feature (2024-11-13 16:05:40 -0800)

----------------------------------------------------------------
xfs: enable metadir [v5.6 09/10]

Actually enable this very large feature, which adds metadata directory
trees, allocation groups on the realtime volume, persistent quota
options, and quota for realtime files.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: update sb field checks when metadir is turned on
xfs: enable metadata directory feature

fs/xfs/libxfs/xfs_format.h |  3 ++-
fs/xfs/scrub/agheader.c    | 36 ++++++++++++++++++++++++------------
2 files changed, 26 insertions(+), 13 deletions(-)

