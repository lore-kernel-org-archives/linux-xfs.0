Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1B1CC8AF
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416122; cv=none; b=cWMw8Inoe+gYlLCXU5hc8u9chz6v9SWjfmB3ekvPKcV5RfgEgMdLVFROKPOxOKjsO8sFP/T681HViIG2CRdNFKufQNseyk1Bbh3QKo+2/G0IZQxlxIRAL6l38JiYmgMq7FWItuUuRRFK71yAMe/UzirF8dc0PFyHzHI5+yic2AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416122; c=relaxed/simple;
	bh=C8gSNYWlfslg9Asb4qqcZq0K94euwlKdFjnSovukh4c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EadfKfij4fhJRUsHMAfVTomogaDo06kZ+Wy32FwVEEY6f33EsQwmnMPD0mPi5/pkDzaovUUtyDL6SpqR1LrY+R4mxSwKGVwoqDllsUu88FxAxqXE6Bs+4vMG3KmYZQIzlQjuLPvSxgo95o+19Jcxxm91IHl+CZmyc8q92E8QUVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6iVLUCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6iVLUCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6114FC4CED2;
	Thu, 31 Oct 2024 23:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416122;
	bh=C8gSNYWlfslg9Asb4qqcZq0K94euwlKdFjnSovukh4c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U6iVLUCzAA5KciE1/h/vQ8q+0PouKB8E9oVzH489kG/soAShWDMuOULZs1AP6sLho
	 ecB9niAq1Lgx6zSmoPS2cMH4arIGzN4lrt7adRLF+0ZqFk7JCPJ4oPMv7FxsF0Wuxj
	 EJaXo3TtntFHCP/BSlrovd7RPRRHebIcZgxHD5bE+ag2a8CtJyNjC/uc2moE7xftSw
	 rKZj9IJaQz/+1f4aGdGRJNV2L93gMKkVrDbhQ3Yf3co5jWJaNMzglwf3PcBb8qBSuT
	 n6k/n5kAtkYalT7iQBx7ih7il3lwhREOJL4AZoHStBEpPcMqqMbcDxdycaDUOy26xO
	 KmbH0RVtzPwVg==
Date: Thu, 31 Oct 2024 16:08:41 -0700
Subject: [PATCHSET 7/7] mkfs: new config file for 6.12 LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041568827.964970.16858014331188799642.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

New mkfs config file for 6.12 LTS.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-configs-6.12
---
Commits in this patchset:
 * mkfs: add a config file for 6.12 LTS kernels
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.12.conf |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.12.conf

