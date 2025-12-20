Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622B8156678
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 10:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766227560; cv=none; b=KpLEJ/HZijDAVxpmp/gAbmUEht/XMdPcvlbmjwAixeyZkAyDh4I/FVlKv5QJypv8t+LXStCwNXDuyg4PYWB8VOhmIabrRqwp7LJp3rs2xXXmJE1Dg9vrnN39BDyHoAu2C/EzPCow+pzpuwRh2GHwv6acag1Yj02U9V//C2xPzvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766227560; c=relaxed/simple;
	bh=cxK5o9QKCipYnvMIU+bZYocUFJLgGWgq5A/Ng/vSQXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4iuiNyNWcEALnSoYEyIKhOE7D8FwQOR84xfVadZHzJAp+Eps5EXztFqZw6JbnvHfEmK9Y6xx4GY/Yj3aqgPUj3CjvFzHkl9fSTjseXtO6CB4pacfeSer0GNkTk5p8B0v1XFQp5TcVQRx507e0a67mB1wGsPydbYr5GDvUlNPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQk/CkLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQk/CkLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1440C4CEF5;
	Sat, 20 Dec 2025 10:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766227559;
	bh=cxK5o9QKCipYnvMIU+bZYocUFJLgGWgq5A/Ng/vSQXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JQk/CkLY9yCEWmQvH1ZGICY5L07xp2xrgB0yKhdcetPm1hIRDZ6p4/oYzFPiVYyNq
	 yCNTRsTo770KZcDQTBsGQucqvW/AiiWhRhzueFnmO+wTBTqQKGCa/pHlqamQHxitCj
	 n22clvhBh9PP66/JveMjeZGrzGMlF4X0EnJ+LpSgRW0AvwzF6V2T6Agwp1b/XSNqA8
	 M90z+gm0r9AwcsozGvlF2Z6X0kfCdQ+yumnJcywYP+JpkdeScjMy8tt3EMSP9t3vWi
	 EM8EVcEMJteh/CvTG+/g21KGxVLUDOmwq+CujASTSo3SyVXkIRwI+V7kVoYVoj2D0m
	 8Oct2ISzNUEmg==
Date: Sat, 20 Dec 2025 11:45:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] XFS: Fixes for v6.19-rc2
Message-ID: <cx4tzqmz7gy4oq2uksdjklfhbnonfaho47yvseann4oxh2vqph@2te74dxeofdz>
References: <pag7wbggnlzzdfkzykoyck4nnjldvyayqzf7qzchvduisffytd@manm5agx5c63>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pag7wbggnlzzdfkzykoyck4nnjldvyayqzf7qzchvduisffytd@manm5agx5c63>

Cc'ing linux-xfs because I initially forgot to, my apologies.


On Sat, Dec 20, 2025 at 11:44:05AM +0100, Carlos Maiolino wrote:
> Hello Linus,
> 
> Could you please pull patches included in the tag below?
> 
> An attempt merge against your current TOT has been successful.
> 
> This contains a few fixes for zoned devices support, an UAF and
> a compiler warning, and some cleaning up.
> 
> Thanks,
> Carlos
> 
> "The following changes since commit 8f0b4cce4481fb22653697cced8d0d04027cb1e8:
> 
>   Linux 6.19-rc1 (2025-12-14 16:05:07 +1200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.19-rc2
> 
> for you to fetch changes up to dc68c0f601691010dd5ae53442f8523f41a53131:
> 
>   xfs: fix the zoned RT growfs check for zone alignment (2025-12-17 10:27:02 +0100)
> 
> ----------------------------------------------------------------
> Fixes for 6.19-rc2
> 
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> 
> ----------------------------------------------------------------
> Chaitanya Kulkarni (1):
>       xfs: ignore discard return value
> 
> Christoph Hellwig (3):
>       xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file system
>       xfs: validate that zoned RT devices are zone aligned
>       xfs: fix the zoned RT growfs check for zone alignment
> 
> Darrick J. Wong (2):
>       xfs: fix a UAF problem in xattr repair
>       xfs: fix stupid compiler warning
> 
> Haoxiang Li (1):
>       xfs: fix a memory leak in xfs_buf_item_init()
> 
>  fs/xfs/libxfs/xfs_sb.c     | 15 ++++++++++++
>  fs/xfs/scrub/attr_repair.c |  2 +-
>  fs/xfs/xfs_attr_item.c     |  2 +-
>  fs/xfs/xfs_buf_item.c      |  1 +
>  fs/xfs/xfs_discard.c       | 27 ++++-----------------
>  fs/xfs/xfs_discard.h       |  2 +-
>  fs/xfs/xfs_file.c          | 58 ++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_rtalloc.c       | 14 ++++++-----
>  8 files changed, 80 insertions(+), 41 deletions(-)"
