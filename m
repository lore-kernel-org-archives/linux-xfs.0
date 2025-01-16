Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6FC158520;
	Thu, 16 Jan 2025 23:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069927; cv=none; b=eTRNOCXk7Cb346TxkRDbGlNsiFQ2y1p+7Tjk77rFqduCJTmf60Y4h/iV5bFlwFcGBkgc0wddwLy54E5VBmSvXBgkzrPijOrqJZtdAV1C6VS7J8UugjRrh5rSrD4CNboI4SlsjbY1H7MscJippn2H1WMiHz7I/Q/SNtE3qVfNRlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069927; c=relaxed/simple;
	bh=hRKBO2pRMMV0iWpFdRA83ypF1qZut8GOYRoq6m0ZLZg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYEUMhJYMFt1Vg0my0mP6DaNEVw2o6khzWtuhRViWdnB545s3HmzUw0UFBee0VaqsAvQspcdr41rS8+d8au4KNBL4tzVPZRpwJibKKE3hnZKGrCnVIZwKHRrm4ZzrUP3Im1Z8KBsrsUIVPV6E2l9v2RtWf49LtNLqG6NrcmhaOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VltWNgmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VltWNgmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CD3C4CED6;
	Thu, 16 Jan 2025 23:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069926;
	bh=hRKBO2pRMMV0iWpFdRA83ypF1qZut8GOYRoq6m0ZLZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VltWNgmq0zstUJjOQhvLgdPLO3fIVfJ3jWlQE8vjyZfprNYo1EtGYb2PQ2uXicRCR
	 NyKh2X7Vxm2W2BZ5+h4dm4qYcFSGV0PXKroY7m8jhIKedX0wkmh5bb66gYzcBvFt4l
	 d3zzC9UL45t9kDNKlpU+7bxjvMRogjYxzfoBQu0LCTDQtDfSim8i5gnSBWe4shFaWn
	 aHzz/qZalyOhE7uEVfBzxBxypFzBL50tedgU/p0O8kha7lgibMYlJOCPvdcTFvrQVt
	 8KGUTRJX2+/0htLmtop3pGnXlwf6W2k0KxK8x2aZ5A7BaVcgmMEXTm3mqR7ifTbRzM
	 kf1rsmskd+1Kg==
Date: Thu, 16 Jan 2025 15:25:26 -0800
Subject: [PATCH 01/23] generic/476: fix fsstress process management
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974091.1927324.4002591248645301199.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

generic/476 never used to run fsstress in the background, but
8973af00ec212f made it do that.  This is incorrect, because now 476 runs
for three seconds (i.e. long enough to fall out the bottom of the test
and end up in _cleanup), ignoring any SOAK_DURATION/TIME_FACTOR
settings.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/476 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/476 b/tests/generic/476
index 769b3745f75689..4537fcd77d2f07 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -22,7 +22,7 @@ nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
 fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
 test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 
-_run_fsstress_bg "${fsstress_args[@]}"
+_run_fsstress "${fsstress_args[@]}"
 
 # success, all done
 status=0

