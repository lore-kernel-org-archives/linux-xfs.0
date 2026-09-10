Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A99033F368
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020002; cv=none; b=K8LZP7T/bcac/GR95/oTQ3fjlounCdMoaibqLyq71FOQbfourEmYhvjjb7xeDy/A4X5bS9WjpRe/MTs9VxNRGAaxn3CCr9e41DX22Kt+RXro3gOEfr8rA8ROyQhldKWSETdEqLgwnQJhM6eCAucSnbXRBwF3sMxdW9PhjxdjGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020002; c=relaxed/simple;
	bh=97GM1i9hUsLzbbWSUbrOvaHzXsQBQ+CGyqHVSIY7FJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POsYMUjGn6yH2JZ674yq9vZbHb6uAe7tEs22uBu/jYb6OoDN0fuJSVlpxObM82Xu+hB/Y8uvKo9fA7P2laF9Ts+W7gTSe2vhwdn0OIBzAiUANLNknwP1tcxfzhKdb2CK0M8iKTDV8UF3106+FW9GufYOb42aYIXDfmD2RBbdd/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ulp83i5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ulp83i5H"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E89831F000FF;
	Thu, 10 Sep 2026 06:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020001;
	bh=Mo1m91U0MkzsnplNBvOmvTX51v4ZPCvW5S7xKDdT58w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Ulp83i5HlxPJJoLQl73QHXSRaplqBzuqmeNihLnhUG7U12ci7uQI0lO/4i6x95inj
	 t444/URkzrAkhr9zIXbdoxshISod94eXHW0v2VzYfY+mNemu3e1AFNinQYezU9iBBC
	 E8OqKux1AsbDK/XzfKHUKdchsEiIZTbxYZX5b+cVhGvbfRhiIHzl1BtKMDmgoEE36H
	 QCG0s/F3Sc1nsGFKnoWdtzjO4LsKc1+sIz33W/0i4OpT1daS+Rm5L8vsGnFvRu359L
	 jCccsf/tlN63cXDjgPgWeUUeGB1Wk4y8VdOwIWNnUUm5nahuxcI8Y/cx6cvrFi8lsV
	 etqVBlmMXJ9Ag==
Date: Wed, 09 Sep 2026 22:59:59 -0700
Subject: [PATCH 1/6] xfs: guard against igrab failure in
 xrep_findparent_from_dcache
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178901989849.361651.15853889388613447642.stgit@frogsfrogsfrogs>
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM suggests that we need to handle igrab returning NULL here.  I
don't think it's possible for the inode to enter I_FREEING or
I_WILL_FREE while we have an active reference to the corresponding
dentry, but we can code defensively anyway.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/findparent.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index eab3ac2704befe..d921fe5a9b0c76 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -473,6 +473,9 @@ xrep_findparent_from_dcache(
 	pip = igrab(d_inode(parent));
 	dput(parent);
 
+	if (!pip)
+		goto out_dput;
+
 	if (S_ISDIR(pip->i_mode)) {
 		ret = pip->i_ino;
 		trace_xrep_findparent_from_dcache(sc->ip, ret);

