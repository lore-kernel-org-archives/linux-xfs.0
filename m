Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE138C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oskycXsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFF3C433C8;
	Sun, 31 Dec 2023 23:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064266;
	bh=dVwKmVNoo0qK223xgHvWXZ0sKwR0hCL+I7iWS0zz+sE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oskycXskezLy1dL3IOPbRIOQwqyl1u1jJgEIidrw2lsG/KolGaQnk3DGuAqBGIShD
	 0WDzfBPz0v5NubwcDMgnwR2Gen0dtBxuZ8+pagAseB9NzURG1BNjXZovQv31keO2Od
	 q42F38+IputpDk8I2kh7/LXuyk5Os0gG5NHq8oqVQgPCyCSY3HCLjJ3vHspfOu1tjY
	 rrIXvJtKSjSAqiVGS9RPeHOR1Km6OC53grHGCjlMuu4hj65/IhwGxv0vvuHvj+aSia
	 hmObE9R8a7nuOaZAKhzcEp7N9wXb5B11fOEzuRRZYDYj7t0OoWdRnnWbwbX7V3A+4H
	 16H+bqXYVBuLg==
Date: Sun, 31 Dec 2023 15:11:06 -0800
Subject: [PATCH 23/32] xfs_db: report parent pointers in version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006407.1804688.3081180575836582476.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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

Report the presents of PARENT pointers from the version subcommand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index b48767f47fe..9a5d665dfbd 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -706,6 +706,8 @@ version_string(
 		strcat(s, ",NEEDSREPAIR");
 	if (xfs_has_large_extent_counts(mp))
 		strcat(s, ",NREXT64");
+	if (xfs_has_parent(mp))
+		strcat(s, ",PARENT");
 	return s;
 }
 

