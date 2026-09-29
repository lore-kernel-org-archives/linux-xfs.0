Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182631A9F91;
	Tue, 29 Sep 2026 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645483; cv=none; b=achi2SmmZpegPS2FjyNrskca6HK03Bm80hbQxTH7nFoq3FCOjdJROD8ZeUAT3Zva5u7Ln4Eehhv4C05f2dWsi0s9a72f0FsRfdFxIB9O3PMjt5/woDXe3mJ/Cb3CUPmSMMMRGxWVGaiGcdd00dx9tZvmPdq95SOXuuCsIW9+wZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645483; c=relaxed/simple;
	bh=5xkg5ShQm6N95J+EKVd3F0z/0w+9HePOobTZKTLCaSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxrLLStux7ppOmePoqT6SCbWRd3U62B+BisATX8BwDD9DjhtVXSC7MO1IikvK+Bp0ojsUH5uEOmSQLOwJzjTkSN6mmP5CN5+NczJNvVqHFFwJglivIBiJc+IpOTACnE/OYgyYn7TL7+8BL5BwUlB1W4d3oKWkL8UkVnlRUu+3bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncITCQlf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncITCQlf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A6E061F000FF;
	Tue, 29 Sep 2026 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645481;
	bh=BGF7Lf+wPaqkor4SarpKCkdrwZhOSKDnWSRJ55HaNk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ncITCQlf6VzWiq8+XwN22l4RZnU/Nj6vDx/aNnTX7SoEtQszIAHH6gHlmMBkUsCN0
	 FZJ12CnipOGU8YJdn2q62niZBH6KLsaa43umzIb3RIvrONshfLECrD2ngckjqLk1aK
	 UwV4PSFp+Ct/NKPKM3FGZ+eq3ukPVXpEAhaJLGR5ndLGu9C4QDjFbWComYz1VlLABb
	 yv2nFyPp5P+jwVIZYznXtb2n4NFGA1WXQesSjSitBHEUbPiLrOhmWRIjF2Noc5BA+N
	 eaJ7Vg6VYc0QMEiiproYfbEHoZBYnYbK1cpVMVpnRK+dYxdTpRvsgO8bRvpSa7ryvz
	 hUKBdZR/aqQWA==
Date: Mon, 28 Sep 2026 18:31:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] add a "datacsum" group
Message-ID: <20260929013121.GD2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-2-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:42PM +0200, Christoph Hellwig wrote:
> Add a group for test exercising data checksum functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  doc/group-names.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index ef6b8f51cf87..101c72688c02 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -34,6 +34,7 @@ dangerous		dangerous test that can crash the system
>  dangerous_fuzzers	fuzzers that can crash your computer
>  dangerous_selftest	selftests that crash/hang
>  data			data loss checkers
> +datacsum		data checksumming

Seems like a reasonable addition to me.  That said ... I bet at least
btrfs/282 is a data checksum test that's incorrectly in the (metadata)
scrub group.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  dax			direct access mode for persistent memory files
>  db			xfs_db functional tests
>  dedupe			FIEDEDUPERANGE ioctl
> -- 
> 2.53.0
> 
> 
