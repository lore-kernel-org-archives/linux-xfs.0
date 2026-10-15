Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358394E0211
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 08:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054269; cv=none; b=EDNv1SBZaCSQ47BzGZuyRk5JKlquuP6sV0nsIBZrQr0ZIU4j+NHaGjZ9dnV3EDqgp3F3tQAKgGeG0oYZEbzvMTY7S1waJRiUHq/sBrSHsa2zto+lGN3mQfH6ZJXvNRVs9cYOb7YKMagug7mJaOZ3dBkSU+H1Y6+IIMLhNyKfWXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054269; c=relaxed/simple;
	bh=DPBaxJmggg1VcDPXD9MVmjRwk5ZTK7tIOyUYAOoBcpo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=F7GmUuSdsPjSGP9bwG8lp3poch5kqZzWbPgg3ybzJnFp9CukB7LWlyyvL9NhDYcinij5Bt/eDaQJC2UgAGTr8MpFseZMDwgRk4EX6T+65Xr49vFiz8sOOS4QMla9oKhI5piM4107ZKJ48tjTQEcmfNINr8EV/dXQBXjkLfqAX0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGjZpUVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGjZpUVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7611F000C4;
	Thu, 15 Oct 2026 08:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792054254;
	bh=VC7Fc3/uaPLooY6V8HIeYXFFh3PGA7wF6IlUv7NMurk=;
	h=Date:From:To:Cc:Subject;
	b=RGjZpUVfAONARDKtfR/8qmpw6PxLJuUmc8mSDI6cfNKFJ1drUm+f62LTtYQI5uvGu
	 +zyo93Z/RggUmdxzwSPhHYSlbxPcOVToKaTigBJJxPD0EIwEdPUDx0WmwuhQgMR2RD
	 6k7qc9p//vk/gIJOg+qNjIl/cjOyZ2RmcHFv2uRwhp+/caMZcSsypgJNvjU2i2gvku
	 +4EycYPWZW2SNhCOLI6uCC6uhEkwW0ENUfnN58alSLpRCOdCpqavDsD/Bwq8Reh8T0
	 oNtQxlSuxw5KNEwk+URr6BMXB9H8u5+Hp3yF3gygrGAlxxT9KfsjeA4KWazinCfoE9
	 1bhIRZB2DVP4Q==
Date: Thu, 15 Oct 2026 10:50:51 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to cf40b63a4480
Message-ID: <atCT03xI__bB_i3u@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

cf40b63a448065b212f0959e40316b335d675ee9

New commits:

Darrick J. Wong (1):
      [cf40b63a4480] libxfs: fix compilation errors

Code Diffstat:

 libxfs/defer_item.c | 6 ++++++
 libxfs/trans.c      | 1 +
 2 files changed, 7 insertions(+)

-- 
- Andrey
