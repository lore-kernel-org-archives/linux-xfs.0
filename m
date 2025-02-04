Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578CA2010F5;
	Tue,  4 Feb 2025 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738689179; cv=none; b=OY53U/m9JTM8Hx7GSEuzLL73x288J7QZ5e7w6SWACrJCGZ/3sOFNt+hRmK+UsOFmAZRgZvJE+4ffWGw2wkJZ/LVRmSVwYkVt7BcC3+6K96A98wm2dtLi9ADlHmoYKfQGYRG+uMtRwgyB/POF64JuoNsTb3Fi4CrVrN19xbS4GLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738689179; c=relaxed/simple;
	bh=TYBbgxdYa+MKYU9i0wj3W+NQ/U3Vwnna7ic7j5c8Rpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFwKzrPg8h7+RGTZVIFwcVQgvdKIRI6M1y/wBGZMMu+CP/LtigrRKg1geHz4ZCbzsqQLc9v3ptpQN+iuSn1TOX0K3hxPRPpRTtaIyGfw8E6Y7rmEGa/aMEFZof7sGBIwYC2fed28NHZAAOIpqkbId+CBa5nAcroihygb9PeuLUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipVP3SgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipVP3SgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B882BC4CEDF;
	Tue,  4 Feb 2025 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738689178;
	bh=TYBbgxdYa+MKYU9i0wj3W+NQ/U3Vwnna7ic7j5c8Rpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ipVP3SgYSu5SqIj6Lok69KhdIVIcAxuNPx/nCH6DQKESSLYwNTau1gVNrpPCbcxL7
	 40vyhREr10tgzQxjJ84bCZp8i77DGPQy1zFw1Oa9qGsdWwf5CIJWyCY86WjhRhx3q7
	 HNTovl5zYXgqGFWXaqa5jDy35UD9Aa7aXPmzv/pnIrfubfCxDRL81CHnfIvCZ26suz
	 iIVeg9wF1ormfzmeznwj2zToVnmZ6S9B9ipZoUFFY8tOo86m3HNwvTlq/78WTulXOB
	 AN/Ku32UHrJVElGk4sRzzz6/YL5X2zKqhDEF8IVr5X+6NGpuIawAzuP6TazbqwN5KR
	 iShT9+eB1/V/g==
Date: Tue, 4 Feb 2025 09:12:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/614: query correct direct I/O alignment
Message-ID: <20250204171258.GD21799@frogsfrogsfrogs>
References: <20250204134707.2018526-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204134707.2018526-1-hch@lst.de>

On Tue, Feb 04, 2025 at 02:46:54PM +0100, Christoph Hellwig wrote:
> When creating XFS file systems on files, mkfs will query the file system
> for the minimum alignment, which can be larger than that of the
> underlying device.  Do the same to link the right output file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/614 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/614 b/tests/xfs/614
> index 0f8952e50b9a..06cc2384f38c 100755
> --- a/tests/xfs/614
> +++ b/tests/xfs/614
> @@ -26,7 +26,7 @@ _require_loop
>  $MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
>  	_notrun "mkfs does not support concurrency options"
>  
> -test_dev_lbasize=$(blockdev --getss $TEST_DEV)
> +test_dev_lbasize=$($here/src/min_dio_alignment $TEST_DIR $TEST_DEV)

Hmmmm... I have a patch with a similar aim in my dev tree that
determines the lba size from whatever mkfs decides is the sector size:

# Figure out what sector size mkfs will use to format, which might be dependent
# upon the directio write geometry of the test filesystem.
loop_file=$TEST_DIR/$seq.loop
rm -f "$loop_file"
truncate -s 16M "$loop_file"
$MKFS_XFS_PROG -f -N "$loop_file" | _filter_mkfs 2>$tmp.mkfs >/dev/null
. $tmp.mkfs
seqfull=$0
_link_out_file "lba${sectsz}"

What do you think of that approach?

--D

>  seqfull=$0
>  _link_out_file "lba${test_dev_lbasize}"
>  
> -- 
> 2.45.2
> 
> 
