Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49CC19E99C
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 12:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725281662; cv=none; b=rM/YTdyDxabfzuNWGKzgqatjKZiNAsU/dYvzVwca9wHcDSa5gfLloA6X4rsaas9Apnng91atclA5VWe5NF4mNl60Ny3gQWVeHo9dFS3JDCAAYw3u6wbg28GDceOyPhdsiKdHw7kxW66+MYGdbd7Iw31L4+V9c00ZLtPEgpW9PW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725281662; c=relaxed/simple;
	bh=UfFqp5mDO0b025rfmA4fPtQw5WIof0M7hfBtZz5z0mU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u9Jo9ZKCaoRuPexUb46JDNQTArCn3/naVTLgkct6M2h6gHTuLzhABeuTs2CfbjxKndJqQHn030WetbTPjLY3Nl8gjGB3/iGoWb1mGZc15Pl9LVl1ZGiFKTETZBjXzs249shHhM2XkvsO71KjhzM4SYW53DVK0JKq4GpGD5jf92I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bY6dFukW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bY6dFukW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE77C4CEC2
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 12:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725281661;
	bh=UfFqp5mDO0b025rfmA4fPtQw5WIof0M7hfBtZz5z0mU=;
	h=Date:From:To:Subject:From;
	b=bY6dFukWOMaGFiYhYcA5F3y4q0d8iUr/dBBvYFjgWyrhcWYrx1VdN9fvztc2GQQUs
	 a9TTNrxAgwsLJKwI+szTiMptVNvwKvtlzvW8NaYWI6CyXsDgu+drudcnvePU6F55kh
	 dLFYMosgx995iM2jtfJzXoupmWFExv9Gw2+mL4jllE0fO7flbgiVL6k/SmIlZjgJAW
	 8MnyxVb78Upxn96+ybGgZexGQGvJBiW3N8o4xItJ94Nj5x5Tt6tA19MexGJg55R6Rl
	 jY8aj9WiFhpfptWlOukH/hFWtJbGJMBkVt32FsnfqoLxBHxCs9qKcPYwX0eT/ZJAIh
	 n3ggX1sJux3Og==
Date: Mon, 2 Sep 2024 14:54:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump v3.2.0 released
Message-ID: <vmtpnm6wbrz3zzqwfiwcoofvrpnj5xztfj65bfhugen7jyqi2a@rl6keyekwtio>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

82aa9678392699b5b85a3dee7e02d4a9c36a0269

New commits:

Carlos Maiolino (1):
      [82aa967] xfsdump: Release 3.2.0

Christoph Hellwig (1):
      [252b097] xfsdump/xfsrestore: don't use O_DIRECT on the RT device

Donald Douwsma (1):
      [8e97f9c] xfsrestore: suggest -x rather than assert for false roots

Gao Xiang (1):
      [d7cba74] xfsrestore: fix rootdir due to xfsdump bulkstat misuse

Pavel Reichl (1):
      [577e51a] xfsdump: Fix memory leak

Code Diffstat:

 VERSION               |  4 +--
 common/main.c         |  1 +
 configure.ac          |  2 +-
 debian/changelog      |  6 ++++
 doc/CHANGES           |  6 ++++
 doc/xfsdump.html      |  1 -
 dump/content.c        | 46 +++++--------------------
 man/man8/xfsrestore.8 | 14 ++++++++
 restore/content.c     | 48 +++++---------------------
 restore/getopt.h      |  4 +--
 restore/tree.c        | 94 ++++++++++++++++++++++++++++++++++++++++++++++++---
 restore/tree.h        |  2 ++
 12 files changed, 140 insertions(+), 88 deletions(-)
