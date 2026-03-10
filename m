Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3641634D4C1;
	Tue, 10 Mar 2026 03:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114137; cv=none; b=WN9r8Vqfs2LL9d8OHWvwcPgrppDgnqcRMFGugWVe3lABnKhFc/u5BS5tUyNBKN7QT4t/8t75O9/mZ3oHqIEtas07CSdcAw9mIvFEaByJuYSKrBb/fMV0b/NXd6PjG77YpydOMYWBiNum1JCbUFOB8WCCUIjxqgCL5nrDP0Lw1lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114137; c=relaxed/simple;
	bh=SO04fnJ9dXwEdmsIdaIovUzM5+Jv2Bc7nR4LTEdp6QY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ghwp3r+BS7jX84Ya32dv2TMrBXjzQ7K5c5y2+SdxiBNOV+631mhJ3a4tw38nIay8YvmhUsA5WwPegZMnhtvODr4hniqTWSsHAT2NnG/IIR9I0iYhbdcl/4/JJq0V/xsaVsIZ8NOpJThUCFQGXbg0ScMpyX/zjXi0pCLh0SpBosc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGh4UJxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGh4UJxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06A6C4CEF7;
	Tue, 10 Mar 2026 03:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114136;
	bh=SO04fnJ9dXwEdmsIdaIovUzM5+Jv2Bc7nR4LTEdp6QY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EGh4UJxZMllxVJc6qsqWFVwlI241p7j0hnVahy9+ZFrtJ/vzH+8UUUbEQht2rDjCK
	 B0tiq+zIcKg6mHapFi+kzIwwzES6lcIgiJy71ShvQgTXaDTxqyO+uMZ63QpuY8/WOv
	 2lThLn2FARe/1lQXxdTbQy/bMZ/FIeN80yKjCGmfVRgPhUf2rsc07hFpEB2yzlmpHQ
	 h+RJNiPyIJf6K1g8jsAKk/wz9lpXG0+dhNfyf3H744BtZMHY1tb2yMQW/r4QiXUMTi
	 8c+OrmAnNdfemr96VKJ/uIDbGb2wRZXIzhrAT1DG8Ef+lmkiyeVRzvfMn6A0OdxdFO
	 BQS+n1Wg5DUtQ==
Date: Mon, 09 Mar 2026 20:42:16 -0700
Subject: [PATCHSET v9 1/2] fstests: test generic file IO error reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: jack@suse.cz, fstests@vger.kernel.org, amir73il@gmail.com,
 gabriel@krisman.be, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 hch@lst.de
Message-ID: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
In-Reply-To: <20260310033846.GH1105363@frogsfrogsfrogs>
References: <20260310033846.GH1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Refactor the iomap file I/O error handling code so that failures are
reported in a generic way to fsnotify.  Then connect the XFS health
reporting to the same fsnotify, and now XFS can notify userspace of
problems.

v9: tweak fstests per userspace changes; improve attribution of the
    generic fserror test; fix some bugs pointed out by zorro

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=filesystem-error-reporting

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=filesystem-error-reporting
---
Commits in this patchset:
 * generic: test fsnotify filesystem error reporting
---
 common/rc              |   25 ++++++
 doc/group-names.txt    |    1 
 src/Makefile           |    2 
 src/fs-monitor.c       |  153 ++++++++++++++++++++++++++++++++++
 tests/generic/1838     |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1838.out |   20 ++++
 6 files changed, 414 insertions(+), 1 deletion(-)
 create mode 100644 src/fs-monitor.c
 create mode 100755 tests/generic/1838
 create mode 100644 tests/generic/1838.out

