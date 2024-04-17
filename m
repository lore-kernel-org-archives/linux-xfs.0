Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B4B18C19
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388317; cv=none; b=S2pOTFrUF9wf26M9EM05h76cKhM2Qb9vhn4+o6vN+jqBUsdVrxVJ4GpwGUDS8c/pIVHuL8qQOKkdXIf+bTL/xxZ85N7SK+Jksog0IzabZiqpDuHv3tftqzOU+sKjjk7IVxSreAu34IhCXv7woEDL/3M40cLGBjYdGRvfVqs3quk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388317; c=relaxed/simple;
	bh=2XBe89hsrcLhxMmlR/C6QtiOfC8T6AFIgdunl3DZTPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Kr8w1nWvOokID0/Thiue2BxsiIXDSB5tvjaEEbpeaAWuzOLiRCtRBg8eCX+NCP5s89/0z4Zwn627eyHAZqPQFghXv3DF8HwpFBrgnP9ST+giG5+pyxe/4KaJdsQrLgJZDLWyWzZMW/gGNMbT4VqxsfRJO9KuKisXQ7aIgtpXw40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IV99Icdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IV99Icdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0851BC072AA;
	Wed, 17 Apr 2024 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388317;
	bh=2XBe89hsrcLhxMmlR/C6QtiOfC8T6AFIgdunl3DZTPQ=;
	h=Date:From:To:Cc:Subject:From;
	b=IV99Icdf4F/Uh8krkUfTVFRDBR7VKNex35bQantkUzF7fjL6v1UVHDlbXTlG+fXu4
	 KaTIGItMopROcNJo9ohQa84ALi0FiDVW13nKJTu8QLVI0QP2u+N9aODQh41oL0n9LY
	 t17skXK5zVEFDHIrbSUqjuo8DrxbA3zRFk2JSwGHLOBdBKN2QFZ8GQmDcC1A2rzAhm
	 vGwVKAts7X0k3prvfoocQhAfDw14uwXkf4vVSMabOd/m2rsfi1sLlXenmAxLnqh/3R
	 SiADLyauea12e40/+TdaDgEYYMHu53Z9AzeH4XTn9rzocQA0/Ujl72rTRAkJWj8rKg
	 A4taH89Aq3r1Q==
Date: Wed, 17 Apr 2024 14:11:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfsprogs: catch us up to 6.8, at least
Message-ID: <20240417211156.GA11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

This purpose of this patchbomb is to record in the mailing list archives
all the patches for which I'm about to send pull requests.  Everything
is fully reviewed and no action needs to be taken.

--D
