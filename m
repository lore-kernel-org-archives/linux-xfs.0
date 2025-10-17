Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB2728468B;
	Fri, 17 Oct 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760718140; cv=none; b=sDuu0w+qxa7Vuka86r8jCkYLqlvwjyHfzpGyRjaZv7xcaByef2bfrCMOC2Xg54RDa5MAbPUmwv//iqXWWPMNCPjohhD7kBH3Uqo1ZtQY8VKDM+WCyyAQovZD3/AfagXCS4iNd2d2gUh0qrz0+1JNNwdwgewbQyIMDrHtyxGzREk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760718140; c=relaxed/simple;
	bh=bQhLW/riHDZimIDJUSSSfdUzjRBXlAXvqHDmFErXHfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRQEIirIvUmQMgTjY5suo6ObW+5XLPxbv1C1nlB2Sr4R1Snd+jiU8ep7r/FLvyzXnhx1wxfBn7SzRH1TIqGItUW0meV8mtlRHYzejq7Js/bsAPCC1J5BbE+o+jqj65JSw+w4ujfK7bii4YkNB7Y5XVwheXAKhPPXVQARPgdPwuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kN/xMX3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kN/xMX3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F01AC4CEE7;
	Fri, 17 Oct 2025 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760718139;
	bh=bQhLW/riHDZimIDJUSSSfdUzjRBXlAXvqHDmFErXHfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kN/xMX3EoA5SPUBs6+cn1fkOt41XuCZWtMaUXY4JRtcOmJOI+zaVhD1MUTNAt9Zkr
	 3bcIa9kb4N/v5/f7Wbc8YLPr+Z2BGjhsKbC/EDMgCCx6Juz6gui9320fmma01FZb13
	 xcyhQg2C92mlJrYRW8nrCRngoC3bXh4Pl7DPtPNR0MV8rZFC6CrwUr+UxRCxGFmpSx
	 9XK3d7INH0y7b4vWvoq8iKUu+6UbQ7tbm0XT/ehN2S+FrFmSALUrWR4rTSCd9Y9RIe
	 FJX+HCNawSWiyAhoIT5tAvYCcM5ZA6B03iO7W5HB4rzYYXB8tNf+5UF5YP/1j70t5F
	 TchT1V7uyyo2g==
Date: Fri, 17 Oct 2025 09:22:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] common/filter: fix _filter_file_attributes to handle
 xfs file flags
Message-ID: <20251017162218.GD6178@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618007.2391029.16547003793604851342.stgit@frogsfrogsfrogs>
 <aPHE0N8JX4H8eEo6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPHE0N8JX4H8eEo6@infradead.org>

On Thu, Oct 16, 2025 at 09:23:44PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 15, 2025 at 09:38:16AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, _filter_file_attributes can only filter ext4 lsattr flags.
> > Update it to handle XFS lsattr flags as well.
> 
> What XFS flags end up in lsattr?

Assuming you're asking which XFS flags are reported by ext4 lsattr...

append, noatime, nodump, immutable, projinherit, fsdax

Unless you meant src/file_attr.c?  In which case theyr'e

> Is this coordinated with the official
> registry in ext4?

Only informally by Ted and I talking on Thursdays.

The problem here is that _filter_file_attributes ... probably ought to
say which domain (ext4 lsattr or xfs_io lsattr) it's actually filtering.

Right now the only users of this helper are using it to filter
src/file_attr.c output (aka xfs_io lsattr) so I think I should change
the patch to document that.

--D
