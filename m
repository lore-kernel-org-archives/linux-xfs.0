Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E13FBEB0
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304748; cv=none; b=AQGAO3YxhIwkOpfXYrqz1U+t8DO3Q7xupFLgYv8M3163orj+WKB3pX3ObEuxZ9Nf67IOyyw8YFRrmHSwz6fqb9fwDsVofMLcjTmqZjDjh42qSdlREBZGmGL94rItlSIO6fL/Uy6kgbzvfufyja6nDnNLjiLp1bJip2OgjA5ygwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304748; c=relaxed/simple;
	bh=Id/lLJtK13+r2DGb8+/4JDb90H5mKKjpmZGDpaY58XU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sRjDgdrqyd2zv2kkYForJ7i5s0LIKcLUC6rlR8g8mWte/jZiEuTFwduzIDSQHJ7s3uNAhXeilSdGFGE5VkqcbPPqaoAerlOrkwkzLSebc3Gn8aTofzXArsvz36BmCbQ8n3j+l9yChIabDyBSTbZBpZTB3NksxK+3elfWf/PZbX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A33z1fTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A33z1fTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A131F000E9;
	Fri, 17 Jul 2026 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304740;
	bh=y8qzP32H5AMFK5r7x9b3Ym7NQjiHox7SyWE6L2xLNus=;
	h=Date:From:To:Cc:Subject;
	b=A33z1fTM0918ZZiLP6/Ccb+uF92aqpFykvqs61l9V2CuNgquo5nEs7laNICzNfrnd
	 jLaELPmFATCUc3Q/usJ71TMzdNC/eOZa8HMCxgUg07LLH/FY6E+LHyNg2g8BLIMBt4
	 kxWc2/5N8HFJnTVnR8IqSg5mIqKO9iUH8EjoVstNOgWiYHnbH4l+0iVbc8z3BT5TTa
	 j28GZBTiiCkAjb0Rpvp6r4DqL7UHKdwdCejC1QDXl1Qt/XizDM2CDgjWLmIfSgpxJF
	 wA78vsJltpbqpoJUELtn3n5HcfqMk+EP3F9bafU4bjmLeTzf5CwKfri01CkfhLlmnU
	 eIiUcjEzJFc2A==
Date: Fri, 17 Jul 2026 18:12:15 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, msinguru@redhat.com, p.raghav@samsung.com, rallenh@hotmail.com, 
	yi.zhang@huawei.com
Subject: [ANNOUNCE] xfsprogs: v7.1.1 released
Message-ID: <alpTa8x3zWfuSAvK@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is a quick follow up for v7.1.0 with a fix for xfs_healer build failure on
some configurations. This release also includes fix of spacemap for data volume,
mdrestore integer overflow and a new option for fiemap.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

35d1a6ff4eb4d5f26f415ae71461f90ac24273a0

New commits:

Allen Hewes (1):
      [2525ce2aa93b] xfsprogs: healer: install targets one at a time

Andrey Albershteyn (1):
      [35d1a6ff4eb4] xfsprogs: Release v7.1.1

Darrick J. Wong (1):
      [ee7dc67a6aaf] xfs_scrub: fix spacemap scan for data volume

Manognya Singuru (1):
      [992ef0086051] mdrestore: fix extent length overflow in v2 restore path

Pankaj Raghav (1):
      [ac14db9cd430] fiemap: add a nosync option

Code Diffstat:

 VERSION                   |  2 +-
 configure.ac              |  2 +-
 debian/changelog          |  6 ++++++
 doc/CHANGES               |  6 ++++++
 healer/Makefile           |  4 +++-
 io/fiemap.c               |  9 +++++++--
 man/man8/xfs_io.8         |  2 +-
 mdrestore/xfs_mdrestore.c | 12 +++++-------
 scrub/spacemap.c          | 13 -------------
 9 files changed, 30 insertions(+), 26 deletions(-)

-- 
- Andrey
