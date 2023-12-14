Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7658663DE0
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzMMealh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F7BC433C9;
	Thu, 14 Dec 2023 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702573676;
	bh=WQ6b/bKi9d8qCOoZ2v1XPTgIsuMbX2Ck7Xg+k2ep4Ww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GzMMealhHaBn2bg6/1HaQfRqtc2PJu6PW8JQUlr4uf2ef5Yz+ZAiJu6byjc0ZlT0C
	 oiqrG4u45rt2llGBaKmj3Xig+M4+4vghaRn60Fr67dJ4vTBNikKT+8LXdZEH1Lo1yH
	 rSzSze2D7/83ZONv+1JWAmb0h8KFTxcZNQLs4qigVev07h1/3eeg1IddQKaqeUocM7
	 mCeWACH65sb8RyhD+ZRXhPHX2ByQZqZUpfKGdk91G7+Eostzo+FlgCyJm9rV/9u5JC
	 GriMgANz/s4ESJylMmm6Inh8KiyqQqHxIPH6H1EURwi1enLHGU+Rtjht2lrDuJLvA6
	 wk34ZlYsnNnYw==
Date: Thu, 14 Dec 2023 09:07:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "wuyifeng (C)" <wuyifeng10@huawei.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	louhongxiang@huawei.com
Subject: Re: [PATCH] xfs_grow: Remove xflag and iflag to reduce redundant
 temporary variables.
Message-ID: <20231214170755.GM361584@frogsfrogsfrogs>
References: <b2d069d4-b96a-443c-ad7e-5761b8f10f88@huawei.com>
 <ZXqL94xSn/bG6vgj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXqL94xSn/bG6vgj@infradead.org>

On Wed, Dec 13, 2023 at 09:00:39PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 14, 2023 at 10:41:34AM +0800, wuyifeng (C) wrote:
> > Both xflag and iflag are log flags. We can use the bits of lflag to
> > indicate all log flags, which is a small code reconstruction.
> 
> I don't really see much of an upside here.  This now requires me to
> go out of the function to figure out what the flags means, and it adds
> overly long lines making reading the code harder.

Also, lflags is a bitset, so what does (LOG_EXT2INT|LOG_INT2EXT) mean?

--D
