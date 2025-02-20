Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A21513AF2;
	Thu, 20 Feb 2025 22:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089170; cv=none; b=fSIxEGgQ9i/VclCJW1YEdTzPahgVpKUfdhfODrh+PaGS0LKLkLwYHFSZs/VvZQUFOMGG3AZIrMV7b6cElSAH0323yNHoVfmD+IZ8xd7MTvt1ydYu/gFo63gDII35sDdRmSUjxWP7+FDA7nz9PJGF8tnmjFffVWvOetQpbB+4NeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089170; c=relaxed/simple;
	bh=KaP9Jtuul36hF52esEAVzH/Ji07gkdL2JhR8zo4XqNM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Ues6VGMdFs78fc4klAqL0fYcfCifzPY4FR5CUzXCgUHdQktL68CBao0kgNZFA1DW0+fLO4H0bC+bLeSSH3p5GAdiKah7PWMGoSF1k5hnW9V3RWSgZJEG2OvFCfIKSxwj3igd7KuZXg3P1fqVhI87IU9s1tqQ88dHM4MTuu9YMlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdVttbIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdVttbIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B749EC4CED1;
	Thu, 20 Feb 2025 22:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089169;
	bh=KaP9Jtuul36hF52esEAVzH/Ji07gkdL2JhR8zo4XqNM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZdVttbIyjRXLegmUWqiBFy10AWDF3uIcHnGH7nkW+M/+Sn7IZ1HGhStkWx8tE+d9y
	 RJ+FYtD9+Xwh+Ls5zj88SCZJR3oLkq1PcjeEHP2+Tead2hKs+U2GHmG/fEzsB3zumu
	 PVKTCFw+3G48rG0c6RlEbBCZIrE/yvEJBJDECBRMz/Ao+VdTLrbHDtP+NhZuU/c8H1
	 jVgH86IZBPUUnuNq83xhMePBNGqJa/+hZHIHltclYdIq+q0IvWSD9Ub60DcxR2ZA3H
	 jRFwDIaFFxpAYYGSqZvu47VZN2ifyEhUCOLu2JIa5iNRwmj4YAMcY4OJtbkk8EA1Kt
	 x2MmvNm1nXkyQ==
Date: Thu, 20 Feb 2025 14:06:09 -0800
Subject: [GIT PULL 08/10] fstests: check new 6.14 behaviors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008902054.1712746.2908487289505223795.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit f5be7b47b120876ac7f256781744c834bad22db6:

xfs: regression testing of quota on the realtime device (2025-02-20 13:52:20 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/linux-6.14-sync_2025-02-20

for you to fetch changes up to ab6d4b4067053679508792dc14d135d828b7e19b:

common: test statfs reporting with project quota (2025-02-20 13:52:20 -0800)

----------------------------------------------------------------
fstests: check new 6.14 behaviors [08/22]

Adjust fstests to check for new behaviors introduced in 6.14.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
common: test statfs reporting with project quota

tests/generic/1955     | 114 +++++++++++++++++++++++++++++++++++++++++++++++++
tests/generic/1955.out |  13 ++++++
2 files changed, 127 insertions(+)
create mode 100755 tests/generic/1955
create mode 100644 tests/generic/1955.out

