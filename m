Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58371110D;
	Fri, 12 Jan 2024 02:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loKwBQSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BDEC433F1;
	Fri, 12 Jan 2024 02:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705025870;
	bh=IJpQ+UjGu1OhqKACahiwzxPcIjUS+3FVmGVfG+NUhkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=loKwBQSLsIf5AcKdDeBPeQonMBZ03MuzdSeJgubC5N6SmjSU29c50KPZ+x6hvaTiJ
	 PdjhUIYUYuLcnWXG3jqTRSUOgPXUoxsT/phJP6XW6UTvVaB8JDznRVy3tAZQ9YLCDF
	 A0tc+T+f8/dqgOcOzcQANf0XM9+i4HnzVGExVfkkEOMFr7b0vQQT9VFS66Pk8YUPPK
	 NsXGlz2wl9fM7L99xHErwqahSysdMM/1t+gQXCXjcB6BM0vvAu+uL/DHEWZ6g2uRD7
	 fIoUhgiF1lvbvrncd9RXlwcrqSeqqhA4dFsHVurCk5QB5kbAhPR2cCXGNhONW6Eep4
	 aSUo83X2/FTcA==
Date: Thu, 11 Jan 2024 18:17:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240112021749.GN722975@frogsfrogsfrogs>
References: <20240111142407.2163578-1-hch@lst.de>
 <20240111142407.2163578-2-hch@lst.de>
 <20240111172022.GO723010@frogsfrogsfrogs>
 <20240111172556.GB22255@lst.de>
 <20240111211702.baimcixgpuhoqbib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111211702.baimcixgpuhoqbib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Jan 12, 2024 at 05:17:02AM +0800, Zorro Lang wrote:
> On Thu, Jan 11, 2024 at 06:25:56PM +0100, Christoph Hellwig wrote:
> > On Thu, Jan 11, 2024 at 09:20:22AM -0800, Darrick J. Wong wrote:
> > > > +	mountpoint $mountpoint >/dev/null || echo "$mountpoint is not mounted"
> > > 
> > > The helper needs to return nonzero on failure, e.g.
> > > 
> > > 	if ! mountpoint -q $mountpoint; then
> > > 		echo "$mountpoint is not mounted"
> > > 		return 1
> > > 	fi
> > 
> > No, it doesn't..  I actually did exactly that first, but that causes the
> > test to be _notrun instead of reporting the error and thus telling the
> > author that they usage of this helper is wrong.
> 
> So below "usage" message won't be gotten either, if a _notrun be called
> after this helper return 1 .
> 
>         if [ -z "$device" ] || [ -z "$mountpoint" ]; then
>                 echo "Usage: _supports_xfs_scrub mountpoint device"
>                 return 1
>         fi
> 
> If there's not _notrun after that, the message will be gotten I think.
> So I think the "return 1" makes sense.
> 
> What do both of you think ?

_fail "\$mountpoint must be mounted to use _require_scratch_xfs_scrub" ?

--D

> Thanks,
> Zorro
> 
> > 
> 
> 
