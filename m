Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BB328E8
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531369; cv=none; b=B7Xi/FM9GsJHDwK5mpzTDsrmdhogrwIz2dX3DRLR/VmDF77wpuasVojmn7YIwoKofG6+y9wwvd6OL0DC0wQNlGJ8/OdU3Ube/nP3410Xrylkw8bLaOyqLCxHRluIN0i6vnnkaBY6OG3MOFMQVBodVx714bkYgBQ1HUkFy/R7jOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531369; c=relaxed/simple;
	bh=e56/K9Pyh9SBaaUdVkVKgpTJVEmW3gn0JAjubi6V06o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WCymhwus+y7QU/Gc+dpa6x+eS6CRzHvfC4aOzhAEykclDHYbUyewBje+nIeWr/xB1IMRTbcUubF1NDVztwmYF7Lcb35LvclG2CWLAukumBAz5ZnASUHCTV/AnnMIWDmFWaCWZDE66MggPsmGw2w+SZ/et6CdtJu1xN5hhA7NidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY+jc86I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY+jc86I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE66C4CED1;
	Sat,  7 Dec 2024 00:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531368;
	bh=e56/K9Pyh9SBaaUdVkVKgpTJVEmW3gn0JAjubi6V06o=;
	h=Date:From:To:Cc:Subject:From;
	b=fY+jc86IPoUflQYlaoV+eOMmsm+tWRzm+J6Vd2uD6J0xcrHT55DpxZ4FmdPw8ywSJ
	 ycIn9yIOgkjMrf+j48c2necam0IVoM3TcZ8RTQ1sIPhScGJbiLLyW/mJi8ZykATTOu
	 rTAnD+QYoVRuxmIwpIivQrYUbYTcbRe7gazJ+JjhdZl3Ri85XfnYSwsbjSKm6lRQkT
	 x9rgwWhirBHvwFdXxdl5GRTr7sHNZmTP/MgG0wUdkf/ykf2QJ6rFPCnnLmfBS1FQ+B
	 QpLK82Fuux4SyBXg1dAN+xNGwsoFC8UzLsHGmfe2mOpcSrXk/Q5RAgJ6NFkIiAuADf
	 Xmwv1SnzdMyFw==
Date: Fri, 6 Dec 2024 16:29:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v3] xfs: proposed fixes for 6.13-rc2
Message-ID: <20241207002927.GP7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Here's this week's bugfixes series with the changes that came up during
the last round of review.  There is one patch that has not yet passed
review:

[PATCHSET v3] xfs: proposed bug fixes for 6.13
  [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files to

Could someone please review that one so I can send a PR to carlos for
this batch?

--D
