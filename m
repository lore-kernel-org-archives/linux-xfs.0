Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED3D28EC60;
	Tue, 14 Jan 2025 10:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850510; cv=none; b=kS1fI1daN3SMQNX3ss2t1RzH4vFJkbahOHBelACTzVCcTOesGgr6v8E7yq0whpLjBoIedHGU9v7ptbnTkI/6dmLoD17SP1rQJdyE/W33kugnIwqGE7Au5HtVZ7nx0nZ5c9C8oCpbDu1EqKK2H2R0yNtuV1ZickxBmaje/luOX54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850510; c=relaxed/simple;
	bh=7Xyvx//W34AHc/Tw5+ZODJKJ33wqtJEz+tKkVSYS2Ks=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EwFQAHEw2LYN47gaPRaGCp/7Da0nKPl3oRA3K/bXRIkEurm721Yt3gmB23wd6MtSnKicRK8mEbZkevoAChWsNDHkQH8DW4spbXHBvYCQEQa3JC9g2LxrenvPjjl9dbjWE7JFu3cVMVwCFZfog0HCdaPAn+C/cfrhmmQpAkaPnko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcFs9pi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcFs9pi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CF2C4CEDD;
	Tue, 14 Jan 2025 10:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850510;
	bh=7Xyvx//W34AHc/Tw5+ZODJKJ33wqtJEz+tKkVSYS2Ks=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=FcFs9pi2nMWTOxMWtMLn7dqmdv/nJ4k4CoCBF5Uu7qrY87egjQ5CUeJZ2U0q1PaC3
	 ZcTzA50GF7P6qYAx3gpk9hHNdSIlSBWyRozhjk7u9y05VYGyuoN/Kpdt5bcnje3Zj1
	 EpkAOFAC6qcwXQt39TJin+jSpCkgQPOmcg25QT43iuMpBx7l01Gaa1OWgxEnKEXlLe
	 EwdPTMzyJ+nXCPlBbiPNsbPdQRoZoxfxWSm2Hd3G4tdu64WhchJ52MbiM4Q9JM1hHl
	 13fspuTs/UEoqrObtXl6Ya3FbK9OlGeWxdTemzbcflLX6GG+hMDzjkHCUFd+EOwjrL
	 Bwf4YidlTzpqg==
From: Carlos Maiolino <cem@kernel.org>
To: Alex Deucher <alexander.deucher@amd.com>, 
 Victor Skvortsov <victor.skvortsov@amd.com>, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Xinhui Pan <Xinhui.Pan@amd.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, "Darrick J. Wong" <djwong@kernel.org>, 
 Chandan Babu R <chandanbabu@kernel.org>, Dave Chinner <dchinner@redhat.com>, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20241217225811.2437150-4-mtodorovac69@gmail.com>
References: <20241217225811.2437150-2-mtodorovac69@gmail.com>
 <20241217225811.2437150-4-mtodorovac69@gmail.com>
Subject: Re: [PATCH v1 2/3] xfs/libxfs: replace kmalloc() and memcpy() with
 kmemdup()
Message-Id: <173685050606.121023.15880715609147802061.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:28:26 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.2

On Tue, 17 Dec 2024 23:58:12 +0100, Mirsad Todorovac wrote:
> The source static analysis tool gave the following advice:
> 
> ./fs/xfs/libxfs/xfs_dir2.c:382:15-22: WARNING opportunity for kmemdup
> 
>  → 382         args->value = kmalloc(len,
>    383                          GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
>    384         if (!args->value)
>    385                 return -ENOMEM;
>    386
>  → 387         memcpy(args->value, name, len);
>    388         args->valuelen = len;
>    389         return -EEXIST;
> 
> [...]

Applied to for-next, thanks!

[2/3] xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()
      commit: 9d9b72472631262b35157f1a650f066c0e11c2bb

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

