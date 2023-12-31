Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC65BA22;
	Sun, 31 Dec 2023 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5S2MqOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF9C433C8;
	Sun, 31 Dec 2023 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704046336;
	bh=FdfHdP3DmJrcJVFOS3K/3ZD3qnts8Rp5p8HMd6Vl6vE=;
	h=Date:From:To:Cc:Subject:From;
	b=k5S2MqOGKcE3gzdb4EriaBnzjG6UanErYwEA49kTtmWBGHGC+NveWw6uq/Kxuod0I
	 FjQt/hSnMHToL44dqYuh9OjV+kK3ve++zRR0KvtOFZL+ThGgti7LOvMUi2QBmXIHbO
	 FTeeNjx/+tYHwyLjLXQkpbXKh2flMcRZmN4a1BUc2b2oGXnKjl3Z9jKczoV0mCwv4i
	 GBykR9bamo2F7GL2CbA1KDw/kyJ6mmvwZYHfXg0VJDOvwbFsEO162SjikcPvm0FpMZ
	 0Aiv31WHXrTDfcnxnWa02VmN7h6pz6Whahm6nnhFzldirRnoEgalQHRtU3c+CVpWjl
	 DM3WJMQCyILVQ==
Date: Sun, 31 Dec 2023 10:12:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanrlinux@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, greg.marsden@oracle.com,
	shirley.ma@oracle.com, konrad.wilk@oracle.com,
	Matthew Wilcox <willy@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests <fstests@vger.kernel.org>, Zorro Lang <zlang@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [NYE PATCHRIVER 1/4] xfs: the rest of online repair part 1
Message-ID: <20231231181215.GA241128@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

In last year's NYE deluges, I mentioned that I wanted to get online
repair merged for the 2023 LTS kernel.  That goal was not attained, so
now I want to get this merged in time for the 2024 LTS kernel.

(Big thanks to Dave earlier for helping to get all 120 scrub fixes
merged; and Christoph more recently for doing the same for the first 30
patches of repair and a bunch of rt refactorings from the modernization
series.)

But seriously, folks, this is dragging on unnecessarily.  Either you all
need to step up and actually review the 55 patchsets and 458 patches
needed to get online repair done, or decide to let me merge it and deal
with the consequences, which I will.  The only part of this deluge that
changes the ondisk format are the swapext patches that add a new log
intent item type.  Everything else is guarded by Kconfig options and
won't destabilize the rest of the filesystem.  I haven't changed the
swapext log intent item format since 2021.  2+ years to get feedback is
dysfunctional.

In the meantime, lack of upstream merging means that I cannot start
wider testing of this code with the people who run (b)leading edge XFS
code; I cannot solicit user and customer feedback because they don't
have the code; and there's no way I can meaningfully prioritize
improvements to the code because **I cannot get feedback**.

Fuzz and stress testing of online repairs have been running well for two
years now.  As of this writing, online repair can fix more things than
offline repair, and the fsstress+repair long soak test has passed 300
million repairs with zero problems observed.

(For comparison, the long soak fsx test recently passed 110 billion file
operations, so online fsck has a ways to go...)

--D
