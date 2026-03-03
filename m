Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7E32DF6F4;
	Tue,  3 Mar 2026 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772560381; cv=none; b=Nx5OSqSsxHgCUkiJD0GFoO73BxH0rdEx2nwh6GIPDGrfBhygBhLMJLp5clV7870VL0mfouS+aAubPQgisDJKnODZ5hvivdvR42cxMQKwL/UTjiSXUJ7/DH7csxmYhHWNdwhg/6lKIcHciZA7+OelLOX2XgazwOzzOsL+cwM41GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772560381; c=relaxed/simple;
	bh=7QD5MqjyE+Wjyl0MhxMq8Ns+opJ4HIXK6UR6t+WDVh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAKIgv9zYXbS1P6p6NN2xviJwTNhM9xJ9H3hXWTH0GWlcS/hE2+Y5iD+xK+nNXp7NtacuRObDRrbPVzCVfGz+KnUHIHjraYZUBplQXG0qfKv9Gf2NmbbWEDzW96x7Cep8Qf+uy2QHC8eJ+s9oxVcE53mY2QOw6/c/plGUzo7hmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFbYO+o8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFbYO+o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B28C116C6;
	Tue,  3 Mar 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772560381;
	bh=7QD5MqjyE+Wjyl0MhxMq8Ns+opJ4HIXK6UR6t+WDVh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vFbYO+o8xLrOMsSHnERuLJK9EEosB54/L0L1Z04JJ/by/7P+ddIznLeUv1jMHVotr
	 iMWbG0qvUXe3V1xDQdXAen+hV2AS1szC2CD3RhD/94xf5lVybOxEl8Dz9C3EiON7PR
	 C7NNe33xDtgJVeh+Vjctd+VOuLqQi8cTAr+jj+GPttMmGuAq7pilQkhr+n3DadmFSw
	 QESNBjTuzOc3j5fH1JPw2XKUGMbXJa9/Nb6fAVjQfoygguovlWfZ7fCq31xh5kFiKz
	 a02dK3TdZZwrSmqIeLcyySzCo0UIue2DPfjV3O5YLaAwmHr0J5Z0Jerfi+AgFPULs3
	 sTDqYucISnk8A==
Date: Tue, 3 Mar 2026 09:53:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, luca.dimaio1@gmail.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/841: create a block device that must exist
Message-ID: <20260303175300.GT57948@frogsfrogsfrogs>
References: <20260202085701.343099-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202085701.343099-1-hch@lst.de>

On Mon, Feb 02, 2026 at 09:57:01AM +0100, Christoph Hellwig wrote:
> This test currently creates a block device node for /dev/ram0,
> which isn't guaranteed to exist, and can thus cause the test to
> fail with:
> 
> mkfs.xfs: cannot open $TEST_DIR/proto/blockdev: No such device or address
> 
> Instead, create a node for the backing device for $TEST_DIR, which must
> exist.

Hrm.  I'm still noticing regressions with this test, particularly when
the blocksize of the test filesystem is different from the block size
of the $IMG_FILE filesystem.

So I started looking for fsblock discrepancies between
xfs_reproducible_test.img.[1-3] and noticed that EOF block contents are
different if the file being copied in has sparse holes in it that are
not aligned to the fsblock size of the new filesystem.

IOWs, if $TEST_DIR is a 1k fsblock filesystem and the $IMG_FILE
filesystems have 4k fsblocks, you can write 1k at odd offsets (e.g. 1k,
3k, 5k, 7k, etc) and the created file does not match the file in the
proto dir.

I traced this to design thinko in libxfs_file_write -- it assumes that
the caller always wants to write the full block, even if the buffer
passed in does not cover the entire range of the block.  Therefore it'll
zero the head and the tail of the xfs_buf before writing it out.

Thus, the region at 1k causes mkfs to allocate fileoff 0 (which is a 4k
block).  Then libxfs_file_write writes 1024 bytes of zeroes, 1024 bytes
of copied-in data, and 2048 bytes of more zeroes.

Next, the region at 3k causes mkfs to re-call libxfs_file_write, but
this time it writes 3072 bytes of zeroes and 1024 bytes of copied-in
data, thus obliterating the first write.

That bug's on me, and I'll fix it in writefile by rounding data_pos and
hole_pos outward as needed to be aligned to the block size of the copied
in filesystem.  And I'll update xfs/841 to compare $PROTO_DIR against
what's in the new filesystem.

That fixes the data corruption problem, but then the test still fails
because now the space map isn't the same between mkfs invocations.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/841 | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> index ee2368d4a746..ddb1b3bea104 100755
> --- a/tests/xfs/841
> +++ b/tests/xfs/841
> @@ -85,9 +85,12 @@ _create_proto_dir()
>  	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
>  
>  	# Block device (requires root)
> -	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
> +	# Uses the device for $TEST_DIR to ensure it always exists.
> +	mknod "$PROTO_DIR/blockdev" b $(stat -c '%Hd %Ld' $TEST_DIR) \
> +		2> /dev/null || true
>  
>  	# Character device (requires root)
> +	# Uses /dev/null, which should always exist
>  	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
>  }
>  
> -- 
> 2.47.3
> 
> 
