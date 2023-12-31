Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD7E8F58;
	Sun, 31 Dec 2023 18:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pi4Je4Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B63FC433C8;
	Sun, 31 Dec 2023 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704047003;
	bh=FChMmcfqErVyDEot4zdib0qG4XiU0BkplrLI0oQBRtQ=;
	h=Date:From:To:Cc:Subject:From;
	b=pi4Je4HjU5R70Z+ZKHos4/2TX9VJlDFsBu1XqYTqhR04xAVlA1lpOVyP68Mpsjp/f
	 UCTk6Vl0yQOHReFbEvY7cgprIgy8yudJ4W/xSz6MVIHeSnMZK2mimgFicgkDDVZZbq
	 f0spTosnTy10Zsep+9hzHWRRL8AujLLEaakUwYguF+rwbyKNPtUbUa8uvC7nwRdAwz
	 D5oemIUu3mKDYQHq1rWqKhL/OnK9yXT90d5tZq6TVj8eGs6vnOWMwyW/MO/0hoxbbZ
	 MuckPIvzkgToSVWTtU90KZKD9zC1FTqCwNrO/TE7K1nQN/L0fEUvtR4t7Ug1jnMio3
	 3MYxdJSM1j3zg==
Date: Sun, 31 Dec 2023 10:23:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [NYE PATCHRIVER 3/4] xfs: modernize the realtime volume
Message-ID: <20231231182323.GU361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This third patchriver contains for the realtime modernization project.
There are five main parts to this effort -- adding a metadata directory
tree; sharding the realtime volume into allocation groups to reduce
metadata lock contention; adding reverse mapping; adding reflink; and
adding the one piece needed to make quotas work on realtime.  This
brings the robustness of the realtime volume up to par with the data
volume.

Christoph Hellwig has recently taken an interest in getting this feature
merged to better support zoned storage and garbage collection.  This
river is much smaller than last year's, as we've recently collaborated
to get a bunch of the typedef abuses and casting problems corrected.

In theory this can also be used to support things like pmem and cxl.mem
via multi-volume XFSes where the fs metadata lives on cheap(er) flash
storage so that the pmem can be the exclusive backing of file data on
the rt volume.

--D
