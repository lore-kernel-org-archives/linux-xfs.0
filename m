Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CB9C138
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346001; cv=none; b=OXEWkrHYTWLPiFrDyClcjaAGmrTQ4/Eer5SrSUgQmX5szI0/aLQ8Dmx3jgxTlNeUvfzKvXdu8RVemjW2SLtNLbp86O9pOvRluNkSmk3MntWBlUC9m21ZN+zNUAxLH/g4XaOSGVQy6vNIrmGl5AUhpGluZQcW20Le74Nhs/cKQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346001; c=relaxed/simple;
	bh=57HospvtqtXG+MicIcdWjM2gbRpjB7GG6MBniRQrzFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/die300ObJTHNC1GThqJqDSWgLtnnR45tIEPC7fMnWtjs+NfEsI+8Y08NSZO5sw41Q5jY4TCnhyJCM7mhOXbnQkJbhd3LsDPIzA7MxVTUab966DQ87jvyNNzxRO8c4mchDW/iXhIQyZ434gbqJvlsPUlZgC9R68sNihp4WukqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppiDwT2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppiDwT2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33611C2BD11;
	Wed, 22 May 2024 02:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346001;
	bh=57HospvtqtXG+MicIcdWjM2gbRpjB7GG6MBniRQrzFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ppiDwT2LXblGT+5YT6t0EOK8/Q/a46cn/StHt99srECG7k6uLOv53G7CBlu+pwqb6
	 GY3HmhpQnVYKMGLyBuP2hNIoEfdjLt3hGYLfNk6FTX9DhRBEOYkI/mXCNEaaGxMoHN
	 VQREIby80hcQuac76djQ23WKzqMp4bJM6PqO0H9oEJ5RDNEm6mlAhJiLmWhwPZu0cY
	 YFog017r4SvvzYBLZhypgF6Pcz9AZl+9IVMuYpOv3q4w+vJB1FhEgKVxeRL1OKL0ug
	 EDCZ4A3INwm98Sfl1n2088ZptoX35erhqrDqY+26AHAKgX1eVp3KgmAJY5dVEtE4Ib
	 P3of21ReaqrsA==
Date: Tue, 21 May 2024 19:46:40 -0700
Subject: [PATCHSET v30.4 05/10] xfs_spaceman: updates for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534389.2482833.12547453553760834310.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
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

Update xfs_spaceman to handle the new health reporting code that was
merged in 6.9.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=spaceman-updates-6.9
---
Commits in this patchset:
 * xfs_spaceman: report the health of quota counts
 * xfs_spaceman: report health of inode link counts
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    8 ++++++++
 2 files changed, 11 insertions(+)

