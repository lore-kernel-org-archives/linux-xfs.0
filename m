Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610C5521210;
	Mon,  7 Sep 2026 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799264; cv=none; b=G3bdNTWrlvvylO73jDFp7PSh7GXIeyov3Tkdpttxq5LZtgbmkfiSCe9e1OQSmO7gn5mf2Lfc+i5PyArzQ4xPLnIfl2g2YHYzhF3jqLmOlbjYY/rWNATa4nRhlb7HzwpkJlDC3fUy89N0f4X6xePwBrHZU7SmIMGJ25BYg2mJvUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799264; c=relaxed/simple;
	bh=mQiqwLKEJ5W3K3lTz7fiMdtc1OXRE0HtooqQQOKdjFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b7mUHMNVzejaDSpJtbCSV7/Stu80rEgloD/9xPmUq7SbmJA/5OebGsAOKeaQHtYPGUeSJmEslNLIYLaBHaq2ZVzP/SVV/to6jLZmvJhCnbJ4XbUnQvLn+ijxRhvVbOQAvNOzKik0075HbbDCwXGgJpNB3qkchYZqDmgPnrq83tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5aoUU5U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5aoUU5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61CA1F00A3E;
	Mon,  7 Sep 2026 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788799263;
	bh=bhg8IRTsTsoKRQYjbbncc7qT0no3Afqs6gOto2X0MIg=;
	h=From:To:Cc:Subject:Date;
	b=E5aoUU5UbLiw+qU34Tbd0rqT1vibxRcFpfWRT2PJe+gbsBwdF0lq6yTvuQ8L14C/D
	 nUwzYbfr4DqUe7U8j0zro7I5PT5PmlNwcxcu1QDBrJYuDT0I2/ogrcOP5eHaSNfeyu
	 lbBNxdQY4c0w/lBLXB8r3B46ZV/skWYZvkjpkuR+phYhyOewK7IuqR7aSJdPQcguck
	 EMrSPj9zleqLA9ogy+iJt36KlZ/ftDmABrra0NunonEkw73Hka6W1kVSGdJ/29hGef
	 51FufFScZzX5IJNQjsX0u0zoRg1oBDRkTSZJPk4f/uVzTIgnw9tLvVUMlUSJmClh2M
	 vYhFig9AROaHw==
From: cem@kernel.org
To: zlang@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	jack@suse.cz
Subject: [RFC PATCH 0/2] quota evasion test and nfs helpers
Date: Mon,  7 Sep 2026 18:40:46 +0200
Message-ID: <20260907164054.111393-1-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hi folks.

I'm flagging these as RFC because I'd like an input in the approach I
took here regarding how to setup a local nfs-server to reproduce the bug
recently fixed on xfs quotas.

The issue is regarding how we checked the credentials before proceeding
with quota enforcement / or not. And due the chgrp() being run through a
NSF share, xfs used the wrong credentials allowing an user to evade
quotas.

The TL;DR; for the approach is:
	- setup a xfs fs with an user belonging to two groups with group
	  quotas enforced
	- Setup a local nfs server/client and mount it locally through
	  loopback
	- use the user to fill in the share until it exceeds quota
	- change group of the file to the second group.
	- repeat a couple times until the second group quota is
	  exceeded.

I'm using the already existing user/groups. The tests uses exportfs directly
instead of seeting up a exports file, and I added a few new helpers to
start/stop nfsd and rpcbind. The latter I did as an attempt to make the test
systemd-agnostic. It is working even if nfs-server systemd service is disabled,
but I didn't try on a systemd-less OS.

While writing it I stumped on a weird issue that I'm not exactly sure
how to fix (or if it's perhaps a bug on umount):

During cleanup(), I umount the share and unexport the it so the rest
of the generic cleanup can take place, specially umounting the scratch
fs There is some timing though required by umount() to properly cleanup
internal kernel structures before it can be unexported. I honestly
assumed umount() was synchronous (unless lazy umount) and once it returned
it was "done". But for some reason I didn't dig into, I need to wait a
bit between unmounting the share and unexporting it.
I tried to wait until the mount was excluded from /proc/mounts but even
after the mount is gone, something still holds the share a bit
preventing it to be unexported. So I went with a 2 second sleep :)

Overall the test works, passing on a patched kernel or failing
otherwise.

Comments? Flames? Stones?

Cheers.

Carlos Maiolino (2):
  common/nfs: add management helpers
  generic: add test for quota enforcement via a nfs share

 common/nfs            |  55 ++++++++++++++++++++++
 tests/generic/803     | 106 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out |   2 +
 3 files changed, 163 insertions(+)
 create mode 100755 tests/generic/803
 create mode 100644 tests/generic/803.out

-- 
2.55.0
