Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF72313AF2;
	Thu, 20 Feb 2025 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089060; cv=none; b=PD9r61glOyVW9BeEUppLM96ye+9hlwS5Rd8LY/lwlH1vfFSu8ESPFU19TpAp8NIBgYVYcgDW5n/nzrJbxLuZhEaI0Kj40G0Ub5YFlKTsOEujsJgchZphh6xJgIZZZfDNyi+ebn04Holi9M+3IiYy7RCpe7HeXS3wAD5dJib4KR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089060; c=relaxed/simple;
	bh=UzClXLPnYaB5DQcghj8nNxBgQZe6qBdcYHDCW1A0GzU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Floc2Z/IVxcvKhCq+3kq7rWNLlYk0tBrgz0MAIj9rWtVhnmmqevF9+vvkJi7b/PwbHU2XIZ28T3guf438EDVoj8gyGNGMmYkZM14WAd2zlPRftz17K5mUPujvDHvg/k4mgsV9AT/33dM1wCGbs+27VUSSc8ZntrSh4jdm28zVJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q19/fO3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q19/fO3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C934C4CED1;
	Thu, 20 Feb 2025 22:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089060;
	bh=UzClXLPnYaB5DQcghj8nNxBgQZe6qBdcYHDCW1A0GzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q19/fO3RCO4s3R/Xu2sIZfxiyv07wn72vKcn2cX2Fb44cOCcemPbwLGmZY4nRtDZv
	 z0VNEc2G3z5xrD5az4roHBN3outHOEYjWnDAF+U0sDeCRHhr0ia6oypHVnjpp9nGsc
	 fekhwZJuU+GN3DOtU3HVXWyzpE54EQ+5wPuGIo6sLTZ+zbKnuuyTNKUVuiRoXdBBqz
	 P9h454KePGXzuE1fpR9Y9pcArOgnIe2SRtRTyBJ/Neom3IJ43TAwDBVmMpWHXK19Ew
	 idL/nhMK9h6SV89pfcqrAqnujTE6R+PowcR9HHNYzCfk3LkU1VWvIpLzmAQubh22O9
	 Trwo6+d9kvNFA==
Date: Thu, 20 Feb 2025 14:04:19 -0800
Subject: [GIT PULL 01/10] fstests: more random fixes for v2025.02.16
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901465.1712746.9207824229366098923.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f3212c130a75f70a699afee6f6dbeac799abcfe1:

generic/370: don't exclude XFS (2025-02-19 15:54:23 +0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/random-fixes_2025-02-20

for you to fetch changes up to 977d2533c261382a656417d4288ca79f15fc7655:

dio_writeback_race: align the directio buffer to base page size (2025-02-20 13:52:16 -0800)

----------------------------------------------------------------
fstests: more random fixes for v2025.02.16 [01/22]

Here's the usual odd fixes for fstests.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
dio-writeback-race: fix missing mode in O_CREAT
dio_writeback_race: align the directio buffer to base page size

src/dio-writeback-race.c | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

