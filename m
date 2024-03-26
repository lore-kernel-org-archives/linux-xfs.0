Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE90128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422038; cv=none; b=SgaPsrM7/Dy3D2QyZS8Ydbm8/I6sBRVuvDEe3YnpZv+PTuKGbRFv+19mvGfaDxXLCxo+t2vGXuLSSWLsTWZhuEsdqtznh5pVJhCbKHKJfRGx08phALEUQJ3YELor3JVsBBlcO9Sv5BABi36pVTH4ONoA7UdZNMNUaCn3fbV1MV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422038; c=relaxed/simple;
	bh=ldo5DKUegUMZNGS8BgRgdrLDoUsxaG8M0QQI3EIAX7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwKj86Uj/kOD5n1nzoRGydFfwvWs8V+6EtRqcsLJP/doB18RzCeucRG0edTiOUWSaJ++NbGqa6tvoZK4ZdpmjJY4BSqofhdCK8CqrupCTP0BBOyxqGdN8MOmfWnlLFmF5n+fgwvE5t4GKwEVIkGHpkUcbjXK4nyJiLogucsE5LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8Fm3ArA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8Fm3ArA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A41CC43390;
	Tue, 26 Mar 2024 03:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422038;
	bh=ldo5DKUegUMZNGS8BgRgdrLDoUsxaG8M0QQI3EIAX7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c8Fm3ArAKhYMrDd8ONR9l2N0f/7lVcPEvl+xTDrjTFbDmwMU1QNf5gQkq2czvW9nX
	 RZp/wGWS+L+8JSQEZAydNvX8iaC2K0K0nQXSZU+0R9yleZyHEYQXsYRxk8TwU295JA
	 XOQ9r7DoiZswzw53aQGuVT5vtwhNiZWoGceuUDWE/1YizlOYhEimjvBQXH8u3TAIUf
	 FnSWo/w1lnYMBkOYPSyUw2itik3XlEqQphtgxRZNrehREXWtkiPUklANN6/a8YCA9L
	 sRR6c9hPkAOJKdysnYURepJ7aQkmhQC/rj2V5Vc4qxmSA0xp7HSVfh/rhwUGb1HkvF
	 /Q1UzD2mKzGXg==
Date: Mon, 25 Mar 2024 20:00:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET V2 05/18] xfsprogs: fix log sector size detection
Message-ID: <20240326030037.GG6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
 <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>

On Mon, Mar 25, 2024 at 07:56:02PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> From Christoph Hellwig,
> 
> this series cleans up the libxfs toplogy code and then fixes detection
> of the log sector size in mkfs.xfs, so that it doesn't create smaller
> than possible log sectors by default on > 512 byte sector size devices.
> 
> Note that this doesn't cleanup the types of the topology members, as
> that creeps all the way into platform_findsize.  Which has a lot more
> cruft that should be dealth with and is worth it's own series.

Oops, heh, in all the rebasing confusion I forgot to update this cover
letter in my database.  This is actually the V3 patchset, though I
couldn't tell any difference between V2 and V3..

--D

> Changes since v1:
>  - fix a spelling mistake
>  - add a few more cleanups
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fix-log-sector-size
> ---
> Commits in this patchset:
>  * libxfs: remove the unused fs_topology_t typedef
>  * libxfs: refactor the fs_topology structure
>  * libxfs: remove the S_ISREG check from blkid_get_topology
>  * libxfs: also query log device topology in get_topology
>  * mkfs: use a sensible log sector size default
> ---
>  libxfs/topology.c |  109 ++++++++++++++++++++++++++---------------------------
>  libxfs/topology.h |   19 ++++++---
>  mkfs/xfs_mkfs.c   |   71 ++++++++++++++++-------------------
>  repair/sb.c       |    2 -
>  4 files changed, 100 insertions(+), 101 deletions(-)
> 
> 
