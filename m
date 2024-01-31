Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E71616435;
	Wed, 31 Jan 2024 03:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706672932; cv=none; b=Uz4OmxHWoCmy3Z4Lkzhr7IgyAtGQWeGMPTXRvaty+V7bH1jNn1E52N0k5tFITPJx12SjvtNC024G13vvz1LtbWJapg2P8Si2TGcmHRJlenbMmCxIHNIWhPxlMMAeb25JO9r5ehs3XM1fvBT+ug6ZZxTbm4mTR2N+oOtMdvW5Nao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706672932; c=relaxed/simple;
	bh=RGoYVTc5imbblBgJTcCcd3YgL7+tqhI2bKyYDphgRGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+PeDGJzJtJaK+m3uXh7uYa9KCilvN/d1PJfwyxQ9PuKDFmqtALDJEiu1Db4tZopOXaAJCErPIw/YL8BJMe5tdTA4PQwc37b90JX5k/38xECwT2InbqZrVNscLQJt/+1QaLLA8FoSDYe5NolwsH4J6x71Tk5/afYSKlJ8NyFpig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cioVVCrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cioVVCrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC67C433C7;
	Wed, 31 Jan 2024 03:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706672931;
	bh=RGoYVTc5imbblBgJTcCcd3YgL7+tqhI2bKyYDphgRGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cioVVCrQT10R6wRXDfsBbg0MrC1nmlcv8D4kH5IoUu5JDEj/4W7EA1F9DH1t96KyU
	 JweZ7H8zlPNDxx/sQrYmf20zj6T0Z4heFY2o9Aaltw/HPUSzoKi02joP/47Nqg2/zG
	 NywbDqhBOdLRbYzHgupFMGSw72/3FKRdHZKreWv5ZWkd37oe/ZP6WQGgzgWL0iND+n
	 xfnwxmjkRws6Tzy/LLODl/CLf05JQ6vI+PspLJnObwc4lp6726QU4HHeTHOwvtwcyM
	 uidYRhyjh8IUmlzTNXETL5i9muLm8iInczA9+6rV4L2Z/Eh7b6FDlu+Ql/wCpgFV7f
	 TetUo1Ofz3RDQ==
Date: Tue, 30 Jan 2024 19:48:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: fstests@vger.kernel.org, zlang@redhat.com,
	Dave Chinner <david@fromorbit.com>, mcgrof@kernel.org,
	gost.dev@samsung.com, linux-xfs@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
Message-ID: <20240131034851.GF6188@frogsfrogsfrogs>
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
 <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
 <20240130195602.GJ1371843@frogsfrogsfrogs>
 <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>

On Tue, Jan 30, 2024 at 09:34:23PM +0100, Pankaj Raghav wrote:
> >> What should be the approach to solve this issue? 2 options that I had in my mind:
> >>
> >> 1. Similar to [2], we could add a small hack in mkfs xfs to ignore the log space
> >> requirement while running fstests for these profiles.
> >>
> >> 2. Increase the size of filesystem under test to accommodate these profiles. It could
> >> even be a conditional increase in filesystem size if the FSB > 16k to reduce the impact
> >> on existing FS test time for 4k FSB.
> >>
> >> Let me know what would be the best way to move forward.
> >>
> >> Here are the results:
> >>
> >> Test environment:
> >> kernel Release: 6.8.0-rc1
> >> xfsprogs: 6.5.0
> >> Architecture: aarch64
> >> Page size: 64k
> >>
> >> Test matrix:
> >>
> >> | Test        | 32k rmapbt=0 | 32k rmapbt=1 | 64k rmapbt=0 | 64k rmapbt=1 |
> >> | --------    | ---------    | ---------    | ---------    | ---------    |
> >> | generic/042 |     fail     |     fail     |     fail     |     fail     |
> >> | generic/081 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/108 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/455 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/457 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/482 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/704 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/730 |     fail     |     fail     |     pass     |     fail     |
> >> | generic/731 |     fail     |     fail     |     pass     |     fail     |
> >> | shared/298  |     pass     |     pass     |     pass     |     fail     |
> > 
> > I noticed test failures on these tests when running djwong-wtf:
> > generic/042
> > generic/081
> > generic/108
> > generic/219
> > generic/305
> > generic/326
> > generic/562
> > generic/704
> > xfs/093
> > xfs/113
> > xfs/161
> > xfs/262
> > xfs/508
> > xfs/604
> > xfs/709
> > 
> 
> Ok, there are some more tests that I didn't catch. I will check them out.
> 
> > Still sorting through all of them, but a large portion of them are the
> > same failure to format due to minimum log size constraints.  I'd bump
> > them up to ~500M (or whatever makes them work) since upstream doesn't
> > really support small filesystems anymore.
> 
> Thanks for the reply. So we can have a small `if` conditional block for xfs
> to have fs size = 500M in generic test cases.

I'd suggest creating a helper where you pass in the fs size you want and
it rounds that up to the minimum value.  That would then get passed to
_scratch_mkfs_sized or _scsi_debug_get_dev.

(testing this as we speak...)

> We do this irrespective of filesystem blocksizes right? If we do that, then we can
> remove the special conditional that allows tiny filesystems for fstests in mkfs
> as well.

I dunno.  In the ideal world we'd figure out the fsblock size, but
divining that from the MKFS_OPTIONS is hard fugly string parsing.

--D

> 
> --
> Pankaj
> 
> 
> 
