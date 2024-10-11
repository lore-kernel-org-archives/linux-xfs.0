Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF27E1078F;
	Fri, 11 Oct 2024 01:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610844; cv=none; b=f7YqsgQLguqA9iqdXR+AuzxMmoH/6FLL96OVwnTuf3cradFmknOfCiXecoGwvqri3bbfZNkRSleLKdEGjtuXIayLEemvbFzeNWz9z7AWMFfUjwmHKFaG+KBe8LfyCTlWTSQ+TY+gAfeD0tjK9mJxz/z0miO0jtWpz07l3pUW+1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610844; c=relaxed/simple;
	bh=IcBZqzFoW0T1E5hAq/B6WxtZSPbrvka7PN+YPPQZKxM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seNUmZI6mgkjVdZ7gfP4h0+3rU9f9kJBV8qAzlFItkItESrgUGYWrmtmk5hw096n+G6hiYH+7s6hsqMZzUHwL75T5y0VCysCq2Cdfq7/3iMOBZzliHxCufSmlA5FYV3tyNg/dVreK8bMY522qDm+J1+wbu082sGqEnEDpV2M6Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUVNJDQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUVNJDQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC07C4CEC5;
	Fri, 11 Oct 2024 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610843;
	bh=IcBZqzFoW0T1E5hAq/B6WxtZSPbrvka7PN+YPPQZKxM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EUVNJDQAb8ROyGq6rpYDTKoeNpRcym+TjfXQx4ypZ7dteahUKpJ9N8gpaiSHd3+PM
	 6LZJq/HlCGl0QqAqBp6WfaSB2hNZXrQJAk7mY+eP1kuAevY983Vrh108gUgARDV5AW
	 FSeFJtwvUrljmhAT2AD3a1p6b1XXRhtAd9GjclbaT+YhXotgSopq6odUmRjcb9hSS9
	 2VYQiWmtRXKCRKAaJuMFI8peIHcSGvihvW/Wrq19lM5ADO7+GBWWxReGRATIgizNEJ
	 peTGXDQ9J5j/NYCqzGzxA+L2RXZmoZniLJEK+DKsAHe+NP7uLnxO7pVMK6qcz5OQDb
	 2aegjsZSu1yFA==
Date: Thu, 10 Oct 2024 18:40:43 -0700
Subject: [PATCH 10/11] xfs/163: bigger fs for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658149.4187056.14339832597478812540.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adjust filesystem size up so we can pass this test even with metadir
and rtgroups enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/163 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/163 b/tests/xfs/163
index 2bd94060222f96..04b09d15afadfe 100755
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -35,7 +35,7 @@ echo "Format and mount"
 
 # agcount = 1 is forbidden on purpose, and need to ensure shrinking to
 # 2 AGs isn't feasible yet. So agcount = 3 is the minimum number now.
-_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
+_scratch_mkfs -dsize="$((900 * 1024 * 1024))" -dagcount=3 2>&1 | \
 	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 t_dblocks=$dblocks

