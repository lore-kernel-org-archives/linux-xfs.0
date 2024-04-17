Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF09C380;
	Wed, 17 Apr 2024 00:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713314276; cv=none; b=ox+QA73sQ8GtlpO0fO9Bp8VFk7/UjPKny+7Y6fJ50X1dimFl46MaGvMlYFWv1QRhHMg87MQjkRTDsIT06ktZrQEoFTYmHLyT8b8nRMAGVjtWQcTpDeo1Ql+WEi7lkW3QAYSjrglJRrWniyc8sHEX4S7QFublaVLb9eH+8FVCU+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713314276; c=relaxed/simple;
	bh=6AWzsuKRQAF3hA8h1VfHOO4HsgKqT9BgoO3EL4C1Nf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C06VnyawuMDHn8SJy7uk12OQIUM7BuPbxEp8qOlcMoQYPBjnfh3z1qbO0/9Q//qPZnVXZMjBCGi7IF70y28euQrptenDADq0A62RhJHkjFpZHumQy7AX+WMxyNyNnZg3FsxG0zR+/DObTNXAU/HJQ7X3UWTcNzDO27bhx+faoI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uLv101/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLv101/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F515C113CE;
	Wed, 17 Apr 2024 00:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713314276;
	bh=6AWzsuKRQAF3hA8h1VfHOO4HsgKqT9BgoO3EL4C1Nf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLv101/YuHFBRULIBbDwCxkETrX6r1NauHJZmv0wX9ShR5T42cNpRfxVO1S9HYIdZ
	 CLsHXjvNEz7N0lXqP+yqFjgED3vUFj1ZXjSeISxEd17H99aCIUL6ll37Xu3uzLZ0HG
	 kR+e9beSYD7ZGhU6MuLh84VL4JWfbF/F7swpKJIAH3B0vLu+N/ay/5Z6Lbpcbc7qnG
	 syxcEOwo0wXA98swXv37eEE0co1QSNDPH94V34N2gG4dsRzzR+M2EdoFuJorPk7seg
	 EFcSm1oTxzhKbM6+LOZNspo6zkNPaBAR6yjuB2kXT1dZhnJbPfLZKyJkzqVkZtxcla
	 vpIZ0gfh5ZmDA==
Date: Tue, 16 Apr 2024 17:37:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: kdevops@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH kdevops] xfs: add xfs/242 as failing on xfs_reflink_2k
Message-ID: <20240417003755.GK11948@frogsfrogsfrogs>
References: <20240416235108.3391394-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416235108.3391394-1-mcgrof@kernel.org>

On Tue, Apr 16, 2024 at 04:51:08PM -0700, Luis Chamberlain wrote:
> This test is rather simple, and somehow we managed to capture a
> non-crash failure. The test was added to fstests via fstests commit
> 0c95fadc35c8e450 ("expand 252 with more corner case tests") which
> essentially does this:
> 
> +       $XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
> +               -c "pwrite 0 $block_size" $sync_cmd \
> +               -c "$zero_cmd 128 128" \
> +               -c "$map_cmd -v" $testfile | $filter_cmd
> 
> The map_cmd in this case is: 'bmap -p'. So the test does:
> 
> a) truncates data to the block size
> b) sync
> c) zero-fills the the blocksize

Which subtest is this?

I've seen periodic failures in xfs/242 that I can't reproduce either:

--- /tmp/fstests/tests/xfs/242.out	2024-02-28 16:20:24.448887914 -0800
+++ /var/tmp/fstests/xfs/242.out.bad	2024-04-15 17:36:46.736000000 -0700
@@ -6,8 +6,7 @@ QA output created by 242
 1aca77e2188f52a62674fe8a873bdaba
 	2. into allocated space
 0: [0..127]: data
-1: [128..383]: unwritten
-2: [384..639]: data
+1: [128..639]: unwritten
 2f7a72b9ca9923b610514a11a45a80c9
 	3. into unwritten space
 0: [0..639]: unwritten

It's very strange to me that the block map changes but the md5 doesn't?
The pwrite should have written 0xcd into the file and then the space
between 64k and 192K got replaced with an unwritten extent.  But
everything between 192K and 320K should still be written data.

--D

> The xfs_io bmap displays the block mapping for the current open file.
> Since our failed delta is:
> 
> -0: [0..7]: data
> +0: [0..7]: unwritten
> 
> So it would seem we somehow managed to race to write, but it never
> went anywhere. I can't reproduce yet, but figured I'd put this out
> there to at least acknowledge its seen at least once.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> Super rare to trigger this but figured I'd check to see if others have seen
> this fail before. This was on vanilla v6.8-rc2. I'm wondering a race is
> possible with a guest using sparse files on the host, and the host somehow
> incorrectly informing the guest the write is done. btrfs sparse files
> were used on the host for the drives used by this guest for scratch drives.
> 
>  .../fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt b/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt
> index f6ea47b0479f..8b4161f3700e 100644
> --- a/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt
> +++ b/workflows/fstests/expunges/6.8.0-rc2/xfs/unassigned/xfs_reflink_2k.txt
> @@ -19,6 +19,7 @@ xfs/075
>  xfs/155
>  xfs/168
>  xfs/188
> +xfs/242 # F:1/2000 non-fatal failure cosmic ray? https://gist.github.com/mcgrof/6ef50311179a65221413a63c0cc8efd1
>  xfs/270
>  xfs/301
>  xfs/502 # F:1/8 korg#218226 xfs assert fs/xfs/xfs_message.c:102
> -- 
> 2.43.0
> 
> 
