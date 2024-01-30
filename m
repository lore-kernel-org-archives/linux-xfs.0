Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3534071B4F;
	Tue, 30 Jan 2024 19:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706644563; cv=none; b=mBCpZcwzBHhChtaqlGoYeUPnPsYC0OUMz6IvvgSVYM0WA1gNQ0rVIk9OF9ORj8L90HRahCvtPSuOWgaVhTYXwBEWCktM/Q9WpQqGdD9FOqcI5e4nOZOFJ7egYOyIMRhFnDTj6A+oy9/29gJ8nxfVLBNBApcn5izF6q/gWAUJ88Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706644563; c=relaxed/simple;
	bh=4vd8klWoWsajaknbDkyWRMXlZUmPD9ZfMI5s7yqv5SQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLh7lqu0PzJXE87D2DtNbIQwoFx1u4vu1Dky3w8l1nVW3YeilQTb5Y6jMka3sJc2hBZSqbWgEzovjTyJQ2toxA1sV7wGqo2VkHZivYpwSeZc4TKP+/+m7hkGyuHQlu7xW5j/RzbX5y1iBHzLu0aw8NbqqKd1Eu2K4TeQb4dkdw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdKjWc4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdKjWc4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA6FC433F1;
	Tue, 30 Jan 2024 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706644562;
	bh=4vd8klWoWsajaknbDkyWRMXlZUmPD9ZfMI5s7yqv5SQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rdKjWc4YYirLxLpu49Fba0WUkBI8rbQiHBzETy88rmfiOzcDlTy+vV9wt1QNEJjhm
	 3SRI327b9XbQobXnvZD9lPmhYQRk+N9I6W4l5IyagLX5WVtqhxvSg1xcdotitPDRb2
	 386JBoXRskyv9dhSxghyXFoc8CydpmRUwb+Um3tCsCwRVtIGoBuP5A/bbqJ/d4JkuP
	 Yb1AWDbizCda9sJeeKjFbcM/9T29usinJqZ8hKYK7tRNnc+sKyPve9IO5V9dPbeJSm
	 RYs8DIMOLB1fgPdyoEkYbCjGrCp4W1O8E7emJZ18ae20jtKsU2WSIUNg8MZXGfgcVR
	 7vQVfUc+wiPAA==
Date: Tue, 30 Jan 2024 11:56:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: fstests@vger.kernel.org, zlang@redhat.com,
	Dave Chinner <david@fromorbit.com>, mcgrof@kernel.org,
	gost.dev@samsung.com, linux-xfs@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
Message-ID: <20240130195602.GJ1371843@frogsfrogsfrogs>
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
 <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>

On Tue, Jan 30, 2024 at 02:18:01PM +0100, Pankaj Raghav wrote:
> As I pointed out in my previous thread [1], there are some testcases
> in fstests that are failing for FSB 16k, 32k and 64k due to the filesystem
> **size** under test. These are failures **upstream** and not due to the ongoing
> LBS work.
> 
> fstests creates a lot of tiny filesystems to perform some tests. Even though
> the minimum fs size allowed to create XFS filesystem is 300 MB, we have special
> condition in mkfs to allow smaller filesystems for fstest[2] (This took some time
> to figure out as I was splitting my hair how fstest is able to create XFS on top of
> 25MB images).
> 
> The problem comes when we have FSB 16k, 32k and 64k. As we will
> require more log space when we have this feature enabled, some test cases are failing
> with the following error message:
> 
> max log size XXX smaller than min log size YYY, filesystem is too small
> 
> Most test cases run without this error message with **rmapbt disabled** for 16k and 64k (see
> the test matrix below).
> 
> What should be the approach to solve this issue? 2 options that I had in my mind:
> 
> 1. Similar to [2], we could add a small hack in mkfs xfs to ignore the log space
> requirement while running fstests for these profiles.
> 
> 2. Increase the size of filesystem under test to accommodate these profiles. It could
> even be a conditional increase in filesystem size if the FSB > 16k to reduce the impact
> on existing FS test time for 4k FSB.
> 
> Let me know what would be the best way to move forward.
> 
> Here are the results:
> 
> Test environment:
> kernel Release: 6.8.0-rc1
> xfsprogs: 6.5.0
> Architecture: aarch64
> Page size: 64k
> 
> Test matrix:
> 
> | Test        | 32k rmapbt=0 | 32k rmapbt=1 | 64k rmapbt=0 | 64k rmapbt=1 |
> | --------    | ---------    | ---------    | ---------    | ---------    |
> | generic/042 |     fail     |     fail     |     fail     |     fail     |
> | generic/081 |     fail     |     fail     |     pass     |     fail     |
> | generic/108 |     fail     |     fail     |     pass     |     fail     |
> | generic/455 |     fail     |     fail     |     pass     |     fail     |
> | generic/457 |     fail     |     fail     |     pass     |     fail     |
> | generic/482 |     fail     |     fail     |     pass     |     fail     |
> | generic/704 |     fail     |     fail     |     pass     |     fail     |
> | generic/730 |     fail     |     fail     |     pass     |     fail     |
> | generic/731 |     fail     |     fail     |     pass     |     fail     |
> | shared/298  |     pass     |     pass     |     pass     |     fail     |

I noticed test failures on these tests when running djwong-wtf:
generic/042
generic/081
generic/108
generic/219
generic/305
generic/326
generic/562
generic/704
xfs/093
xfs/113
xfs/161
xfs/262
xfs/508
xfs/604
xfs/709

Still sorting through all of them, but a large portion of them are the
same failure to format due to minimum log size constraints.  I'd bump
them up to ~500M (or whatever makes them work) since upstream doesn't
really support small filesystems anymore.

--D

> 
> 16k fails only on generic/042 for both rmapbt=0 and rmapbt=1
> 
> 
> [1] https://lore.kernel.org/all/7964c404-bc9d-47ef-97f1-aaaba7d7aee9@samsung.com/
> [2] xfsprogs commit: 6e0ed3d19c54603f0f7d628ea04b550151d8a262
> -- 
> Regards,
> Pankaj
> 
