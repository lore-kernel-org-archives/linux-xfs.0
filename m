Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA52622339;
	Wed, 13 Nov 2024 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461813; cv=none; b=QKVT6JR2uIa3y5+9wg2WKNuUbq91pVfByficzzO1kZAe13o1EZ0PePeR6lmH+4lYzG0X6vBn4uaw9qJIfE6sH4fhBoPm4ZWtRXt/M++Asi0EOYCdlYGneuzprA5RGdw4/icv9apd9yPe3zMunhPUQoSKnbrbMKUsLqv1FxttCpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461813; c=relaxed/simple;
	bh=aIp3du8Slh5IR1xMHChukRd8Cc5m/LFjBertlfVQDjw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=JY1L9y/g1PYb8GoyL2S9ohI9pfRwIAqT5PNZkKvEOPOwQGDEhjAYYWKBmKLDNYhbJSAkcsJUq7CMDCEVBdJ2s6/HlgxtpdOGCgafVJDF4xS2TsODk19Bxymwf6P4JbvK6E7UaKnsRokRZETa7KRELmoowibYH0Y3z5zebAsbHjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5mmRn+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5mmRn+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0ACC4CECD;
	Wed, 13 Nov 2024 01:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731461813;
	bh=aIp3du8Slh5IR1xMHChukRd8Cc5m/LFjBertlfVQDjw=;
	h=Date:Subject:From:To:Cc:From;
	b=b5mmRn+3pX1/uzHhPyVUjotloI6DSocAufmCUFU1/I4AwxENBEheATGLVMX54YpSC
	 0ESBPdX9DFN2yzGtTfTaNJYJs40Q07e8iqLw/ldBpFjA6g8pohBPlJ/JUf7FO8DhZm
	 feZLY3HEuMAFVxqU1dNEDvk8nrWPWQY9xd7hnhwBt+TxSMlhKNiuYMOQj/af9SOF3M
	 /Pu/XkUXmjTZsXJrshr2AKIio63jRWfqJkd89qB4usVFnic/2unk44IwIrang0dAst
	 bW6SYFdjOXAlcx2AUYx+IDBjZ9OUQWEp2dJ6oYPrmmYR3FoHkqQGdkOA08M7M+NMjk
	 N/Fj5/62zV1kw==
Date: Tue, 12 Nov 2024 17:36:52 -0800
Subject: [PATCHSET] fstests: random fixes for v2024.10.28
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes that have been aging in my djwong-wtf branch forever.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs/273: check thoroughness of the mappings
 * xfs/185: don't fail when rtfile is larger than rblocks
 * generic/757: fix various bugs in this test
---
 tests/generic/757 |    7 ++++++-
 tests/xfs/185     |    6 ++++--
 tests/xfs/273     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 3 deletions(-)

