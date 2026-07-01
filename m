Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FE23C8737
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 08:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782892878; cv=none; b=FWPqacjiy7gIsxmyik+DHenP0N195m4d5gMdLfND0tic7i/68FCyLIP0Oks4qwhAT7B7mzvNbLc/Awt7o9vCvW3084rtN1Q8JuYgRd9ofqdxjrIUAyrM6nUk+1eXeSRSmYhXNDmpfCOi0mj9wA7r7zMJGtalikU0XCfAFSTXdN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782892878; c=relaxed/simple;
	bh=xno1y9TNofO449L8J4yNfOtssXIJrH18S+TYH7mr+2E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=q7IIW+qwlC4ZyKUZf5GaRsAyplw8cr7CZVYs2KUha9W40vgYMrsC6+97IEhLI3qOp/dKc+z5Q4RdYs6JBJqDFzqmaA7f9bNv6/nBvgDA2NA7iZRgs6FrSE5D3v1ZYFkSynDYRo1R3IdqznG0bWYVVkaN5rMo7THxj+HSLjxZKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRTmQhHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRTmQhHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3A41F000E9;
	Wed,  1 Jul 2026 08:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892876;
	bh=r3sFSBB++Gd/C5Vhc4Az2VsrLYMW8wX+8YmzqR4u4I0=;
	h=Date:From:To:Cc:Subject;
	b=SRTmQhHWG9+OUEMfL8dG3qa+SBF/wPQzjc3irPNOUiJv5PkXHrCnMGOglnyh3xmej
	 dOPoRL5e9tj2JIXJRYc+AIr5Hh2lGuoYng7AiJXZ4pm3ITyclxPraqPFwI6qH4xTCI
	 5orhq8Qx6kH2n4Z6vsnPYL7TRXjv2ic4TYHGl9FUZ8DoieyywDHY79fcTNvx9QaBHi
	 303eZi1NubfsWjFj+6siGi0zWOYPvZUpC53KCenIELZuMQ34y4qh0tHEpj+9CIIq/q
	 jjyiBwpsBO+lpBexTT3zNIVu7+mw/yu/uPBZFIqg3mmYmtemdikOY9pOYOG5QIcYS8
	 GRwL04vCOhNZw==
Date: Wed, 1 Jul 2026 10:01:12 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 7a26df144fad
Message-ID: <akTJLYLZg0uPiLSf@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

7a26df144fadd9c721323a4b0ff9808473d5608e

New commits:

Darrick J. Wong (11):
      [0bafb12d66e7] xfs_scrub: stop user file scan if caller already aborted
      [bac5085ac2e3] xfs_scrub: don't flatten error numbers in read_verify_schedule_now
      [b43e9064d665] xfs_scrub: actually handle NEEDSCHECK scrub items in phase 4
      [41530a0981a1] xfs_scrub: don't leak phase 5 scan items after a failed workqueue_add
      [f4dfa0b0c565] xfs_scrub: fix phase 8 debug reporting
      [f75bb3f2d598] xfs_scrub: always finish cleanup, even if reporting healthy state fails
      [4399db49dec0] xfs_scrub: fix spacemap external log device scan dev key
      [70d0a4f27464] xfs_scrub: fix estimate of work items for phase 4
      [b64c29f5bfed] xfs_db: fix type conversions
      [1bbedb6d165e] xfs_db: dump zoned filesystem superblock fields
      [7a26df144fad] xfs_healer: fix getmntent race in weakhandle

Code Diffstat:

 db/io.c             |  9 +++++++--
 db/sb.c             | 10 ++++++++++
 healer/weakhandle.c | 15 ++++++++++++++-
 scrub/inodes.c      |  6 ++++--
 scrub/phase1.c      | 11 ++++++-----
 scrub/phase4.c      | 17 +++++++++++++++--
 scrub/phase5.c      |  8 ++++++--
 scrub/phase6.c      | 42 ------------------------------------------
 scrub/phase7.c      | 11 +----------
 scrub/phase8.c      |  5 ++---
 scrub/read_verify.c |  2 +-
 scrub/repair.c      | 16 +++++++++++-----
 scrub/repair.h      | 14 ++++++++++++++
 scrub/spacemap.c    | 17 +++++------------
 scrub/spacemap.h    | 42 ++++++++++++++++++++++++++++++++++++++++++
 15 files changed, 138 insertions(+), 87 deletions(-)

-- 
- Andrey
