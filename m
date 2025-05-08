Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1268E279330;
	Thu,  8 May 2025 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746715659; cv=none; b=t/kb3rvqaMMS/vNgphFE7nCjmmKnbxel7b90PWXF+I4fjFMFFa7PtIO5LQGwlT08NrmhMoLM1cj5zGgSxyZ1Ot7hdWj4TUSxSk12zZsX2IS8i9TVOhAP8AaXFzIXWWWUeJLhVIlER3UwaWL5RveSAit93VGm1N5ERt0Sn8+s/Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746715659; c=relaxed/simple;
	bh=2fHnOfv3sUG9E2WcocPQ98+8dRURRo9/vIj7UUS9FV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMEIImtUF8Uxr6lCMNYeXgZ+bcGdadcJDNuJTVq4g0/Ni7wrWsNghLDx0QQi9d2K2r0ZTqDeedyCNkRCedBZi7yJ/vLHAJW1M4fxyz169k6EX6RBdcCv1TOSmezWszYOLToU3rUhx577HjNzQMm0DQWHsDjBc61xLuaWEJUFqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rQjhFns3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rQjhFns3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B737C4CEE7;
	Thu,  8 May 2025 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746715658;
	bh=2fHnOfv3sUG9E2WcocPQ98+8dRURRo9/vIj7UUS9FV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rQjhFns3BXl8zBOnabHKqwI3u+yqkvq4RgL27ZHVOwqLQBO1SFBvjGsrNlJ+wYZYk
	 +LVUuxLNnJJ/BxiR85P1TXrm9xK5ivA79m9SjuyHPVWgPeNKL13yS6kR/OURB6ZGbs
	 h9VBtgfyYZN3QXYp0mQHHxc7I5P4JjzDOQiLroML7gu0QNg7oIyjzd9un6moBouYOU
	 itKhznTqr93IpR5OKhoJuZif6YaZfdVpxGqFl8q3CGse3X7K2/SGJYY/wSzWef/EO4
	 WhJbMCTe2edy6IeEQGfyKGSxaO2uaYJ86fUnCBV/0ObxKw6e+TjilA4PhpCTh4KNoA
	 0CpURYMtddcFg==
Date: Thu, 8 May 2025 07:47:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fsstress: fix attr_set naming
Message-ID: <20250508144737.GA2701446@frogsfrogsfrogs>
References: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
 <174665480825.2706436.15433477670941336936.stgit@frogsfrogsfrogs>
 <aBwwykf7xaGXHnVD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBwwykf7xaGXHnVD@infradead.org>

On Wed, May 07, 2025 at 09:19:22PM -0700, Christoph Hellwig wrote:
> On Wed, May 07, 2025 at 02:54:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Back in 2020 I converted attr_set to lsetxattr, but neglected to notice
> > that the attr name now has to have the prefix "user." which attr_set
> > used to append for us.  Unfortunately nobody runs fsstress in verbose
> > mode so I didn't notice until now, and even then only because fuse2fs
> > stupidly accepts any name, even if that corrupts the filesystem.
> 
> Looks good
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I wonde if this creates a fallout somewhere else now that we actually
> do xattr ops that don't fail..

Yes, generic/753 now fails when xfs_repair complains about INCOMPLETE
xattrs and blows out the entire attr fork.  I tried the stupid fix of
downgrading the warning to leave the incomplete attr behind, but then
incomplete remote attr entries have a valueblk==0 and later I saw
corruption of block 0 of the attr fork with the remote block magic so
clearly something else is wrong there too.

--D
