Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CC23C872C
	for <linux-xfs@vger.kernel.org>; Thu, 21 May 2026 11:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779364465; cv=none; b=TxaiQIcIIXdPVd1UCeggBi3BdKxss5NQ+Ko+LPDSySxzOsHZvvmTPu6yThvbxfjw7G7pTE3yRhpxYeLzctdoGOMgaAQDtbaYl5+Z1nRpZMr7Cif3xf5HcihAHYGZZpAy0ZMsBH84Xyy/LF1faML+8Vpdv5RHiMGnlFT5BYsroAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779364465; c=relaxed/simple;
	bh=X6O49tBXY+zktuf8+w7kZYTmZUk3D+4Fv/lwOA0Cexo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CHXO5Coi9TYNLydqVM09GqwOQncx7Ush6eJIxR5emvEsYI53PagbvQuy2WVBM9etIxqR+oduUi7n4qrBI9D8OLoqh0HzEUn5bdwZ54I57z20W9M9jwNJRbVjSNGoDsVTsgPg+IBsEFGUXczSGVFyP1PQ7Nm42TLQNIw/Ijzn6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gn0D09Tq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gn0D09Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8251E1F00A3B
	for <linux-xfs@vger.kernel.org>; Thu, 21 May 2026 11:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779364464;
	bh=a1vbtsW6hKBBgUHpoBFbF+TmJrGQMa145TgYyzZ2P1s=;
	h=Date:From:To:Subject;
	b=Gn0D09Tqubx8J++hxIhHTwEiVqXZOSVR/ecTs6bmb0KpoHia9sMeJjPaxhRsYy7kM
	 8Y0+mxst7au8mQDvleRlA/KnUBzU6HCM4ANl2z2WKDNcuOc18mvSrKUXQC+IxM3ckm
	 Y9UeJ6eCRiOWaito6vPDqml0zgXzPrTc1CXcyvlCfUjGt6lbRBklISk4Rpbm3fMrBM
	 rMKcGX0k92rDl+9QVbedU/ZHpOYvPBN3UV/lL9aweGb3cWBomJYmnAsFG9ttS7n5MT
	 CP6L7+eZQQ16MJUB3y8x+/l96ce6aSdhJoSH7si8YJRWeUtB3u+dxcjhqd9v2c/pEy
	 8g/DrE2zuQ7bw==
Date: Thu, 21 May 2026 13:54:20 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to c69439a891cc
Message-ID: <ag7xy4-aWWjmF63c@nidhogg.toxiclabs.cc>
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

c69439a891cc xfs: fix a buffer lookup against removal race

1 new commit:

Christoph Hellwig (1):
      [c69439a891cc] xfs: fix a buffer lookup against removal race

Code Diffstat:

 fs/xfs/xfs_buf.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)
