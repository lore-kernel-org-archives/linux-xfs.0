Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504893207
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053188; cv=none; b=X63axLltK8vPHHmLwOwbZPGs/MF5sYY0bMd/DDFdXWd43twkrov7UPG38Jsml7VguSk32HN7gJ1o9i+Ls+7T2w/uMMIclpQ7c6C1ZAzuktehRPKKB8sSRmQCMHW8P5GE3BFc4IaNq4iW5ZSlouoi6HrsysN+lN+1DiAd9WTBRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053188; c=relaxed/simple;
	bh=LvDm0eCuF/C9fpeBVwNDwL3F6B6KwQ3nCBAgNDPsKj0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iO9EiBjCzxOu7V7smCYwk5wsExkfU+SEj+/QtB3GMDYL69Tewt0R4Wej9+AJgC3rt/BMadhvFdREXpy0EJkcOh3HXQRWKtC4cAL+owGBF6e6qlFIjozQBU9ifBk7ywH0aLs6bOHPaCNJgfaF9OxGI94bJa/lHH6NHf5JXnuFpl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5IZu4Tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5IZu4Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC26C4CECE;
	Fri, 13 Dec 2024 01:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734053186;
	bh=LvDm0eCuF/C9fpeBVwNDwL3F6B6KwQ3nCBAgNDPsKj0=;
	h=Date:From:To:Cc:Subject:From;
	b=i5IZu4TtTnycMkJC4QA8rHhn6qYBPvRYgsJzYSM+Tc93L0kYf+7ev37zRZChnRtcT
	 neNi3Rt+TeY6fm531tZe+SdQt5E9spkl6oP1WPQGYv0YNCLypfTr5hPKt2/D0maXrz
	 wKFH7nQSkaVZWgBbJvAL+JVlQNvbCYi4o4xF6meefPYxokqVOrVJT90kdIQ945aYsf
	 xZNOr7IamZjnkktKlCQxIhfHgwGqOA9KCzNX3exCbxdnqGWBb4Zt7t1WnsRHje7IgJ
	 SfI4qUvMKExPQn5KJhgvvKXN83BwAsgzA/srhOhGrcg5mEppJP60Uo1Rz4pYh7MUcS
	 +2sDtxSB6JzOg==
Date: Thu, 12 Dec 2024 17:26:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v5.9] xfsprogs: metadata directories and realtime groups
Message-ID: <20241213012625.GB6653@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey and Christoph,

This begins the second round of review of userspace support for the
metadata directory tree and realtime allocation group code that was
merged into kernel 6.13-rc1.  I've added all of Christoph's RVB tags
from last time and made a few corrections and adjustments as noted in
the replies.

However, the xfs_mdrestore patches have expanded -- now there's a
cleanup patch to add the mdrestore device instead of opencoding the
fd/flags parameters, which changed the patch to support mdrestoring rt
superblocks quite a bit.  That patch never got an RVB tag, so that's why
there are two left.

As always, you can browse / pull the branch from here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas-6.13_2024-12-12

These are the patches that have not yet been reviewed:

[PATCHSET v5.9] xfsprogs: shard the realtime section
  [PATCH 34/50] xfs_mdrestore: refactor open-coded fd/is_file into a
  [PATCH 35/50] xfs_mdrestore: restore rt group superblocks to realtime

I'm resending only these two patches to reduce pointless retransmission.

--D
