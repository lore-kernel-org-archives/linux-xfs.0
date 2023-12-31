Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10251C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNI/QrzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A95C433C7;
	Sun, 31 Dec 2023 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067001;
	bh=wnHJbH1hp4p9xm2/4g3lY/FOljY15M3q5Vd4VGatY9g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SNI/QrzGBwUCtIELIQteWmOynisOfgiB8NIWrxzuxt3BwttNfy6D9eEkv5QXg56As
	 MV0ev7ptGw/mcvebMsjxDJnnn0wbfSRmgCe94dk/jUBNm45AJz1AYbft6efUKO7Na4
	 owyVlPuf2Z0euyRmqox/VDUfp/uqmwwDGm+sKedRzfM8ZPs9HlsJdNXBI9/rpMywQt
	 wY41YJLSCRrmaUuJ600S3BgNKkTgVMTmRIWOkbb+xkqqWGwIoWIGjhwG9bhFtzENUU
	 fuO+/mKMWgoX5H5yXrwVwCTn3a4OH3w1zflfB+yd80L8+5SAHSfM6pbWKOpafj7Yy1
	 WvPJx1i8haoEQ==
Date: Sun, 31 Dec 2023 15:56:41 -0800
Subject: [PATCH 35/52] xfs_db: report rtgroups via version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012633.1811243.12534467466422497797.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Report the rtgroups feature in the version command output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index ce04f489adf..1d6ca2fa939 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -853,6 +853,8 @@ version_string(
 		strcat(s, ",PARENT");
 	if (xfs_has_metadir(mp))
 		strcat(s, ",METADIR");
+	if (xfs_has_rtgroups(mp))
+		strcat(s, ",RTGROUPS");
 	return s;
 }
 

