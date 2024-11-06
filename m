Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074F320721C
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920641; cv=none; b=OzvbvRXY5pEaVbOtb+8eJRvfcSA5XR52I0eh5FhDfOCheqveCag23xKtS4eHuinhv0/QW0eJL68X3e07S1w6YkF5ld3tm5QbJzdnjmvDSSPSX+0UzR0cwmWyOHewPqdYwAe9WNdCYg8UBpTeZeoKRd5o6raMBbJxySN3E9GimOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920641; c=relaxed/simple;
	bh=ko27XNa8fohwjdupiz8dPRm87JpmiBQmyOuo3R7IZak=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1MmG6kSspoq0wzTLjhFRrWmK8Fly9k6KVYBBDb/mvJc0A8oTQ8JLXTBZ5clenkrcdvj9gJKbuQCZyKqEfg88AjK4SFncFDlXQ0qrK1seQddWt7CeAyJcD/YZGVWhAnxOtF67EwQB0bd9EGyzL7hwXmD2mRZt2mma14k+PUivbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4pafq2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4pafq2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95151C4CEC6;
	Wed,  6 Nov 2024 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920640;
	bh=ko27XNa8fohwjdupiz8dPRm87JpmiBQmyOuo3R7IZak=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B4pafq2hZoCncVODY9MgYKelIEn4AJyb9t1aMe7+mvS435UlEEHCHaT+iLrsceZ9I
	 mnZVvep24LEu5p0lzqn0eZc2qUEXwJNuQyehep42Rbfd3nZ3apUG4rozXwYYCgI4EL
	 Fd/H8MHb8O4iBUzPrbyZNrZFxXZJ4uikKkredDJnUiJIFj2RNHOOGCE0qD+VZ2KHdQ
	 51bxDLG+AIEPdPMp8mypD0SugObrfN9Z1t2zJ1+fPG3uNXic6Pz3TzvCV8iuPoqcgX
	 2QJSZJYUhZJign+884O9pZ2C18h4X4fssV6tpTAuhW4reeA8paV9kJlhyERaAZao+F
	 haTomceL2FeEw==
Date: Wed, 06 Nov 2024 11:17:20 -0800
Subject: [PATCHSET v31.5 1/3] xfs-documentation: last few updates for online
 fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs>
In-Reply-To: <20241106191602.GO2386201@frogsfrogsfrogs>
References: <20241106191602.GO2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Now that we've landed online fsck, let's update the chapter on metadata
reconstruction is supposed to work, and document the new filesystem
property that we use to control it.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=online-fsck
---
Commits in this patchset:
 * design: update metadata reconstruction chapter
 * design: document filesystem properties
---
 .../fs_properties.asciidoc                         |   28 ++++++++++++++++++++
 .../reconstruction.asciidoc                        |   17 ++++++------
 .../xfs_filesystem_structure.asciidoc              |    2 +
 3 files changed, 39 insertions(+), 8 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/fs_properties.asciidoc

