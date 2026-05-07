Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F943A1D01;
	Thu,  7 May 2026 22:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192594; cv=none; b=sWTYT+84WZu9tBd6uAN1VNSOkhZLLT9OpBvs9KDfpa5W2xfttTLU2Gs7WbYixkjP9kJ7McBkYAXz0EDuUf0mfMiBLy2XBoSeosgc58ptFp4vjW/lgapFuLahkukvTiYwYxaPLgs6APsGyfSHzOIwaRzkVidcCvQT9tStW9Vqd9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192594; c=relaxed/simple;
	bh=helN3ivINyLKIzVl1AZ1JxaY2oc5X9jtGmWNzvlcIfU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=FbY+kYUf/6QSGB9c0j/lSHtqBNKsWqNMzpJN0isOgIuQg6NPzVCzhlostBGExFzMeHFrSYlRz6RPB0vsAOMf4PY1Bo4g8QIYt1wYulAMMmu6LsyeSnjQ70nQPrp4SekGdus83YRUSm1jOfQWIHhj6vf/66rpZmmONfJTokcvY0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOeaa4/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOeaa4/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E962DC2BCC9;
	Thu,  7 May 2026 22:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778192594;
	bh=helN3ivINyLKIzVl1AZ1JxaY2oc5X9jtGmWNzvlcIfU=;
	h=Date:Subject:From:To:Cc:From;
	b=YOeaa4/pGYN9a1+DkMhATrpLTAO0nKU3SwETg5LTt9jfNM+vP58uybIv62DdRlPyc
	 D10+i+GZHtMKE7D4/NWuB44IYXN4+TOEn77PkCClfhYN70Kt2pj79TnuXJW5aprt2g
	 bdxn2pKrAx7vSmd11A8oFXWFNuhfNe6IC31pDIKGvAXvKtLsS7p1gCT2d/LgVeIie1
	 VaCtOgabYlESIqkjcOqhRGu5Alk6sQ53GJvgS/pxi7js3FZpJZvF3ph3j2u12jXs2G
	 ki9drCgQ6lC5xaGEfLf4/Vc7kNg/spxo8kXUiMQsSTkrYUAkYFx/zxI3ewxMG+5bbk
	 a/khLoUAhp9cg==
Date: Thu, 07 May 2026 15:23:13 -0700
Subject: [PATCHSET] fstests: catch up with xfsprogs 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: gedalya@gedalya.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177819254750.3505531.13966651630640194090.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Miscellanous fixes for 7.0.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fstests-7.0-fixes
---
Commits in this patchset:
 * generic/45[34]: add detection of confusable variation sequences
 * generic/45[34]: don't warn on mixed bidirectional characters
---
 tests/generic/453 |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/454 |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

