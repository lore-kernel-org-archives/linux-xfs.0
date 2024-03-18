Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83405915E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797962; cv=none; b=q49cxsP95Sqnvdg8P3DljL0DVXQBzuWgN673huZrc/D3CYHafI+2BWDIVz4eL3/dncPadG1WaVOO17FZ5s5MnJ2FWQZEEf2A+O/I8LubQqibti9xSFxN+6dBK2Nzc8vUUBgSTu/v1aHE3lp8hdS8qmumFtK6fgiUP+RAiqbpU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797962; c=relaxed/simple;
	bh=K19ILrB6u/W7zJQNOPZ3WWzoqaoh/APV0EtElHRBpAM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ISZfodn59wYLc+dA458vaD2sQjTh3SS3G/JUlGTe+ReKxxfGFK4T+6YFxUULIm0eoEBRQ97tuP1+fJ2ht2Hhv5yAZMcyvRPO+NFDcYkKGaSMcbugn4qx3h98Nxzff7UTDRikogT9vv0n6X/VeXsrzAos8cP2pgowSll4tV7e6bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbNSsY/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbNSsY/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485A4C433F1;
	Mon, 18 Mar 2024 21:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797962;
	bh=K19ILrB6u/W7zJQNOPZ3WWzoqaoh/APV0EtElHRBpAM=;
	h=Date:From:To:Cc:Subject:From;
	b=cbNSsY/eNHBdkkQokdOVYo6a4sHSJOGCQEUg9x9JXsMcG+43ee3HAxcV+pQMqc9Xr
	 JZ9bFbnknibso2Rx55cvbFV0r3AuweV+XQz8Kza8nfUJEF8ZDn4ZgTcXz9vGCdBBf6
	 Lj94O0AhiBo8E2y1ANZPifCL/ClfNXHuELvEHmdKo7mKfsgmGGQKbLeQ5OwLmXZqRl
	 fgCAOZs9J64EIxDC8vxc4bMBUmLClZAl7HpHPDfs+LSFW4BtviDa9wbbS/Eft7Mmkn
	 gf/6UnIWiPSMgH6rW/PYlZPResIbt389c6CURoedSU5PMuttbECo+Yv3aBHR+v5D76
	 LJO+huNhEvMJg==
Date: Mon, 18 Mar 2024 14:39:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, djwong@kernel.org
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v13] xfs: parent pointers
Message-ID: <20240318213921.GJ6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph asked me to send all the parent pointers patchset to the list
so that we can get a head start on reviewing stuff for 6.10.

After -rc1 comes out I'll rebase my development tree and resend the five
or so un-reviewed patches from the end of online repair part 1.
Depending on how far hch and I get on this stuff, that might make it in
time too.

--D
