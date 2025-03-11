Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00322571B6
	for <linux-xfs@vger.kernel.org>; Tue, 11 Mar 2025 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741695192; cv=none; b=nXSqmXtcTdJzPcc2P4liCvoUdIxgBJ6chqsVtYi29repLHZ/fXPw8imaCyT5MyBumf95LImnxr8aTy8r9DoNdYFTZVBxbLLsAj8R0OlqV8+gBYBoCCM3XxkjzdtmEJshqgrdlhLSRM/J1eXoigsQwq3FVMGdsR23A0Xgl4ga3Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741695192; c=relaxed/simple;
	bh=/L55OjWtHku9pIeHK+OonilUENSBCXWfAeiB6rsmj90=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VqNnyKAhPhjKdbHePLqZYr06DBy1h0VDUuWdTHvSyLcz0P1nd3oNcWFEBtiy7VP1xd3egmn1RpNi/kvLi7DxwdjoToFVkt8C1eq4yG9wjIIp8Cy2hfsQTOWEp4Dc0cGgY4Cbj2R39epdRnxG/lGdhIm3uXsH2Rm4kQIUXO3TKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DS9HhF+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DS9HhF+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE6C4CEE9
	for <linux-xfs@vger.kernel.org>; Tue, 11 Mar 2025 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741695191;
	bh=/L55OjWtHku9pIeHK+OonilUENSBCXWfAeiB6rsmj90=;
	h=Date:From:To:Subject:From;
	b=DS9HhF+uIMS1xoVxrdfsh/UeWt982gtlTgMAbPdUJukvppFkepv9hmaHRmOYipHan
	 EPQdhwROygDL1NqW74wTTxSM4LMahK6waeSm18j9S2JOX+ZmjMl9Yt1LTidhDD2jTx
	 b3QU9236ENmnyffemEdd+7I255WaTpE0WgpuvyrTnJRyYxl3DOuVj0AuVRrVyHKOrZ
	 1Gnb2DWAkLcMfKpsM7KQVeJewqH7Ygx1s4u1EV35fcGHyhXuQmj3muSgNGX5pjnrRV
	 kynfjap5Qg5jMGVmjrb/SRfAwxCSJ29I1cZHXsr3/NRRJvDFGai7+J1BFgYr06Trhx
	 dBafOrBslqdKA==
Date: Tue, 11 Mar 2025 13:13:05 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8239a7655c69
Message-ID: <kogig6r53l4n7oknd57y6j6w6gzhwnl7h6mkmiopvbnjkpezht@b7wcehbuvkc4>
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

8239a7655c69 Merge branch 'xfs-6.15-merge' into for-next

2 new commits:

Carlos Maiolino (1):
      [8239a7655c69] Merge branch 'xfs-6.15-merge' into for-next

Hans Holmberg (1):
      [b7bc85480b03] xfs: trigger zone GC when out of available rt blocks

Code Diffstat:

 fs/xfs/xfs_zone_space_resv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)
