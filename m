Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E11854
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2025 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737464445; cv=none; b=TS7UFgnvGK1jrKTAMPQQWoXiPNjoSPyNf9/kQrv36FFbwgVwRtzOZjMHlpQcb9EWmGV0Kw9/p2PoZW+sGDrg05sUVGMTgrJinWJQOgkAIM4oH5AXAmUbrxVsZplIt3Ae21Og8+SlkNfoRYvTC4z70Esu9Q6Er3ly/CKwBNHsbHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737464445; c=relaxed/simple;
	bh=Bczp+Mk1GULGGoNXDpdESk+6tq3PfX6KbtuRNXYozB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/vEjO4MKpStn2wOa3dvewmkrnsXLPDre5lsLLFJ9kpAplzS/UyylDy04YjwA5QBbplT1oNgl8KJxpwmY0kTfvYZD9ulArEJgSA7cBhj6mGziwNoEB86FCsc9YsRf8JiV1T9bHpfi5IXjcnRm+1Zg9VP2bWBlwtF5K0R0WItseY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cD6dmr53; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cD6dmr53"
Received: from cwcc.thunk.org (pool-173-48-114-200.bstnma.fios.verizon.net [173.48.114.200])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 50LD0Rih006960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 08:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1737464429; bh=nQPo5+23vUPdLpPn03EHsNJ0Nm3bsBYZfxGnIAZrVj0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cD6dmr53wcuWuy66G5GsnAFoQeJKT8+7Fq4Vc3935dOjP2fyI/1a7ashnCRnZMzwr
	 IOX5fHtgfQ4sDA0Cj6Fm72AOec7PeB1GB9P83nIkGwub6rZ7CZ+CQzcV6E5daAeU7O
	 7vTBm9TiCKmGQ7r37LwcEU3HpkHLwBNFtIZdctxfx+ZBAz18tQ/3B0FFvVGQXNum8m
	 5rH2jqUhNeUZMjUDYvI86fpaPM65ZqAsWxypMh1B8KhqwH76kIv7P4VdRAIpFnA47H
	 Uz82buwKHQPKQIgq1LCcCvNZMz+w7kJTKzvE4qzpREEDGjwQwiQeKdP0HzzD8f/R5T
	 zNrT+CH8bd/6g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 77B6115C01A1; Tue, 21 Jan 2025 08:00:27 -0500 (EST)
Date: Tue, 21 Jan 2025 08:00:27 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com, hch@lst.de,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] generic/650: revert SOAK DURATION changes
Message-ID: <20250121130027.GB3809348@mit.edu>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
 <Z48pM9GEhp9P_VLX@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z48pM9GEhp9P_VLX@dread.disaster.area>

On Tue, Jan 21, 2025 at 03:57:23PM +1100, Dave Chinner wrote:
> I probably misunderstood how -n nr_ops vs --duration=30 interact;
> I expected it to run until either were exhausted, not for duration
> to override nr_ops as implied by this:

There are (at least) two ways that a soak duration is being used
today; one is where someone wants to run a very long soak for hours
and where if you go long by an hour or two it's no big deals.  The
other is where you are specifying a soak duration as part of a smoke
test (using the smoketest group), where you might be hoping to keep
the overall run time to 15-20 minutes and so you set SOAK_DURATION to
3m.

(This was based on some research that Darrick did which showed that
running the original 5 tests in the smoketest group gave you most of
the code coverage of running all of the quick group, which had
ballooned from 15 minutes many years ago to an hour or more.  I just
noticed that we've since added two more tests to the smoketest group;
it might be worth checking whether those two new tests addded to thhe
smoketest groups significantly improves code coverage or not.  It
would be unfortunate if the runtime bloat that happened to the quick
group also happens to the smoketest group...)

The bottom line is in addition to trying to design semantics for users
who might be at either end of the CPU count spectrum, we should also
consider that SOAK_DURATION could be set for values ranging from
minutes to hours.

Thanks,

						- Ted
