Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA6F219ED
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711503995; cv=none; b=WawXXBcdPWoZAAJRgb+2FAEiyhTpY3qJgnXgi1hXt2e5DQixVIWo/28Xt6IUep7wMJ513B0HEVg9O5u8eFAMF+gCSzpTqCC5KXXV5SEHTwtqdoWJFPepEPjWhAPQF1LnEhCamnmCYvNGxBdgvJsJQVSAISwMlCjISLs6RK3YtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711503995; c=relaxed/simple;
	bh=iWU5RGJw7x34ztc4ystKGdX0o3PTENMtBr62YfjZtEU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n0zf2g/FizHSVynL+vhi008K7dqu3i7DiB0YyEr8NWjZNI+dcYRmizUN+v46qPzH5jIhftjwojumPKU6RCn3aq7xmL4uDGW6IW7NlzMFJVOFiYAYC4Sd3toZkEFMBtCkbotRrrpJ+udi+Tum4DUgQCycF4ggEiULVDuPDH8mamA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APkGyOjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APkGyOjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971A2C43394;
	Wed, 27 Mar 2024 01:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711503994;
	bh=iWU5RGJw7x34ztc4ystKGdX0o3PTENMtBr62YfjZtEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=APkGyOjqNhepAbdsTz/mPE0Gt3r24Kci4wTZ/DDky6bmOvyyizsvPvSCw4o7EwPaM
	 0XMWWfTQ9ZyOG68bQWsdGgtkzu+gmA1a9mAJRzWzILB0Pgjo8F08+iZbnlrxWFgTkI
	 4MuOrQw9MEMeOZv4Y8WpxaYMrWmAvo7McUT8JEPhqYksBI3q5AxsUy+ZF6dOBbuvKm
	 u7aU5sYuBiP8KLXpYfy6lF4caj2SnqrCS1QFixD6z/TzR5OPA66x2I+NtVLNtC3JsK
	 o5yP4zVLh5J85RM4x620Q7vGywn3iXLdPyIluItFrT5ENjJ520RF9rxSL+I58vxrvB
	 tn4Run5QRNXvA==
Date: Tue, 26 Mar 2024 18:46:34 -0700
Subject: [PATCHSET 01/15] xfs: bug fixes for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for XFS for 6.9.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.9-fixes
---
Commits in this patchset:
 * xfs: fix potential AGI <-> ILOCK ABBA deadlock in xrep_dinode_findmode_walk_directory
---
 fs/xfs/scrub/inode_repair.c |   48 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

