Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21A43159A
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiW94se1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC8C433C8;
	Mon,  4 Dec 2023 20:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701720136;
	bh=zdHgPOf/9doTVqLjT+klgyjK2pbNkiR4EEDrO+oDSv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hiW94se1MOb8BT71IcO/6B/j/Dzsv+1i05GNVqiHatUArVDNDjoEUjRWajbNrcITw
	 7BjAwhfVpgyYn46gKvXw7GODgRKRGYaTL3AMg/C3/uLGGzE5P9ETHbg0A0ueEmr+xe
	 7GgoYNloAxC+UU9scQRheff2/Tt47wnibhgyQ/5xSZqGHiMDDRDsT5+EZM5ezSDMj5
	 bN1f2iE7cYyQBFQnMKGlSmdxrnGFK2sODAqUtiOdnjyCq9VxKF72QUVfvyj8kPOJX5
	 sWpCuNIKU04ThC3uLbx0askkqxkEfk71tsbL9yudcQeenRX+LZUrk3ss58NCzwSTq5
	 JZzTwsCR5rAxg==
Date: Mon, 4 Dec 2023 12:02:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: collapse the ->create_done functions
Message-ID: <20231204200215.GD361584@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
 <170162990294.3037772.8654512217801085122.stgit@frogsfrogsfrogs>
 <20231204052403.GD26448@lst.de>
 <20231204185131.GZ361584@frogsfrogsfrogs>
 <20231204194626.GB17769@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204194626.GB17769@lst.de>

On Mon, Dec 04, 2023 at 08:46:26PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 04, 2023 at 10:51:31AM -0800, Darrick J. Wong wrote:
> > > always ->dfp_intent and I don't think that can be NULL.  No other
> > > implementation of ->create_done checks for it either.
> > 
> > If xfs_attr_create_intent returns NULL, then xfs_attr_create_done won't
> > create a done item either.  xfs_defer_finish_one will walk through the
> > state machine as always, but the operation won't be restarted by
> > recovery since the higher level operation state was not recorded in the
> > log.
> 
> So - why do we even call into ->create_done when  ->dfp_intent is
> NULL?

Good point, it's not necessary.  I'll throw on another patch to elide
the ->create_done call if !dfp->dfp_intent and remove the null argument
check from xfs_attr_update_create_done.

--D
