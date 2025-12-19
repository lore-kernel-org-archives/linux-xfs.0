Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69222FE577
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766137359; cv=none; b=qYE51zh1EIYiwfp2A+aEelZNcKG5oAQ86bsfk2PxMaCpN7bJgphZ2hkikosqh6Bpm/0Pj3RyFnV3X9cS5iIASkd0mnrHShv+IPlzzr223aHy6ZhOCAuyM+EEv5EHg9BxGo36TFdesh6WZw+yUcN5qXxtLg1HVmh5uMiq9D/AfvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766137359; c=relaxed/simple;
	bh=By2o4Xzz9yBEgFwGGR1uFTD5DMpuJPpQaRTEKU5iuQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ESPet+3lkXCRnOu1jdvnEzBp5+nHmeFq1cMe2pTkn5wGj6HJ6I68rvJVv6vCc1TylaEYBkbHqKvceU2C4HzsnZ0UzvSCYPbj9Q17S6Ou7QCcYVKUKBiaPOGHYvM3+mniMcKUYLxKMO0n9X3YLGbvZEaZI3e51LWaAERVE2sM6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtKqwzpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtKqwzpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2C1C4CEF1;
	Fri, 19 Dec 2025 09:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766137359;
	bh=By2o4Xzz9yBEgFwGGR1uFTD5DMpuJPpQaRTEKU5iuQo=;
	h=From:To:Cc:Subject:Date:From;
	b=RtKqwzpBJbCmM+JSnG9XLLojoz97YyKXnY7f8A+DcnYjbfbKPqVFuO7ZBpzhwoIUE
	 9tr7ucoSHqKnLBCrWKukvmdNh0aTMvhFZUxhpLM0eEvNVR0m+TyJCtvV2OU2hjMImc
	 q9+XKfGqJGtGhxrhctxXU79zs+2el3IdFS2qOoQtXGOrUh1WUFZtapZXKoGzJvgz0v
	 xJ79XOoiB026iMGQwUdTSPuBVlpjbX1H/hIrVPWYTngG1OyiZbnLXHaH6SDXC5KNE8
	 k8qzKRTvdCj1MbJUoQcBUYl21ylEyiaqXlpGcHZBif4rLQdlQeq5PWqwMEK0kTYhfN
	 GtIAKVVMmks3g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v2 0/3] Enable cached zone report
Date: Fri, 19 Dec 2025 18:38:07 +0900
Message-ID: <20251219093810.540437-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable cached zone report to speed up mkfs and repair on a zoned block
device (e.g. an SMR disk). Cached zone report support was introduced in
the kernel with version 6.19-rc1.  This was co-developped with
Christoph.

Darrick,

It may be cleaner to have a common report zones helper instead of
repating the same ioctl pattern in mkfs/xfs_mkfs.c and repair/zoned.c.
However, I am not sure where to place such helper. In libxfs/ or in
libfrog/ ? Please advise.

Thanks !

Changes from v1:
 - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
   fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
   support BLKREPORTZONEV2.

Damien Le Moal (3):
  libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
  mkfs: use cached report zone
  repair: use cached report zone

 libxfs/topology.h | 8 ++++++++
 mkfs/xfs_mkfs.c   | 7 ++++++-
 repair/zoned.c    | 7 ++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.52.0

