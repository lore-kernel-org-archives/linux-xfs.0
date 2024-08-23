Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC54F17C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371517; cv=none; b=j9dEiSIW94liGjAT5eUf+ZMQtW/TfYG6yBt6dp8SPDD09YGaHgyWYa0O7UvyABzXtZOslZATSG4JCN3Ipo0fywNKqmdGsqXjKVS9Y5mwqoJju2C1lvSCuC4oWBfhZSANQGeVKMtUDCMPy8JtK4g6M33epo/puW1N16q6ZPm/30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371517; c=relaxed/simple;
	bh=20nZCOB+p+vTaa7fTyR7UhfXm+fSKqJrq3zjxbUiG7s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2tSMgJUodUVFnihBpV3wHQZ3D0vmMrLFz9DU6oUzrrV86cryVDhGyc/WtF/QlKvoQeHWt1fqJoXlCcVQ2tXut6rUCfTGxbcFKeRip3Msmr9H795ks2On1SgE+GJnjNRUCSPkLywPr8r7p+vooQkhwNmIvn88C9V7dfB+02A+fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6Yc0Z6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6Yc0Z6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90499C4AF0E;
	Fri, 23 Aug 2024 00:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371517;
	bh=20nZCOB+p+vTaa7fTyR7UhfXm+fSKqJrq3zjxbUiG7s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f6Yc0Z6bzoW1nANGja2m4Lymc5kAsRma/v5ibLChJUvgYKZNAHji7kCmqTWQ6F8Ph
	 D4uSaqyl7Aj2XodmKoynH8cTB353R+Iuzd8GZxL90i2PMLDLUin23MJiboXOhVYjGu
	 oruyRbhRfUiO7N1AShXcm07YfDB+FPWW/p0JuZom0aP6dJMLv0Mv+Xpi0aCQ1Ar/Ho
	 BlcCd5dw7i2yyWSy78r+RGnx2TnSwR3tGMaix/vBtfYj1t2h0qz0R8JuOD2bjyIGUP
	 AuD6jHBnOgTPnCsTHV6NWOilxk6z9UGDL4LI/qyxOlwAud5dopwyGHnyaatXfI77Gu
	 n2lkblA33fB7g==
Date: Thu, 22 Aug 2024 17:05:17 -0700
Subject: [PATCH 12/26] xfs: mark quota inodes as metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085382.57482.14690905616222566309.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

When we're creating quota files at mount time, make sure to mark them as
metadir inodes if appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec983cca9adae..b94d6f192e725 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -824,6 +824,8 @@ xfs_qm_qino_alloc(
 			xfs_trans_cancel(tp);
 			return error;
 		}
+		if (xfs_has_metadir(mp))
+			xfs_metafile_set_iflag(tp, *ipp, metafile_type);
 	}
 
 	/*

