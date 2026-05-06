Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEE33F7888
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 12:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778071303; cv=none; b=blx1Nxc+lHVtoBa6vmnosXl94LEFbPJOtQYlpW6/AEMTaLBsMo0b4V5S5dBJ7APWNTP9OUdgLphCs0ykhNyjdl1V1G56v3cNe5bcuT/yD1hwcL7eq1upNy9KPwLY9Exm5TIxUCZ1MEJ+nxREVEkgzbOjxBCQUWZIzc5sHVKRGqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778071303; c=relaxed/simple;
	bh=x9juBOyBe00W2nxVHN0DGinv7DcHoOSpL8Wxmu4nJHg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SQ4gacs1fUzIiAlv+ib/V/3drZQVhfKpDdk63O151CYWJSqQcJvOYWsfRGPGLoKYD4qUbZ/BV3jR57VWgWuC3GswlxroM/9xfM/YO7UvN4CeBzYFjbSbkNHo8RZD/yBvYB1nCvXtPOfD7gSdDJ1aUkauN1bNIZDNsoPwUXI1RA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dM8+d/qb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dM8+d/qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985F3C2BCC4;
	Wed,  6 May 2026 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778071303;
	bh=x9juBOyBe00W2nxVHN0DGinv7DcHoOSpL8Wxmu4nJHg=;
	h=Date:From:To:Cc:Subject:From;
	b=dM8+d/qbHvntzp3ykT+MJcKgdsJDt4nKi/e54MaNO8916B7SVwC+kgE7nhtStfGQc
	 c6Sc1BCxvDdVzi2XThI6L69cUwXcJisxixUXO2mdxgaW8y0l6cN6YHmUdK+Zdtt5zD
	 Degj+VOVSIp4yvmpCu7FU3rNO/88OTOAVbV5bfR1weSfFSKcGXqlqlFA3vfH29QdBS
	 DU+KRPqcI7+fXIy1ySjnyB7IXqDNiy1FT6NQLoRzmP7ZJnS5sOCMODXz8CIDgGLvdK
	 NeqSOSBrK1gOzPWfv+p0rc5KbHqBXc59c4yHSTneslUieu6bxgxvA+tjfRU7mF5khc
	 AYdFOPggf/4VQ==
Date: Wed, 6 May 2026 14:41:40 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, ddouwsma@redhat.com
Subject: [ANNOUNCE] xfsdump: for-next updated to dd63de5d42e1
Message-ID: <hlv3kpux5hjdbvdjehpy3mqfyo2ik2upruurcx4pejazystgvl@wtq7aijwoofn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsdump for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

dd63de5d42e1073c09314fb1afc82c55e91c2853

New commits:

Donald Douwsma (1):
      [dd63de5d42e1] xfsrestore: only process subtrees that are selected

Code Diffstat:

 restore/tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
- Andrey
