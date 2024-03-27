Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE022612;
	Wed, 27 Mar 2024 02:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507733; cv=none; b=CKvVFn+JYxCwB80TkZXxBVzG2FUn6vl0Nrd0fFknx2w45mqzfOW4nWdYTSI45AyzdRMhUQWHGCFY4MtrEYUGKvVFiz25/OO7hZ8linVS8WPXR0Rzsj2iFfWxbcl7iLRpfmqF0vVNDB8e6ZKW3kOvlKUfKcnInUvFwv/qT1de9gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507733; c=relaxed/simple;
	bh=pZ/Bf03pufna1pa92HztpRJaoixdZfAnfs4pP4zupYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fs8xj1xLlAx/jBl2f654y2hX0rL+x2WnVdc0hYvb5zrSlxKeSX/eP007y+ItFZCfsUaB407OMOmgleBtaNe62JJoP6hlWtrWIKSGAe1DZki/XxM74GcGy2DMMNeewkNdr2AG+7FoWLNrYX/z9YhH9K28N+LFgWA+UixUirHx81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXZeK7Vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXZeK7Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA84C433F1;
	Wed, 27 Mar 2024 02:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711507733;
	bh=pZ/Bf03pufna1pa92HztpRJaoixdZfAnfs4pP4zupYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gXZeK7ViToVIyapLFNomOMf+AZB3iLKpDSTu5UjjkSuPbKr+VPPcoMdftAiDSifrw
	 8C0ZE43Yon8laFQi9Z/ryWCM9HmAI3kOQoXl8jyEOEi8QOtkokWUWd3cUJks8Bfp5f
	 Jk/36UZocA6QhLOHo+oJLHmyB5RiauBZW8LEKn2lzryuN/MPwb6J5In+WA8BLrreyS
	 lR/mq/ikxw7vnWjwPCvifOHScg2RAaDEPUYpqLbOFgMIdIGpZ2N9Gn6G6LEPCaBMr6
	 KCnBXge4O/RB9pyVgtAPW66zT4znRZphomGafIJixMgVCG64qOK2aXOahz1H+8s+wn
	 NbWmZialkT2FA==
Date: Tue, 26 Mar 2024 19:48:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 1/4] xfs/270: fix rocompat regex
Message-ID: <20240327024852.GV6390@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150740360.3286541.8931841089205728326.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150740360.3286541.8931841089205728326.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

This test fails with the fsverity patchset because the rocompat feature
bit for verity is 0x10.  The regular expression used to check if the
output is hexadecimal requires a single-digit answer, which is no longer
the case.

Fixes: 5bb78c56ef ("xfs/270: Fix ro mount failure when nrext64 option is enabled")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: remove debug message
---
 tests/xfs/270 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 4e4f767dc1..0c3ddc5b61 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -30,7 +30,7 @@ _require_scratch_shutdown
 # change this case.
 set_bad_rocompat() {
 	ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
-	echo $ro_compat | grep -q -E '^0x[[:xdigit:]]$'
+	echo $ro_compat | grep -q -E '^0x[[:xdigit:]]+$'
 	if [[ $? != 0  ]]; then
 		echo "features_ro_compat has an invalid value."
 		return 1
