Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934F8C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXKT3lKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5F4C433C7;
	Sun, 31 Dec 2023 22:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063000;
	bh=YEJeS1h2eZAOK8aADV2kYoZFWYBkRfFGe4tb11paMrs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qXKT3lKj/2Dmgc7LrU2DBKKtezTxlj5Ief5DzyUiMP/2Hb8MjJWGgr9WTF0p0noNm
	 i3g+lDPEbm2ZQVntR5tUe/afDgV4RkZNsldmGgpiNZyPIBwMIDJ8KuG/O++ETmwUBU
	 R8feFy4pzffRxzEqFF+Y4h4iT8pgH5udpmSK2isryWjeOicxlUIcOW3PI3TyWqOEaW
	 sr7VElLGr+J+3N8fS11ceMIzv8O7LvkXJbyXHeVOq0CAE/G7MPZhw/YC8FwdRozpQW
	 TLuUKcz5nW0S8xdo2oOtSnHQi3KzDPcKlZHmuutbJNwOaLCvonvOGvkcI9cuH2H/wL
	 tVu1LV0SubfoQ==
Date: Sun, 31 Dec 2023 14:49:59 -0800
Subject: [PATCH 6/8] xfs_scrub: don't call FITRIM after runtime errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001128.1798752.1623838175857601607.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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

Don't call FITRIM if there have been runtime errors -- we don't want to
touch anything after any kind of unfixable problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 288800a76cf..75400c96859 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -39,6 +39,9 @@ fstrim_ok(
 	if (ctx->unfixable_errors != 0)
 		return false;
 
+	if (ctx->runtime_errors != 0)
+		return false;
+
 	return true;
 }
 

