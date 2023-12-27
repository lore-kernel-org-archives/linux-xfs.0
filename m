Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B373B46AF;
	Mon,  1 Jan 2024 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZYHcYpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483B3C433C8;
	Mon,  1 Jan 2024 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070523;
	bh=TFHfFp5R+n6VDl1cv6NJ1GP3REczsII2TNse8afcsOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZYHcYpxKgjFNPOpUKGwo4EUo/iMITs6pX/uE7c8ln7nFV3fC6Qkot4d70tZv8zNu
	 PVVlL3JnsEH3D/7Twlm8PwbrcN8uuG83R6OwWxX4bAI0gJe1rHnwUE8KE3HdyZIgur
	 a5cXdHgwicq8IIngedVYccZkTaNHUC/IJ8YBfpFayRdl84esLR8YcWBphnS2RGVYzi
	 Lw7QkA/enntZ+w1A4LMFTxlmuPF6DVbN9uEiNQRtdILHRoC26doTU0CyL6B2UDHido
	 PDy3L4zMh00SNsrIKHBEh+YMtvDDk7Rek2C2W0MnrFH2pY5sESE9HbnARZrDI3KgkY
	 C0p55PMN2/Dbw==
Date: Sun, 31 Dec 2023 16:55:22 +9900
Subject: [PATCH 10/17] common: filter rtgroups when we're disabling metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030468.1826350.14174130190423885732.stgit@frogsfrogsfrogs>
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

If we're forcing a filesystem to be created without the metadir feature,
we should forcibly disable rtgroups as well.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/xfs b/common/xfs
index aa1c23dd54..e66e11f15d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1936,6 +1936,10 @@ _scratch_xfs_find_metafile()
 # Force metadata directories off.
 _scratch_xfs_force_no_metadir()
 {
+	if echo "$MKFS_OPTIONS" | grep -q 'rtgroups='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/rtgroups=\([01]\)/rtgroups=0/g')"
+	fi
+
 	if echo "$MKFS_OPTIONS" | grep -q 'metadir='; then
 		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/metadir=\([01]\)/metadir=0/g')"
 		return

