Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A175E2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882592; cv=none; b=d4qPUTI6OT9BFDg23nUImaW+chPFONuc+b7cmqfauo5m88+U7IEjxZGfmANflOLPjOUx7wjobFNxAngtE/poPSvOSL2nHWXusbwnrRQQPR/EDQeSzh3oYikuqMqPm+moYYWrbl8n7nHCkPYJHWbGUg4lKgF7GtmqB3C4A8KWIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882592; c=relaxed/simple;
	bh=1IjVNNHFDasAHSsnEVIJ5AfPZwiBO2ycdpgMQRCWosc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBsfEvxH3APnXkVm+uYSjtJ0PDtEJUkb9DgoggZ3w+TbZgW/huBDe4WaDbMkKk9Xe3XAu+N7Fp5c91ByGA7DmP6tiFulNodVl4JWl8FLDNfkWrxEgtvfgirW0A2VRgfFaxCYMoDnD4mNKcr6wDUEMgfoUZCucAwjtl8Lpmlt6FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeBqCCgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeBqCCgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13664C4CEDD;
	Thu,  6 Feb 2025 22:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882591;
	bh=1IjVNNHFDasAHSsnEVIJ5AfPZwiBO2ycdpgMQRCWosc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KeBqCCgRaq0HmJA04EbAeGxMSWDMY3a7F+U20NmzYzu5HnXmtcUT4+hkq1OJfgV0J
	 oKcMBajHOK4iDnp47reXuD2hY9/4Q6i2nZslu4cNDWfYAcn2I0DSC/FLzClERVKzk4
	 p99djyUILQn429Yzqftg58t3M4uZDWiH+yH4C3VVcEMZn3r4A34jv+5xM5piU+HuT+
	 Zj4jD9Jk9eBnri7Z95E0uz7bDJCQ7r1O+9nmHTauDhhrgHNo0TyLSuTpRYqIO7uoxw
	 J024Kkn24sKxPaf4DxlPhvifaThDvghyrcaD+6H5n2L8YL3kglrWOwMFZ+6Kf8YCaC
	 8YGGjvd2sPJdg==
Date: Thu, 06 Feb 2025 14:56:30 -0800
Subject: [PATCH 26/27] mkfs: add some rtgroup inode helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088495.2741033.10645836020741372245.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create some simple helpers to reduce the amount of typing whenever we
access rtgroup inodes.  Conversion was done with this spatch and some
minor reformatting:

@@
expression rtg;
@@

- rtg->rtg_inodes[XFS_RTGI_BITMAP]
+ rtg_bitmap(rtg)

@@
expression rtg;
@@

- rtg->rtg_inodes[XFS_RTGI_SUMMARY]
+ rtg_summary(rtg)

and the CLI command:

$ spatch --sp-file /tmp/moo.cocci --dir fs/xfs/ --use-gitgrep --in-place

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a2005b15b3..60e5c7d02713d0 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1057,7 +1057,7 @@ rtfreesp_init(
 		if (error)
 			res_failed(error);
 
-		libxfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_BITMAP], 0);
+		libxfs_trans_ijoin(tp, rtg_bitmap(rtg), 0);
 		error = -libxfs_rtfree_extent(tp, rtg, start_rtx, nr);
 		if (error) {
 			fprintf(stderr,

