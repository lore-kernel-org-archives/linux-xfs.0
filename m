Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52DF7762B
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcmO4yL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62321C433C7;
	Fri, 12 Jan 2024 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705078448;
	bh=jA4zK2X+iVLOD01N8H6s4N2LONcgSR5Zxc2qtl0tbaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tcmO4yL5ym/LeSwBubOQnyiXTJZO66MreqMlZ4rEEiEFgKMufOcrHjSA7hZGZVEm/
	 uLmDIsRCQZqua8M6IDKJrgO19b4jQ8W+3R5YzE6YPzMhChXxjy9QqEzV5gIvKuNLAW
	 fftgVL3rsjZFiUfba9N38Q7hR16mN2EW6S47XLhqTUXCFJqztj5xbPg/wz+c5nIp+m
	 lcXPaxyWSRBjvUV/BKARGzLF9ol1rR7+CRp+EvK3h4gBZq9c/LrWIxJKb7yR28sMA0
	 iDkBEyR8aycc4wERBM2xPbqR7cGCYQmVhgtaXu02wE4avfH3/aqh1OL6JLyns+BMbZ
	 kUA1w0NhS/Pkg==
Date: Fri, 12 Jan 2024 08:54:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: remove the unused fs_topology_t typedef
Message-ID: <20240112165407.GY722975@frogsfrogsfrogs>
References: <20240112044743.2254211-1-hch@lst.de>
 <20240112044743.2254211-2-hch@lst.de>
 <20240112164450.GU722975@frogsfrogsfrogs>
 <20240112164817.GC16766@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112164817.GC16766@lst.de>

On Fri, Jan 12, 2024 at 05:48:17PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 12, 2024 at 08:44:50AM -0800, Darrick J. Wong wrote:
> > Dumb nit: the ampersand in the comment can go away too ^
> 
> It'll go away in the next patch.

Ahah so it does.  I withdraw the comment, but maintain the RVB.

--D
