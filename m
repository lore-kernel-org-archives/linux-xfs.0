Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1660B7ED;
	Mon,  1 Jan 2024 00:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoMiGfhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA34C433C7;
	Mon,  1 Jan 2024 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070429;
	bh=+96bOFEuTSjx1a8FjnhobJpygdjOPFotve1QilQfuqY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PoMiGfhuVH9GsjX+hLaq8MHtxIXufRLZYGdyTNOk3JMS45sgSgJX5OAKMB24GO4vS
	 2zptQ0O+FhHHcdID5U034t7e6L5s5SdnPE3dr4DySXhTAaf9q/LtCYS3g87Absicxb
	 hTHpkvL4p9WJt7i+DcdpiUPrMaZdx47tz6OkFciIvrWqLfQi6l4Jz+3UoPQSDm5Ver
	 62ljW3V/Wzj0/6Wro7VOh7Zd1KsPK2DZvg6b9l+ZjQvO6pvXHz6Ero5CfPSqmoqquG
	 R/mZfGn8KFAWThL4vda9vNOepox//8MfqLGU2kk8jzXZV/apjH/rO9gVjQLaoS/fir
	 dulhE3PM0MpLA==
Date: Sun, 31 Dec 2023 16:53:48 +9900
Subject: [PATCH 04/17] xfs: use metadump v2 format by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030390.1826350.13961921287983856419.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

Create metadump v2 files by default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/common/xfs b/common/xfs
index 77ba786ece..4e8630b3ab 100644
--- a/common/xfs
+++ b/common/xfs
@@ -669,6 +669,14 @@ _xfs_metadump() {
 	local options="$@"
 	test -z "$options" && options="-a -o"
 
+	# Use metadump v2 format unless the user gave us a specific version
+	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-v version' && \
+			metadump_has_v2=1
+
+	if ! echo "$options" | grep -q -- '-v' && [ -n "$metadump_has_v2" ]; then
+		options="$options -v 2"
+	fi
+
 	if [ "$logdev" != "none" ]; then
 		options="$options -l $logdev"
 	fi

