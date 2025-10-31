Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163143128BC
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761916767; cv=none; b=YIw/6rLmjMvp+TsybK831oMoHTFv3hEetPWBLTDPYAK39yVH1eb3C73DTyBY+MGkux5kBhFjJdpv+kliVejYuKmK2JW7Yrzl4SlWE9NuXSGQ/GcQnZNmjI0LfTK7drvTzpLdTz52CzCT2F2waxdRAV+gUO901kUQSy4zGgO9fc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761916767; c=relaxed/simple;
	bh=bBpvCh/64uY83bu7nRr9t9rO7YWP6XQbLTRBqjqFpTQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g/Gr/TJV+xkSFminfwk0w1GRV5JDf0QJFr6j+KZi3xZqU6LGMJC2vdIdvl5NnXneqIkSfUbjjZPOULki7b75fQtBGRZc+y7jvBHSR+j1JF65aUmmOYC4Douz5FYf83+c4dVeUzxWZrlMBXssb5un3knf4yWlJSeDkIi2tSbeZ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRGZsQpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRGZsQpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE69AC4CEF8
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761916766;
	bh=bBpvCh/64uY83bu7nRr9t9rO7YWP6XQbLTRBqjqFpTQ=;
	h=Date:From:To:Subject:From;
	b=eRGZsQpFazKJosm4FK6BASnaglThHx504FRo7JZC83fFk6egrPajfb62Anj2SkKC5
	 jEwgNsGlXqkOO45gCCGiZuODl5xDUmv2lcl1aRQpxOtO11fva193lQjTa6Kq3Mbm7Z
	 /9npovH+nfg7k2UPU8c7CSdvdIF6gDawd7KGqeqQn5JZwtR9imL+wyaTepeG0MFadH
	 5H7rHTQBDF1d8CeFCUKhhf7S8S4n5TifiSvu6lruUaBHcejFYnjWZwUEGd4rZ8X1HT
	 9/dL2kQCvsxIi/l7MFw/mcdUbAaGrWhd5/Uf1K1TGYxPr3KT7lh8LMFQpcerlBN4/G
	 5dzk9pKpbso8g==
Date: Fri, 31 Oct 2025 14:19:23 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0db22d7ee462
Message-ID: <32rrxrhr3lsn6abfhdacc5im5nq7zdffzihncps3vjcxf2exvu@4rt3blhwtzwo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

0db22d7ee462 xfs: document another racy GC case in xfs_zoned_map_extent

2 new commits:

Christoph Hellwig (2):
      [83bac569c762] xfs: prevent gc from picking the same zone twice
      [0db22d7ee462] xfs: document another racy GC case in xfs_zoned_map_extent

Code Diffstat:

 fs/xfs/libxfs/xfs_rtgroup.h |  6 ++++++
 fs/xfs/xfs_zone_alloc.c     |  8 ++++++++
 fs/xfs/xfs_zone_gc.c        | 27 +++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)
