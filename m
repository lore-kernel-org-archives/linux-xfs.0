Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E796B1B87F4
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 08:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739176986; cv=none; b=M08sR9gvLVvNte+nVEFoNCIYLtPwds9Ypm8hHeznSNpC69Wpiuu7ADuiL+fAT4WSi9kvA7u41tYU9ze4moXt7cQqa6AExlAnJGIeo8EXHysocK4RlCGPVBzYtcHshpUcXyUkcy23200EaZMJXgEozEACXGgXTjSYJLklh495FTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739176986; c=relaxed/simple;
	bh=pYtGMcEbHqNxf2ASpkwU7Ps09bVoDa9+Ux2J46SRpgY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=suUbhpeLpdKpTsS7M8y6C83szLtlAhqNnJy5TdvF2Ma9U+cKmRbnACD8qWTPwrg71GNoLEc04tehsHQct/nX9+iXQtkVBMyylls5rgdbSZMWxyOONdnzG8cYnAIgxqKmlue4a44J2cpwMuaOvukyvXmLQt1e6mCdqvoP/Oc42lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebmcYq4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebmcYq4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AA8C4CED1
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739176985;
	bh=pYtGMcEbHqNxf2ASpkwU7Ps09bVoDa9+Ux2J46SRpgY=;
	h=Date:From:To:Subject:From;
	b=ebmcYq4hG81kdk76rb+CQXzEE63qOdLr6FpRgGP9OVB4X2iAg90nNbCXaMAAm2WHZ
	 hiV1V6PczlKzH8oCissEl7TltZSbgwa82CNaua+ht0Bhj0a6/CjM38CaGnPeoerf4R
	 a+v10thQdFe6oL8F9ctQRdz+6ZEFkwmtNPduYTgNjQJfn1bBvzzyc2TlEeYY78YckQ
	 QfAEnw49CCQWpp4n+8TkYMsTC3b/1ri16uFiY1a0TygYk4xwOA6au/DTwHoMttbxVN
	 MDnDikpGOZ+5JRiy1aScfwIE7UtJeo7tthd/ibbwvG9OFC5TFoVQKpOXMmv6H+jdWK
	 VLsG84+W7ZjHw==
Date: Mon, 10 Feb 2025 09:42:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to a64dcfb451e2
Message-ID: <v3kdi4c5qwiz3s2d3metzmuaihoozzvdkxnonm2fnapuplf475@x4aj274eklli>
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

a64dcfb451e2 Linux 6.14-rc2


This is just a fast-forward merge to Linus's tree, no new XFS patch has been
added here.
This shall be the base for all fixes targeting 6.14.

Carlos
