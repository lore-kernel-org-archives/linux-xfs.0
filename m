Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD38D1CA89;
	Thu, 25 Jan 2024 21:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706217068; cv=none; b=NSih4/Cv4rqfzi1AJXKDUF5s2v9tFnjimIXPDG0K33nh6LqwZ9ngLUxQ2X6BTJraIzi/cqlhQkhN1bf3HusuXN/oZ6U5Qckra5AY31W/YfFrervBlX219wajKjUJcchw6t9SpJYHqHOEgU8z92X9r02YISDOVRZ2Xvt9RdWKjLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706217068; c=relaxed/simple;
	bh=qRjSboulXWyS6g+AWa1Naj0Ernvv/oc1lSecuWo1iRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLBiQQxkxSqVuWjivNK7z42nAHWzu5N7sJ0X37RH2DW27zjI63w45/U1E1DJA9kGkqMkxk2/QuKjdWfOAxslGjynZPg+DU4kIlTJOPAnBlYL9xPhp5YFdL4jst/V/hdwapkY9L+l53guCzZGVJ6VbzpK0SF3a7+SNF0Z9JtMWYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEdHeaah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEdHeaah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22E5C433F1;
	Thu, 25 Jan 2024 21:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706217068;
	bh=qRjSboulXWyS6g+AWa1Naj0Ernvv/oc1lSecuWo1iRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YEdHeaahVZYS+Ok9fbigt1b78exmXX8k6t0EAoWpthnoyHWscAQSvEXendj1lui9b
	 NP6gvRN1nKG/Q+fwDJwvRKI13nCuY5r+k1SsIr9BLaz0V73/W82R/G/i3EKXLEJ32N
	 t62LYJ0PQNNQ6Xfha8yLGVAAh77LASpIE9mH1o3vUC+NM0cFITVI6J4Wlv/yUiStJe
	 9Shx1cScADzAZt9at8GYZjFBNQj+c3niy6q8qrULpRFV38owavFYCAJaNUJMDslUck
	 YwyfgaKPRNx3CQItsGgOFXIEQBHS9AkrNAco+VXjKj9zB3VQqwb71B0EbzJzmbnuc8
	 slyNBEcdYyuGg==
Date: Thu, 25 Jan 2024 13:11:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: xfs/599 on LBS
Message-ID: <20240125211107.GC6188@frogsfrogsfrogs>
References: <ZULu/Rm/EiBY8ZzG@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZULu/Rm/EiBY8ZzG@bombadil.infradead.org>

On Wed, Nov 01, 2023 at 05:36:13PM -0700, Luis Chamberlain wrote:
> xfs/599 takes a long time on LBS, but it passes. The amount of time it
> takes, however, begs the question if the test is could be trimmed to
> do less work because the larger the block size the larger the number of
> dirents and xattrs are used to create. The large dirents are not a
> problem. The amount of time it takes to create xattrs with hashcol however
> grows exponentially in time.
> 
> n=16k   takes 5   seconds
> n=32k   takes 30  seconds
> n=64k     takes 6-7 minutes
> n=1048576 takes 30 hours
> 
> n=1048576 is what we use for block size 32k.
> 
> Do we really need so many xattrs for larger block sizes for this test?

No, we don't.  The goal of this test is to create a two-level dabtree of
xattrs having identical hashes.  However, the test author apparently
forgot that if a dabtree is created in the attr fork, there will be a
dabtree entry for each extended attribute, not each attr leaf block.
Hence it's a waste of time to multiply da_records_per_block by
attr_records_per_block.

Patches soon, once I run this through overnight testing.

--D

> S1="KNR4qb1wJE1ncgC83X2XQg7CKwuqEYQjwuX3MG1o6FyqwrCXagIYlgGqtbLlpUn9prWpkCo9ChrxJOINgc3MBSG0La6Qhm9imcduPeGtC3IvQOzuKPsQAN3O5lVS9zha1giONke1RfnTcidsDlIxNcupydmZrdJmwHU7HRxWWqLTenWh3Gi5YNWExX0Ft94NEtfY8Lov2qvYJbTA5knONimQq5wUaK1Eo449pDXTnCOTRRhPnSHMXzNqT"
> 
> mkfs.xfs -f -b size=32k -s size=4k /dev/loop16
> mount /dev/loop16 /mnt
> touch /mnt/foo
> time xfs_db -r -c "hashcoll -a -n 1048576 -p /mnt/foo $S1" /dev/loop16 
> 
> But also, for the life of me, I can't get the btree printed out, I see
> the nvlist but not btree, you can print *everything* out with just
> -c 'print':
> 
> xfs_db -c 'path /hah' -c 'ablock 0' -c 'addr btree[0].before' -c 'print' /dev/loop16
> 
>   Luis
> 
