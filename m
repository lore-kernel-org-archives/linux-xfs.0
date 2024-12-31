Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A492613FD72;
	Tue, 31 Dec 2024 23:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688159; cv=none; b=K0K3cB1aLQtY8fOUDspLDs+ftUUbgpqpnzGeZECjP7ZbNsE3izhbUbP/8IDLsB+3TY/ZniIKJKNmzpMa4rr5ManIfmpX+GFTMcijljB0uhzc8mhfi/xjlGe6zuTMzYR4P7c/8EsjzG+2zoQTBOfQqEwV+K7bFCdA5b6qhL1oeg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688159; c=relaxed/simple;
	bh=M5OEJGNgK88c89a0rFcdTpLsRgO7l3uoDRpgQQu8vZE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiFhk/qKk5nBNtQO7grprLU2AODkxeQFAcjx1H8OpcEEP1OA6LD1hvvzJf2CW7P0NQpSBOZ9CLonIsNBgnJGDV/oRDlfPS6c7azxHshJ3gvOox0q8A1kdI34Vzn9VQGD58U5wjwJco+7UMRstFayO6+H2E96dnQtVdJCltwSR3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVwXoEqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVwXoEqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D2BC4CED2;
	Tue, 31 Dec 2024 23:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688159;
	bh=M5OEJGNgK88c89a0rFcdTpLsRgO7l3uoDRpgQQu8vZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SVwXoEqDClAH6i20M2hpduPLDmjZDdK2VndHb2i9jyZZ6lROnNzvpzFAAli36OYbU
	 klk5deEyMhGymrggcFEwp07ZydYjlwGjsI1JqfJclqlP2xNrmGS+/hbyP7sMBxC8/C
	 wmca2HOeCCRptKS8Sao/o2jaYLMeCE4riHsRGfwBPmTsNnsj5mh8lxOiU9JXD5RMbZ
	 /3Acu9QXBR3eTwGFC8ji34UuSJak1xqw1d3JVYwL0+QEgdbwme35v6BSmAnIBAY4pj
	 cFNSIb3wdNib1NCwOQMytsWFMQpSyMbUrW2Gg4wxsZUiw5XnxkvS0F5rY7JbtWKshh
	 Xk2UKZplyTF8A==
Date: Tue, 31 Dec 2024 15:35:59 -0800
Subject: [PATCHSET 5/5] fstests: add difficult V5 features to filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783548.2712510.6440569474290843546.stgit@frogsfrogsfrogs>
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

This series enables xfs_repair to add select features to existing V5
filesystems.  Specifically, one can add free inode btrees, reflink
support, and reverse mapping.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-newer-features

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=upgrade-newer-features
---
Commits in this patchset:
 * xfs/1856: add metadir upgrade to test matrix
 * xfs/1856: add rtrmapbt upgrade to test matrix
 * xfs/1856: add rtreflink upgrade to test matrix
---
 tests/xfs/1856 |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

