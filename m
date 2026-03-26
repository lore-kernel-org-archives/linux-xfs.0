Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52082250BEC
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774545130; cv=none; b=oqu11i+piKjuo+6dX9A9JEFmnWwMYw776Xfnbv0eT4nb0qyHj5jtMIBBGcX3Tp6sIFeezNXG+2ISvWvzTIi+T2XCkuaH1Al6YHCoKftjBsKZLl1Twigj9hOPTWCCc96RH3kdD+/Bh4i+OvNv6CYO9SXHu90+0dN3Elkesw4VWK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774545130; c=relaxed/simple;
	bh=yKLfyXTk1m35myxP/CdIprvs+A27wKdHyaJSPxsXVbw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Qk16SVPpy2iv4YhmYU5H8T8CJcQmrEwfYZ+r5OOgVOW9Xb8Yxn+h8QfjOqsAG0QTe1F2FrNjbTbWAdGlza7HH0Jhmfti3ohcNEhtCiNc8Ywe80+1hLYMkmabddU8s2RsPwDLX8SKbQx4wdvmUpwJ6RWbmS8EJXDer0RADgH8hvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGobIir2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGobIir2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744E3C2BCB0
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774545130;
	bh=yKLfyXTk1m35myxP/CdIprvs+A27wKdHyaJSPxsXVbw=;
	h=Date:From:To:Subject:From;
	b=iGobIir2wCN4uzSXFtNnMKiE1B0+FaH8oAR8VaePWy/rDnPoVde1PZJC44Uww+GhR
	 AarZM7adP/FBbtxInPI2TRWJy0RM04V+aP9K9lVcVmeST4xeHpWKQrfHUCP/XfOlhv
	 rcWNXiQdEx0TT15P+1uJ8Ihgrh1z/K7iYlC3hN4Ph2a4U/7ONMONntEFDwyd91jdd8
	 mu2AqB3dYkCAjL33J+Gktuk2VNA3KqpgqoOF388C+AtSrr4OBKfut65RGMc/TKQRCM
	 koRXpVIosxk1Pvwg7P+Ir5DPQMtFIvcNeXcxB98Ko5pjvYzgQQ2uThl78ax3yRciZF
	 lcqi71EoUY+Bg==
Date: Thu, 26 Mar 2026 18:12:06 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 025b245f0bc1
Message-ID: <acVowXIDC7VYRKow@nidhogg.toxiclabs.cc>
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

025b245f0bc1 Merge branch 'xfs-7.0-fixes' into for-next

3 new commits:

Carlos Maiolino (1):
      [025b245f0bc1] Merge branch 'xfs-7.0-fixes' into for-next

Darrick J. Wong (2):
      [70685c291ef8] xfs: don't irele after failing to iget in xfs_attri_recover_work
      [e31c53a8060e] xfs: remove file_path tracepoint data

Code Diffstat:

 fs/xfs/scrub/trace.h   | 12 ++----------
 fs/xfs/xfs_attr_item.c |  1 -
 fs/xfs/xfs_trace.h     | 11 ++---------
 3 files changed, 4 insertions(+), 20 deletions(-)
