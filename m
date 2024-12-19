Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89513199234;
	Thu, 19 Dec 2024 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630840; cv=none; b=WrBSd2/HSNXoi1k1oFnVaMLoVsHa/fGEd/pDDBZEIr4bscXzuBtBImdh9KESLuuZCZjf3K8jOu4xqUs8F0rjXU+CAbHKFg3+xwmUPyiV5dW1vIn3Yl0iQxDNMZwgA7XRuoTml7DoNHsu/SjUUXQuQGWXPUUC4Wdy/6c9A8GekiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630840; c=relaxed/simple;
	bh=5PllTn66jE9EUpVRkABsP/ebTMQprDzt0y/1GoA2J8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEPeaaZOCKsiyQBOpwxXcoLtnYuktl0NwjfnCMcplclsh/15wtPzJhf7fd9lHrzrCaTL/m4R5rgil8GxL5q5wUros12U88ItveXsXd2EGfu/DGw5G2l5YyzjkDd4JO377++C4v8gYg5Xc6EYZKliX7Mc2SsZzpEpoN+kG7dEF2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj/2o1Nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj/2o1Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F79C4CECE;
	Thu, 19 Dec 2024 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734630840;
	bh=5PllTn66jE9EUpVRkABsP/ebTMQprDzt0y/1GoA2J8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bj/2o1Nh+uTXmAgx46vuJ5hgzYeD5BMNLX4tF3awVVjCrJIOqByLe4s6P/lMiUu3/
	 2yC9VZkdO77KAX7qX0evr7TaQv+hvfIJvcaycvwx7Z8y51BYks04+dGnUx0CYUbT6H
	 10Dg/wzvOrHDNqqPlI3qjoKoas2mxjbqhqLiUswBX73FE2hgo9iVmrgnh+JUBECgAi
	 vNKu4hIRBUrg04m7N0R67JpL0Glpa396xr3mfQhW8KvUYEN8hIePXMmp/NmVd0mfmK
	 Dz+EJjtCKQMcwIZqhvW5gXrnatbtOaoLefbbBq2QNaCOsNh7sX9n/WAvJ+9d4klwvN
	 OmPAAdwaPoGAA==
Date: Thu, 19 Dec 2024 09:53:58 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hare@suse.de, willy@infradead.org, dave@stgolabs.net,
	david@fromorbit.com, djwong@kernel.org, kbusch@kernel.org,
	john.g.garry@oracle.com, ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, p.raghav@samsung.com, da.gomez@samsung.com,
	kernel@pankajraghav.com
Subject: Re: [PATCH 0/5] fs/buffer: strack reduction on async read
Message-ID: <Z2RdtqACTIRoACfY@bombadil.infradead.org>
References: <20241218022626.3668119-1-mcgrof@kernel.org>
 <20241219062827.GA19904@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219062827.GA19904@lst.de>

On Thu, Dec 19, 2024 at 07:28:27AM +0100, Christoph Hellwig wrote:
> What is this strack that gets reduced here?

s/strack/stack

I seriously need a spell checker as part of my pipeline.

  Luis
