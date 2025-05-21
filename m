Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB304239E85;
	Wed, 21 May 2025 22:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867254; cv=none; b=MC6537UOOfngk2fctjBzEbG3c7/gSbJcV9QLZyLjjyYjYadEG0jGxD/uc2RJmpHogD8axyCevSzMGdg3DZPpEY0+m/7PSyxhJtqJM5KocsEWjOKc5YbM+NHjnC2eVJUbok2BpnDhUPD3mjknRV594wW2Vz/OiA9PLfNftH8kbt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867254; c=relaxed/simple;
	bh=86tXlADGD5RBxV5ZsxyHFoirFkv39IUO7ivO6EnBZMk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=dc9AR1EsnQCMyrZxnQ45+wRsKsOWWTYhT6rmViMgqtHHKi0B2d53gMdO34J2sHwtI8qEqXIMqsC/5fLAWFdgimrpys/Cs26sJfYpOOVzkl+nK0nxkutSdENcgddtwj74LmLWXDmjlIbMEiJ4tA6TJWOIEXexHREiJb2sIGnKplg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ab3XzyDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ab3XzyDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1494BC4CEE4;
	Wed, 21 May 2025 22:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867254;
	bh=86tXlADGD5RBxV5ZsxyHFoirFkv39IUO7ivO6EnBZMk=;
	h=Date:Subject:From:To:Cc:From;
	b=Ab3XzyDDmpsz+OMQLFE2EH2kgfTJEPFrqRbZqtQ+Vnzx7wsWNHNwScyGjLoVl14ph
	 JO05iJ70GdNhjr64YWNyf9guN3PR8vNbFebG5WTuOSJYR2wSU9jLwi5IUn8Xxtxwu5
	 hHWLKXDx8Im8Z04Pm6wUTGElCi4adcE4S+ATBf0Ixhbmis8XKZMLLBMlj40P0vTJCM
	 /VeC9zlJbIpJJ+OC4EtPn6CxKxQ8kxt7IPk1fJsVUSRAcwFYs2QllZXrdnWGtZetIa
	 bL4ehAlYnNUM3tyNbYY4hXynvjsY8AgGLiVTf/k7pL3t6Q/cVMHfVvCMS7llOkUC6S
	 WyffVrKxaaWLw==
Date: Wed, 21 May 2025 15:40:53 -0700
Subject: [PATCHSET 1/2] fstests: check new 6.15 behaviors
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Adjust fstests to check for new behaviors introduced in 6.15.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=linux-6.15-sync
---
Commits in this patchset:
 * xfs/273: fix test for internal zoned filesystems
 * xfs/259: drop the 512-byte fsblock logic from this test
 * xfs/259: try to force loop device block size
 * xfs/432: fix metadump loop device blocksize problems
---
 common/metadump   |   12 ++++++++++--
 common/rc         |   29 +++++++++++++++++++++++++++++
 tests/generic/563 |    1 +
 tests/xfs/078     |    2 ++
 tests/xfs/259     |   25 +++++++++----------------
 tests/xfs/259.out |    7 -------
 tests/xfs/273     |    5 +++++
 tests/xfs/613     |    1 +
 8 files changed, 57 insertions(+), 25 deletions(-)

