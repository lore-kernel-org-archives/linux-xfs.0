Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC3C110B
	for <linux-xfs@vger.kernel.org>; Sat,  6 Jan 2024 01:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdhfjui2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BA0C433C9;
	Sat,  6 Jan 2024 01:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704504797;
	bh=u4PhzZ5jozZV7IPXKjLebedjGtGr+zyQ72Jw8XYCIak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdhfjui2U4fADra2molvj7D3lW3mT6OslXsfa8D0hkGyUYJhb0/5CBDQrA5CFE6YG
	 M5SD2lTiSvk/OmtSmm2rGdVOzMHJZzIK/xDujBlOb/ibS80T4OLo+m9FbSHt9+I8/U
	 KpnYCvG7E/WK9uHJJ0wGpkrTkH3hxUARL511hUq0bU+dRdEHSUzpfckjxu1D6euvRw
	 8dbYXoAWxQoTWbp7j6gPCbcj8jZqOxwneWYyoHeXiGYaEXsU4HUGn5pU7lJPL3+Wyx
	 AfK0r4RMfkUCGyFOm34r79qVDayJh46EcO+lXOnGPMMGoWCP8SWAidsnWclLxXEYwI
	 K/f/7/YjNM+oA==
Date: Fri, 5 Jan 2024 17:33:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <20240106013316.GL361584@frogsfrogsfrogs>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
 <170404835229.1753315.13978723246161515244.stgit@frogsfrogsfrogs>
 <ZZeZXVguVfGz+wyD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZeZXVguVfGz+wyD@infradead.org>

On Thu, Jan 04, 2024 at 09:53:33PM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:35:11PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a simple 'blob array' data structure for storage of arbitrarily
> > sized metadata objects that will be used to reconstruct metadata.  For
> > the intended usage (temporarily storing extended attribute names and
> > values) we only have to support storing objects and retrieving them.
> > Use the xfile abstraction to store the attribute information in memory
> > that can be swapped out.
> 
> Can't this simply be supported by xfiles directly?  Just add a
> xfile_append that writes at i_size and retuns the offset and we're done?

Yeah, xfile could just do an "append and tell me where you wrote it".
That said, i_size_read is less direct than reading a u64 out of a
struct.

Another speedbump with doing that is that eventually xfs_repair ports
the xfblob to userspace to support parent pointers.  For that, a statx
call is much more expensive, so I decided that both implementations
should just have their own private u64 write pointer.

(Unless you want to sponsor a pwrite variant that actually does "append
and tell me where"? ;))

--D
