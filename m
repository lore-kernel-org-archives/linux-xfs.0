Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F1E165F1A;
	Wed, 19 Feb 2025 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926799; cv=none; b=NAlge0esE7XRhiFJfeIfWSoDq4XxvrgUG+UrP8/C8OdbIc8tSsxq9TAMflChKCbMU5ywTB3umbsITxVzbXDgEfWA+SIMoCwtVKP89iIHJW9gMDc7qqRo3UgCv8/bbJebYJsHJloNelpbGy9XQsdIshkIIxody/0Qz8kx/r+9jdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926799; c=relaxed/simple;
	bh=SCiffd5kq9Q8Z57JmZTT07TYPEVmOwaGv2IW7xYMn+I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/jBP64/B3wL4rVIOCuQiasO2XPWZI8IkfgLioBC++ZCSfxF8tyD9r85Qts8Ifc9Vn0p0yXwqWoEO5Oo/oOWbw+am1EP4V12klxHmu8YqF6q7pNAXCgbIqZUHVgTYCjZsy3AjD6wYHm4D4OO3BWPlqXSIGJSKcUy1PNZ0pXtFBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHU56o/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHU56o/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE23C4CEE2;
	Wed, 19 Feb 2025 00:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926798;
	bh=SCiffd5kq9Q8Z57JmZTT07TYPEVmOwaGv2IW7xYMn+I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EHU56o/qNh4IK4QyHLxI1esUVwofmiTuAg94Rp9nCRMmRgzDzyq6+oVcTz9Nya5jj
	 bqAnQS8stC5pCP8ecypC7P0anNGll5fFxqdQQ7ACBhnvjpOqtZ/smGgSjb/+0Ayi6S
	 3kKp+B+UU5NAWhzug92Mrer4lKccEYeqwLvGWrQRKPYDcWIy6ixHMFVwSbA8kuf8Jz
	 7qIMISmZoKvwmplfXthYfh7NojowW5GpBoUJbWH65BYwUaR6wNfZCec4LTHD9ds40G
	 5E/EmrxkcSOk/wCiMZ+9a072oFOubSLAAJWUaDhGWR3ty8HmaZacc6lgsL38fByLic
	 JXEw08kOKB37g==
Date: Tue, 18 Feb 2025 16:59:58 -0800
Subject: [PATCH 09/15] common: pass the realtime device to xfs_db when
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589345.4079457.12014427831544220477.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach xfstests to pass the realtime device to xfs_db when it supports
that option.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/xfs b/common/xfs
index c8f2ea241a2a41..547e91167718e9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -308,6 +308,10 @@ _scratch_xfs_db_options()
 	SCRATCH_OPTIONS=""
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' && \
+			SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	echo $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 

