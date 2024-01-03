Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D704A14
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 02:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUqUjJ9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F3BC433C7;
	Wed,  3 Jan 2024 02:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704250320;
	bh=gCFAFm/0XvOSzXM4q+kuTngf51iukrYp7pyjnIlHyUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eUqUjJ9CP4sJr3yX5bFe14ffsqRA1SUkKwew5LqnekN5d6etWNgJfgIF+59a7Xi5Y
	 oDAxrCIbPkybXKSkNnrN2KUVMYEsRAf6lvzdXS5KVdK9QtpCIVvDrHAHf0iem56q3Q
	 bXt6Q5qdFFM/uDeRsyO5Ay0hAp4Q/qgx04OmQicW75WlQNxd4fHszOddT2c7q54o0i
	 fyE+AKW7uC+cGp/2WLXjnCOq0R9QgMUehqPveewrsOFgCXdMsG8K+V20t+XDNc8kY+
	 kBrcucAKFLrZCca/EcLjghBrtc2f7bIc+r4xciEWA6wy5VbnTpdxBbaqGvclYDGkpt
	 BzjwrQYrniRjA==
Date: Tue, 2 Jan 2024 18:51:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
Message-ID: <20240103025159.GN361584@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830659.1749286.12453760879570391978.stgit@frogsfrogsfrogs>
 <ZZPn5Y7NNjSkko2g@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPn5Y7NNjSkko2g@infradead.org>

On Tue, Jan 02, 2024 at 02:39:33AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:19:17PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Remove these fields now that we get all the info we need from the btree
> > ops.
> 
> It would be great if this series could just be moved forwared to before
> adding xfbtree_config so that it wouldn't need adding in the first
> place?

I can look into that, but jumping this series ahead by 15 patches might
be a lot of work.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
