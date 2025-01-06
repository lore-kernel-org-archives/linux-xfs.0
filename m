Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7918B1A8F61
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 08:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736150723; cv=none; b=Uq8xqZ4hdZuzSS3DNe1q7Mt06gPx425S/HAc4R2Qox+fe9DQ0f7acM4QFkGtk5GK0+7ASVw5XgvtOxxcn8s4cZhOTASQVxkC78qtxi0rFRopFor0w/PCkwn7+kWv+3XsGOLVnAYto6sf25MrMMgI/SqIkataOVt4mHoBAA17EAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736150723; c=relaxed/simple;
	bh=B/9JuiI9l/woxUAUHoKmIU6RiB1seDerIDfGJ4SDKo0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FkJVyVqKpRI4bTC4+9x+reuoEOWkcm16yhslRNeJz2wnw73mAJxWg5RjmxM9DFRCkvMkzfFDI2CfyZMnhg4wGJn+gjOdo9RRgH4ySnuzw6WF7gJ88dsyMsvNiT9MwK+3h438JKJYgxs99DBaDcQVKmpHtZxuLFlOCIl8b/V2bDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rNFBsDb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rNFBsDb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5291FC4CEE2
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 08:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736150722;
	bh=B/9JuiI9l/woxUAUHoKmIU6RiB1seDerIDfGJ4SDKo0=;
	h=Date:From:To:Subject:From;
	b=rNFBsDb6qI/BvQG35IDXZlZKEukfGl1viQixd2kbl4jb+Wbax9gy8yq0bEstU6do7
	 7v6NcqgMJ+7+K/6685bE2c7UKopGNNe5xMpWp+zUHRIfhlHNRnPJuBCcrD106dFMmp
	 Bf1miQeME3dcb+OharcWq02u5fFUXYHywYHnQcSyWIT5UHluLhIPYt6yGxpqrPFKcf
	 2GQr6xejAqKpkFtQhfesp8CTG2NEcXGfaHS5ttU2jzaIJLmrBmU+wxEh1ONMwF5ooI
	 w/hEMWoLN1i1HX/TAu5t7paknyDF/Z3pRQYzBwn+oNgl2szH0Wdc80ftA8GOTHJpsl
	 gaQE6W3jTGFeA==
Date: Mon, 6 Jan 2025 09:05:19 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9d89551994a4
Message-ID: <nmbboccyqyplu53ia3akcvuqpod5ofd2y3gopjtwyhej3w3hj6@d7k66va5zvno>
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

This update contains no XFS patches, but brings up for-next branch to Linux
v6.13-rc6.

This will be the basis for 6.14 merge window

The new head of the for-next branch is commit:

9d89551994a4 Linux 6.13-rc6

1 new commit:

Linus Torvalds (1):
      [9d89551994a4] Linux 6.13-rc6

Code Diffstat:

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
