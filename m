Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F44B13FD72;
	Tue, 31 Dec 2024 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688097; cv=none; b=QF/wvNPN9fJKWDz8h5qfG2oppGC38XeJqzLimFKw8u4YBfF7poYPkyQ8S5A6wvQSjuW5/WTJ0XSqG0PBYCc6lFAVklMfiMmwqbgPDexj8kHZlGmXyhWRGcaz8lmnQAyUEGxvJPiQO2QMxBsQ+exBHN/WCF+G4bWrn2HRuwcSEYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688097; c=relaxed/simple;
	bh=WbIyTS2JlFS5hyHvvUSda567BswWPeE26o/lewb4h0E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWAHRQg+IprqZWdGFLY1sMkw72fELOqrYY5yr8ua6zCcDW3kdqLtJZzDiYhtQ/fOYWc+Z5ZGLsKarDEW+vsmeh0UukNqXMJcqn827PzF2EW79Yx6RoMgHcJeJnEGpdQwpmF1qt8dvZU1c7i3u2kd8cqRNhDUeMJPI1bJnAui1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cq00stn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cq00stn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19D7C4CED2;
	Tue, 31 Dec 2024 23:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688097;
	bh=WbIyTS2JlFS5hyHvvUSda567BswWPeE26o/lewb4h0E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Cq00stn4n4F44MGUAVnJ4VtV2wvKA2R36GwUgOMTX560erThG/zs8AnhbaHuDbAIa
	 Zq1nPNSQRyE2RaGwEs3tezYl+USe0QXO8F5iDIY57sj7Y9rOEODNjszSUmX9mlR2oK
	 RTt08ClSeenAUmF/crlJnwP/e0pCHmAar1Kx830AXxE2AJ6zrATQyQH2lTKjvkDYXG
	 yuPkO27ZoWEWuBrTwldKWYthpFZn53pYuOEV7HNv9mmpPykBNIp0MsnTq1dFMnrcLV
	 slLzYjCeqFZcEFqFPO7y3cBt9faG0hdSBRxpOcgxECQwp1MBdMOdiZAFB1XBELZ5KM
	 2v0TNVrwhVWVw==
Date: Tue, 31 Dec 2024 15:34:56 -0800
Subject: [PATCHSET 1/5] fstests: functional test for refcount reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568781929.2711934.8784820316232821491.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Add a short functional test for the new GETFSREFCOUNTS ioctl that allows
userspace to query reference count information for a given range of
physical blocks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-refcounts

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=report-refcounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=report-refcounts
---
Commits in this patchset:
 * xfs: test output of new FSREFCOUNTS ioctl
---
 common/rc           |    4 +
 doc/group-names.txt |    1 
 tests/xfs/1921      |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1921.out  |    4 +
 4 files changed, 171 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1921
 create mode 100644 tests/xfs/1921.out

