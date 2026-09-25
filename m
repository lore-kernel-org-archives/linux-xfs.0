Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C04F0533
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376757; cv=none; b=JasvpOxXwTXkqqEO8t2sw2I6TLbu102oWhEAkMc7dIZSPoafxQ+H582v5NmKKofs6cQlTdz5Y1Y7e5/Kv8M1e5rFj1ROgYkFJLmwxLoFyCH2HTY9kJ9Neebos8CBJY3809g1gPAOO/hUXuLoolzM7iyP2RizRFq1wn6Wj2KCimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376757; c=relaxed/simple;
	bh=2f2u3iv0c8xM3ZJDWltel/AlGTXprZ5c+TlR/Ekfyl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kV1VrEo5t/d4Svujjk4Ee56YXwcgfYPuxHKiH/l77cKOzc2NEUaOXo46M1M6UFKF0e6qJNuvQx7a4GdeS6w8GRJWg1Mm2TC83aZY3PnsXKsS7M9rSoK7fSi94zSb01vHVPW53sCGaCGyqolkGrDgoqrkcQtDMBT+LsV8u5SK0xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h34fhzBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h34fhzBU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1C0441F000FF;
	Fri, 25 Sep 2026 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376754;
	bh=3eveiN94YpB6j/zeTvZlru8Ng6S+h4NwKHDQEW3ZoX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h34fhzBUB+X/qNlSpJ2hbs2ccqoq2JKj+AkYxcbbBzEXnDEopfds+5XDu5e0QqLVj
	 r2DUIioo8Ti2isuJJ5qi2Vx9hZ1OAjy4nIQ6HWa7XQnp8yXYWh7x9587NbZVPszBER
	 5DDPb1eHVe0/bjgUdAlaijfrkfjyHlfnb5IlZ/lb9j504/c0TsJ7Nfp/qsHQjJCYep
	 KhdxuBvVh2Tyu3DrDNoddLE1vBoZmH3CtwD65AkTaYYdk37e75/QCiFaGBi8PQ+zky
	 VYiTc7AddMnLhWNIIcGBeYwXR/cEhYnAyX/RAxMVa8Q4Uh3W8qWxPiO3y1YrGuOamj
	 jLmAcljZPIykg==
Date: Fri, 25 Sep 2026 15:52:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: small cleanups to help code sharing with xfsprogs
Message-ID: <20260925225233.GZ2705364@frogsfrogsfrogs>
References: <20260925151841.3385994-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925151841.3385994-1-hch@lst.de>

On Fri, Sep 25, 2026 at 05:18:25PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series has a few trivial cleanups and code moves that help
> sharing more code with xfsprogs.

Hrmm.  This is a somewhat different approach than what Chris Wedgwood
did for his log port to userspace.  What do the maintainers think?  I'll
defer to them as to whether pushing some of the log code into
fs/xfs/libxfs is better than pushing all the log code to fs/xfs/libxlog.

The code changes look ok, so for the whole series,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Diffstat:
>  libxfs/xfs_attr_item.h     |    2 --
>  libxfs/xfs_bmap_item.h     |    2 --
>  libxfs/xfs_buf_item.h      |    2 --
>  libxfs/xfs_defer.c         |    1 -
>  libxfs/xfs_exchmaps_item.h |    2 --
>  libxfs/xfs_extfree_item.h  |    2 --
>  libxfs/xfs_inode_buf.c     |    3 ---
>  libxfs/xfs_inode_item.h    |    2 --
>  libxfs/xfs_inode_util.c    |    1 -
>  libxfs/xfs_refcount.c      |    1 -
>  libxfs/xfs_refcount_item.h |    2 --
>  libxfs/xfs_rmap_item.h     |    2 --
>  libxfs/xfs_rtbitmap.c      |    1 -
>  libxfs/xfs_rtgroup.c       |    1 -
>  libxfs/xfs_sb.c            |    1 -
>  libxfs/xfs_trans.h         |    2 --
>  libxfs/xfs_trans_inode.c   |    2 --
>  xfs_platform.h             |    1 +
>  18 files changed, 1 insertion(+), 29 deletions(-)
> 
