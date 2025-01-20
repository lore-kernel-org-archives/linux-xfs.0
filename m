Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54439537E9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 06:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737355223; cv=none; b=htwXDj62dbd1bgEgH6tV7z3WkSk+rURjZPQTLEULSzDnM62joMhHKCrNPd8Pbk+M4/npywQ8voX5hl6J0n0ypl5EHxYSzioD/mPTzMojRjvw2IHf8UdKgcBaDibMAtUDyrRoBJ5nICPwld2/Y3Srlgv67guv/aQ4KOHhwTB/u8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737355223; c=relaxed/simple;
	bh=Sh+cWUz07c3SRaL/35lE06j3epCZEX0nJAW0vHH3YL0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WX1/rZVCP16e16LWojNjociZEILtRbtP9/1M6MycA4p6VysHQwroiMlopWKemzyn055ayAtTipx48Tk7Q8VfoDjzs6TbSC0GR626b4GvuBPC7icMJxQG46xG7t2it8UZsPVosEXMXJbIcIXxRZSZQglQalm+tKE99NaCVd6ruFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBi3uKqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBi3uKqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B09C4CEDD
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 06:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737355222;
	bh=Sh+cWUz07c3SRaL/35lE06j3epCZEX0nJAW0vHH3YL0=;
	h=Date:From:To:Subject:From;
	b=jBi3uKqpwjjxPO9KHjEpH+lHyj5BmPE1kkQiAtOAOlerVo0UKZERFNXJVXr7pXJGZ
	 EfTHb+a0k8HhkvJwCMVeLI7Hr07SLw5E9ErCiH5BVZoISlluRfQLWULKD/Rvk98S3R
	 FkGgAaiznkVr1HpZY2mavgSD+8a/NgMo573YvyEBL0VCn3R7dl0VWhVD92wpJTcn6f
	 T0erWGnyNQ3FTIUVogSPOcO1JvJ6pECplC1+NLXKRypvy+pBuMeqPEtUo2Z98MwOsp
	 3+kjWV2E0hiUTSuA3Ts3REd/mWSWbUFV7K8izpdodjFkuAMWaTpqfejgPS3HG1EDF/
	 KQ1hLtzvX0LQw==
Date: Mon, 20 Jan 2025 07:40:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to ee10f6fcdb96
Message-ID: <wkveyhtao7hmphfsrtwhzbtk7epxkx5bnkmnseo364kzidbewg@e2bzl2qkjpgx>
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

ee10f6fcdb96 xfs: fix buffer lookup vs release race

2 new commits:

Christoph Hellwig (2):
      [07eae0fa67ca] xfs: check for dead buffers in xfs_buf_find_insert
      [ee10f6fcdb96] xfs: fix buffer lookup vs release race

Code Diffstat:

 fs/xfs/xfs_buf.c   | 94 ++++++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_buf.h   |  2 +-
 fs/xfs/xfs_trace.h | 10 +++---
 3 files changed, 54 insertions(+), 52 deletions(-)
