Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711653FE7
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556409; cv=none; b=JnCDNorUL7AnjkgbucfkQa/qTqq/fTivuPGGP+yildaNW4RzxT3/4ch3I1xz7teB4Y1mGWJ2ask0tghMAmKb597TcjDOSlHqBCajiZWFa3NzNZ3hlakGWKFdrseqBcVSixocwzk/bsg0IUtqwnp7aB63l5SMJGjHPOijs7r1ecI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556409; c=relaxed/simple;
	bh=mVfj/RN9CLrpM2R72nAOEUhMksb1QLvA2RTW6JsT0a8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b+3kcvUlDMoOTp/UhmgJ6zSY5Zo1CBbnWmrXOyQcOB3tHT0GtGmpLMguC70sjV1I6GvdAvw6ehjkEEihSfakS6eIgNb/OBQiO2XOR8GgK8OyuPhA5GBxBQImWL3LFScBn4YeOBu/Ng1Qot78Z1awLJaiHkPHPWX8JQftBVZhgqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFtdc1dE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFtdc1dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05701C4CEE3;
	Tue, 15 Jul 2025 05:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556409;
	bh=mVfj/RN9CLrpM2R72nAOEUhMksb1QLvA2RTW6JsT0a8=;
	h=Date:From:To:Cc:Subject:From;
	b=LFtdc1dEDDlta3ZWuqEKRowJklrkkDwZ7FzKWR7MvGGwftiz61sQs+xt+OeaUUKwE
	 WrRMj7aLjBwydGifo1Sp6FqH6zZ+pBNg60oA228nK8Wey2HLO8wDpa95ePsHTIHD0b
	 HX5NtieHG2RXNjQ/6uXPTwkASzHQ2BFPjlQjr2a/iD1QCbAAMa35Ty+QBDfe42UBW8
	 DsBt7JacLnScrEpo1b5CBgmEFIzoNUWNVOuGs0t7Bh5VYsX7D5t/db2uZb8LTkB/hE
	 5s+Dq90m3FFjRWZPTs4EFrzViUsElamsc8JwBjGjP5fQsleibVjUvdz/L1xO/nRXXD
	 1XURaM/ic0F0w==
Date: Mon, 14 Jul 2025 22:13:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCHBOMB v2] xfsprogs: ports and new code for 6.16
Message-ID: <20250715051328.GL2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is a collection of all the new code that I have for xfsprogs 6.16.
First are the libxfs ports from Linux 6.16; after that come the
userspace changes to report hardware atomic write capabilities and
format a filesystem that will play nicely with the storage; and finally
a patch to remove EXPERIMENTAL from xfs_scrub.

v2: add RVBs, fix a few comments as needed.

--D
