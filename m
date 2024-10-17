Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24DE218D97
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190869; cv=none; b=QBSTCist9dkvV1QGdNltKJYsnv/eC2Jzu8QzJWmBOSH96JY4vqa03Au4+5fTO6zwogcfIcLTUr0I3LKiN1fpuE/0bigJr7YOCaQ79tgci5KohBiwXzjfe6iEW4JxtovQaclgzeiaUbtEjDSjiXiyap8UQu95OxYsV+78sxogvoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190869; c=relaxed/simple;
	bh=I2i1O0EJeryCEq2p56u60xm0BD/X0XqaiLHipuzT6GY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bAjUC9Uwf2f328GQ9lKY6FSYYhHXDbLOHoVypIbiW5bpTbWxhXKTTe+lpRaRnYwH52T0o4vcqbkjLd6WiolgKI84zH0MxFvp9yZqtBaI8cv2Mgzo5BH5was3UoGkWq/l/884DWKtEus+yGcdolgrb8L1Yfu846b1LL+fxLvQttI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtgVJhoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtgVJhoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312D1C4CECD;
	Thu, 17 Oct 2024 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190869;
	bh=I2i1O0EJeryCEq2p56u60xm0BD/X0XqaiLHipuzT6GY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MtgVJhocB8P1gKjvd3v1ojGXiyB2haFVH6rZQGbocrqaDRxFVGCXzsTLk2TD/bx9W
	 K5FbikOvBm4EkA3NxCF2GcLvupGTBgWcdrBWy4kyOsrDq9DNzOIqubj0RNO6ytwyGQ
	 V65owGko9+VkiPSSiQ8TYL7L/dT4CM00+m6YTaB+6K1F3J23gv8hAmYX4IyQHlV3My
	 XCFxYcQHBpZ1Vr+bvilNcDT9bUcI5KwIgzd074FsJ10wwvnJxovdulOwbIyTBjvJAL
	 RP+CoTSdg2ANFNQAih9MbxAh+dCDObd+bjKqdxKaeusyRURd2R+sZkKz+bKtlIhzq6
	 dW6LZV1sCP8pQ==
Date: Thu, 17 Oct 2024 11:47:48 -0700
Subject: [PATCHSET v5.1 9/9] xfs: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073537.3456438.5908736022117741188.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Actually enable this very large feature.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
Commits in this patchset:
 * xfs: update sb field checks when metadir is turned on
 * xfs: enable metadata directory feature
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/scrub/agheader.c    |   36 ++++++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 13 deletions(-)

