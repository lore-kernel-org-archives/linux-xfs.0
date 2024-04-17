Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AB1171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390128; cv=none; b=q7QOZ28uM/rIIW2mJ7Ri6Xf/XYt8//bS/2dm0WW84FAzm7alsnR2H3Wt8CxG+hyP/34hJL91qNhpAu7AFF+p5AmsJiYh9R3FLuFJG9pu3vYzDTmgLW3AzIgbffDNE+8eifJCBp0CzPSyOsJtAnZ9IQ6sdpu+3caYaNcxhDK3HXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390128; c=relaxed/simple;
	bh=RDp5AFWTuvlLmPXgJU79b82FnnxQWLVrHCPu737kX4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DLPcYZdxp8GtFjtiuSYHid9jU46rbTGoE6NEnyfEVHElIsv9EzJzHFbFmnkbZN/nO04D3jxMwrz906o1IBOmkqoAkphTooEVIoAGJVjebL5TiTk+v3L+GyVgvMW9/2A4RX0SmPyjCX+WSLm9oBXWDMC1w38SQ8/vi5bf3rSL3bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gATdSWuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gATdSWuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54488C072AA;
	Wed, 17 Apr 2024 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390128;
	bh=RDp5AFWTuvlLmPXgJU79b82FnnxQWLVrHCPu737kX4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gATdSWufe5U7WSN/Ie36bbZVA02WpRLdyBCsrmU20sUW4FO1ypfpkJ0wG2JQZsKnn
	 MB2/2nhvhiK9vk+YSRVehwjMTTSUh5iIyFvcH1uOxgHyv//4q4SYaInEGkkN3Q26Wa
	 H38mNj0EJwG8CQmcAWwCQ0YRY+5b02O5Lgolgz8TpERYo3RvzNlFJOp1oe693tQyzd
	 O17vyyfCF94aBIqCy3zlKFVSzOqsqxPTMeO6g5loJ7hadI1VhoZsoQwGJLS9FQEyvY
	 tCsk2ZdMtMrbMoaVhsXK5G7ebhgZquTr+HXdNPAUy80pOTWNK5RSXs9hvSx4TWxZia
	 RdDdhulsMhjUw==
Date: Wed, 17 Apr 2024 14:42:07 -0700
Subject: [PATCH 4/5] libxfs: also query log device topology in get_topology
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338844425.1856006.16413427495309154954.stgit@frogsfrogsfrogs>
In-Reply-To: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
References: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Also query the log device topology in get_topology, which we'll need
in mkfs in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c |    1 +
 libxfs/topology.h |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 706eed022..94adb5be7 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -292,4 +292,5 @@ get_topology(
 {
 	get_device_topology(&xi->data, &ft->data, force_overwrite);
 	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
+	get_device_topology(&xi->log, &ft->log, force_overwrite);
 }
diff --git a/libxfs/topology.h b/libxfs/topology.h
index ba0c8f669..fa0a23b77 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -20,6 +20,7 @@ struct device_topology {
 struct fs_topology {
 	struct device_topology	data;
 	struct device_topology	rt;
+	struct device_topology	log;
 };
 
 void

