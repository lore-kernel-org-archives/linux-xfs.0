Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2576149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850520; cv=none; b=TWgsv7YHr4havPxvXO8L8LLPQOsnAtL4h1xSJCW3C5hfpCt/Yqs2QqOAGFQZr27HRXUdiRrwvLlEhyC6LNCqPqL9w5VwDssre4fOXOWIbPL5VJrfTD9ruPAi5/r6NIirf8eUOls5tG/lov3xk6tlEHIHQcGT9yp63EPomVJnEek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850520; c=relaxed/simple;
	bh=jiUH0dtxVL0ixayvzcomDPmZnn6czFXjXeDTvjn6Vkc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GA/xX75Zx0PvfcmCBlB0nZb2tnTuCP/5jB5wNjHAuxwOnlO5B8qBAecfFRKGJhmBtI5Ed4GjdCWcNM0bXy7teTfD+mMhyoBtFb9Ow7sCLsMWYovKNxl+Ms1huXd75IdApKybig2j4B4TdmUFFUAbdsI6Bt6x30jOCREXxTerJa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/guLsvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/guLsvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A888C4CECF;
	Tue,  5 Nov 2024 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850520;
	bh=jiUH0dtxVL0ixayvzcomDPmZnn6czFXjXeDTvjn6Vkc=;
	h=Date:From:To:Cc:Subject:From;
	b=Q/guLsvF5w0vRtvbP7tjY3J6JJ8eEmn499VmpYxdyHlvJ61FkH5Grtw1UQnjjMPZH
	 bX3fEMTFIqHnQuidaZqQa1TUMy+kfB7mIgKlls1uxloKv9umfImV5gJ9bKWyLH7dSH
	 vRwyIcLXRA4RX/LGHzhKZIy243UKeYeXEMyHASza5An26q75+zqAqd1BuCJJN9N9f4
	 nNkeL2kYMeR4xNIxm+F8xqGbfbURGHY166XIiRgY4iIweakJEkoud2cF1hrykY14px
	 akRanPzucHdA8k8NUyupCIFH8mfY1eR7rJT7YfTfkPyI4aCH5TvXXw3uO4QGIkeKjd
	 9J8tZZ5dcPzXQ==
Date: Tue, 5 Nov 2024 15:48:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULLBOMB v5.5] xfs: metadata directories and realtime groups
Message-ID: <20241105234839.GL2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Please pull these fully reviewed patchsets for kernel 6.13.

--D
