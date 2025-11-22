Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B61E1A05
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 10:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763806125; cv=none; b=XhoT4EIwVg0cLPowMOuPLJWS4zXu0gmI8cwurxI9HMuIV6+iGQaABrASDT4c85JGEj74NoISwEBRPQSPHkqyx/VncTFZsaMZnbrjZV+7BsO/G1zsbb2gsdSZHJBUAdneuZ/D4RafZJUySEhLvKHMh7nGnusQ1UM08dtZhvOSGaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763806125; c=relaxed/simple;
	bh=vPNJD6UkQ6IPjRnhM1gSUAhZLlj34G/z9IiH+aWPTHY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nUu7MGhJwj6bXUUd56iLPRqx4QBZO+ib1Of1+9bkqkNS9Sy8NcFAdgIuOWLsLVwVuFUKXgywuDwlLM8bqGRVnkhFwvjJdWVfQ/A4s5BQgF4L/YkLHlOpeipzJQ4EaFb2mu7bWLgCIBRA9rDnR3m89wrPotv1bKmqRorw7d4ksrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzPrm2xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzPrm2xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F093C4CEF5
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 10:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763806125;
	bh=vPNJD6UkQ6IPjRnhM1gSUAhZLlj34G/z9IiH+aWPTHY=;
	h=Date:From:To:Subject:From;
	b=hzPrm2xW4jId8DMfG6GHeXCnEwITKnlFQdiN/wrVQ5ZhZJsc6enr1itrd2wJVTnbP
	 vE8iEgu5EnMuKYTrQhAc6ETXnPqGRZVs9c9GkmR2C4mOmKixJEo8g0wac/cArvOITg
	 +EZYXmzdvemfgLMHg7GOh9Q/Z8WLgdmayMzerylqT7CGb3zZvZJZGXgZ+4rrWCH3wV
	 B9wfu8R+zKejrlT5Lh4L8xkwdvsC5/z6nYW1aqTldCZe+8KbTY9z3WU1FzToqdtRty
	 Nj4P0f0vsWJ3JEW6FhHr8G4QAyRk3iCxcI2YWoZDYUmrDauhlslTnfPLaO3slOJ2+G
	 C17SUNt21JO+w==
Date: Sat, 22 Nov 2025 11:08:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4bfaed64a12c
Message-ID: <j2dx6ow54sev5pe54h3a4brxbmzw5rv3t2nb5ian5dbnfltabg@5bvzftyy7ipt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

4bfaed64a12c Merge branch 'xfs-6.18-fixes' into for-next

3 new commits:

Carlos Maiolino (1):
      [4bfaed64a12c] Merge branch 'xfs-6.18-fixes' into for-next

Christoph Hellwig (1):
      [1cfe3795c152] xfs: use zi more in xfs_zone_gc_mount

Darrick J. Wong (1):
      [678e1cc2f482] xfs: fix out of bounds memory read error in symlink repair

Code Diffstat:

 fs/xfs/scrub/symlink_repair.c | 2 +-
 fs/xfs/xfs_zone_gc.c          | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)
