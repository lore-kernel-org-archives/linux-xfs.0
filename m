Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9971A3914FE;
	Fri, 25 Sep 2026 04:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790310919; cv=none; b=lcCZDXpfRiVDIvvZOzzY+MDiIp7YUK2N9xne9cFoiX1Wlo9iGTRyFmmcmIyIBHlFAKajXJ+JYreooIIhIM871AcmSeaeGbbDAMzCPG3pa8fl9aTtIhR6z7gZsV03OQdtHGysfNvovY1kNQGqwPYvyu0eKyFSkNdUGFd0djRZa60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790310919; c=relaxed/simple;
	bh=+lNTctq/ERYY61t8s5+zegEQhCAK1oiAnFou5SaBUII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTWfj5EYdObHnlwmnX4yu1660Oy56uaKtfOtkKqARtYaWc3H5dLg/xdLbMV/PlfhlURk1UrSB8bZdGPW46EmOUyEkAEHnlUbesRhU+HcTgiaIiudkQvetL1nUsJ1DECAAj5AIAMT6j9g7vS5fbyOaAhSpuqGs9L8hz+fH9+E3fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgJqt2NW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgJqt2NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34AD1F000FF;
	Fri, 25 Sep 2026 04:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790310918;
	bh=zhr096L6XvbdPA3YcsFKVElUuzXOCYo2Y4MR6wHtjpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LgJqt2NWo6BFs/+wgDPyGBTzIsX/1RvRLX+mnaNexso4Gf46fMt7p6RykygWjkYKh
	 CJEizl1or0wBC3zFbQJedjNWAFUTGkCreAZPQ8L/tcJbe9dO8w7vdFlqOhly+QwvRU
	 ZuzV8kZiyYD7yNY/IQSrHitpV4KkXEkSHRydpv8Da2dQU810R5UJKx50RAd3vnebY8
	 8c7U6FCwYCdTAkCglGoiVDjvgL2C9s5QeQSVbvOR71u5a29aAFRPUxzEc8NTEtV6ZW
	 7dHpBx1o5pRWyGkHhxq9EpUgt4b55ZnI6wH1Ahl8gVYepIJAV2PYe0JvL9x/QkkBxm
	 HVq8Bk6FVHaSA==
Date: Thu, 24 Sep 2026 21:35:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: djwong@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 05/21] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <20260925043516.GB112369@sol>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-6-aalbersh@kernel.org>

On Fri, Sep 18, 2026 at 01:15:17PM +0200, Andrey Albershteyn wrote:
> When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> it checks if file has DAX enabled and fails if that's true. However, the
> opposite case is not checked.
> 
> Note, that the only other filesystem supporting DAX and fsverity is
> ext4, and ext4 does check for this case.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/file_attr.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
