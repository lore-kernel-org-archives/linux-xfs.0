Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B261361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298886; cv=none; b=WBHSek6ZaiSMo7hxlhGh7+i6HS9ahlHLCnb348Apb9YzoVX8Vv83MMk0nsTT5DGZgJ5jrE9YbS+O0UrShjxOaMCn6nhm+c0GcDtmHQ8cYZgNrp2FJSBSw2koEsQ+fau6wcZOAP9c4w8KWyMc10NykuwiRTcUN1Ub2lVIjJQyVaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298886; c=relaxed/simple;
	bh=m/TfUcVzlAfqnfT4nuDLYsHpWPAxge8MXSY8hE+Ej4U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/e0x5SOKC+7HwS74mD2D2gr/jRG0uPJx3wk1Nug/8JNKh8Ta6TrnwbJ8FMAHDPusMEp15QthJVLhLqf5Y+M8ixjWV9DBCc/wgepRMCUOY9fBtyUZFVoJ0O4AND1sGA04U4IvI3TrJpGkAjft9mliP+iC/rQyp4TUTCHejvwUtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIh9teeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIh9teeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC1BC32786;
	Tue, 30 Jul 2024 00:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298886;
	bh=m/TfUcVzlAfqnfT4nuDLYsHpWPAxge8MXSY8hE+Ej4U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uIh9teeZfQzJnaGDgbEauVn6Pn/1KffPqOOt9BespLQFkXI/ClL1oHnkD2hBUmanG
	 EShGETnLOkgfDDRZpLTgDNuzmbAEaWmDaA8ADQJp08FfXPkYKWdGb1YqQdthhT3jan
	 9Qs60cqcD/NcPMuLW2Xn3I/8rre4A1N6mQBNXib7pQdLySxGop3KnLfvyj+NtTUJm5
	 PQWixixIm1ML/uJHqQuibyY2Gld/qzeHcaFYKbnrmHTXscScOyGYGBW/8H9NGW4TWe
	 vV7ObUonNfFBICOKW0O+H7f4EgamaWqwgEPZevtOUwK2IFcV6kQFuj8Y3g+lV3P6+G
	 k+7Z+VjParO4A==
Date: Mon, 29 Jul 2024 17:21:25 -0700
Subject: [PATCHSET v13.8 19/23] xfsprogs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851139.1352400.10715918413205904955.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

Teach online fsck to use parent pointers to assist in checking
directories, parent pointers, extended attributes, and link counts.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-pptrs-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-pptrs-6.10
---
Commits in this patchset:
 * xfs: create a blob array data structure
 * man2: update ioctl_xfs_scrub_metadata.2 for parent pointers
---
 libxfs/Makefile                     |    2 
 libxfs/xfblob.c                     |  147 +++++++++++++++++++++++++++++++++++
 libxfs/xfblob.h                     |   24 ++++++
 libxfs/xfile.c                      |   11 +++
 libxfs/xfile.h                      |    1 
 man/man2/ioctl_xfs_scrub_metadata.2 |   20 ++++-
 6 files changed, 201 insertions(+), 4 deletions(-)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h

