Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A373644DC;
	Wed, 21 Jan 2026 06:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977619; cv=none; b=hvwJxZ+0/I1Y+0OTSoWxEPQIRzPeV913IHWBRsX2maVY93OMM/Rm9/OROlXZcCfx+pHnjdcF7OIPS/LZcKRZjfwSJHxUhGk5FbWx1HojBrV2yi8z3ph+eURK2Qpmrlk8BnRTDfCaC3ODAaUIsCeCnm3v3z4p1uo2nhpNVfTwWe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977619; c=relaxed/simple;
	bh=4iUG7rwb9S6rcDB1VukD+be4x0LJo+fGtwH7rT2pSyo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=OPD2leCSlVFqom73jMkb+X+t+LafgIEG2ZADUf1gcO2thWy/E2tyZ+Iv/ZkZs6oAcfKo23bkGi7XHEgkgzYyi4MetUM9HTIxWPMLxD9XujJ7heVpwruWxOg0vZqejvyrUSGW7KD9mVWSAHYev88rpK2f2BwtszE/wrDBdcEMaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InV3kXnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InV3kXnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A643C116D0;
	Wed, 21 Jan 2026 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977618;
	bh=4iUG7rwb9S6rcDB1VukD+be4x0LJo+fGtwH7rT2pSyo=;
	h=Date:Subject:From:To:Cc:From;
	b=InV3kXntxsz+drHiS25XEsbhTkuOUTXA6KQDRfPMHDU985XEA/7YML7/lHBXamgKD
	 0HcHIGeXXajMrIGBRkYdstQuR1oFGhG3NtV2/3WP2moHNZzo83HX+Lkk0bXN8bH4bG
	 R0VhqlrmXxAHIhbJq5140YHQhfSg42J7vik+AgdpkedSvCSU9Uj70OFErqg9HCjcy6
	 M6v7LbSQRmzL0cizrzG1DSk5otOIgHpcQ17RkbyQPdob7BPQ686XtTApwFhAEeyEZ1
	 cBshz8HZ50tZxkabfi12m+hXUv5Ot293wwRaWg2OK4+4lkSaw74TLwlLjJuAtDBksB
	 a1j5c9RJal2wg==
Date: Tue, 20 Jan 2026 22:40:17 -0800
Subject: [PATCHSET] xfs: syzbot fixes for online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, r772577952@gmail.com, r772577952@gmail.com,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix various syzbot complaints about scrub.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D
---
Commits in this patchset:
 * xfs: check the return value of xchk_xfile_*_descr calls
 * xfs: only call xf{array,blob}_destroy if we have a valid pointer
 * xfs: check return value of xchk_scrub_create_subord
 * xfs: fix UAF in xchk_btree_check_block_owner
---
 fs/xfs/scrub/agheader_repair.c   |   14 ++++++++++++--
 fs/xfs/scrub/alloc_repair.c      |    5 +++++
 fs/xfs/scrub/attr_repair.c       |   26 ++++++++++++++++++++++++--
 fs/xfs/scrub/bmap_repair.c       |    5 +++++
 fs/xfs/scrub/btree.c             |    7 +++++--
 fs/xfs/scrub/common.c            |    3 +++
 fs/xfs/scrub/dir.c               |   10 ++++++++++
 fs/xfs/scrub/dir_repair.c        |   16 ++++++++++++++--
 fs/xfs/scrub/dirtree.c           |   18 ++++++++++++++++--
 fs/xfs/scrub/ialloc_repair.c     |    5 +++++
 fs/xfs/scrub/nlinks.c            |    8 +++++++-
 fs/xfs/scrub/parent.c            |    8 ++++++++
 fs/xfs/scrub/parent_repair.c     |   20 ++++++++++++++++++++
 fs/xfs/scrub/quotacheck.c        |   15 +++++++++++++++
 fs/xfs/scrub/refcount_repair.c   |    8 ++++++++
 fs/xfs/scrub/repair.c            |    3 +++
 fs/xfs/scrub/rmap_repair.c       |    3 +++
 fs/xfs/scrub/rtbitmap_repair.c   |    3 +++
 fs/xfs/scrub/rtrefcount_repair.c |    8 ++++++++
 fs/xfs/scrub/rtrmap_repair.c     |    3 +++
 fs/xfs/scrub/rtsummary.c         |    3 +++
 fs/xfs/scrub/scrub.c             |    2 +-
 22 files changed, 181 insertions(+), 12 deletions(-)

