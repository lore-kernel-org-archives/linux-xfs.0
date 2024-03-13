Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB3F8BE0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295940; cv=none; b=cHc5fx7nB2KC7kX61N9lif31JHhJDyofyoBmu7nyIKzlA3faJU5mzA+YDFSZyt7U70oY/3gG7cCMA7SSY9dNB5FJo9ysVG0qpkwaSYW/owofhwe0SALu5s6kZ7i7kJIBhuxsn8zPrdG9t18ntYLqkjRQATEe5JxLUEY+it53v0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295940; c=relaxed/simple;
	bh=DJLUhMkxPWzYHF+hwOFLnmU93sGZKjoO8K6hTVF6hk8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrNPuHBd1pMHy5DpvjTxoBy7agNNpbEKPEULMjPvyB6n8NkjHdANB+ZBCbdUo3HnuTZUTu2P3jweY5oLi1L39dmK7Xq1G0C1wt4feMMeagia9hw16t7Qok1nt77yrC/5xD+tYc1bB0S5KgiJTV7jCLoPT1U5n3Ks0gSNx9mNFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2iQpLFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2iQpLFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2614CC433F1;
	Wed, 13 Mar 2024 02:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295940;
	bh=DJLUhMkxPWzYHF+hwOFLnmU93sGZKjoO8K6hTVF6hk8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U2iQpLFsH+eB+me7O5cqddsqHNqB45jvy6eNGtG1lQSGAjeHF3IO/lWIIkFubtYd2
	 aHmvuQB0tDDS7huLjNbeblK2QF/n5wEXJH7n8T1Nl1iqG/pRdl/LGSYAPxaWZh0agx
	 BLmLKuPLK8YzaTS1DPuPOLTNtY6YK1CwIpm7TmD7s9hBrRQYiP86uvpRp7OJcU3i3K
	 egF82PYfaQYYivaQ8lJRK9hHzR1AenKf2O5Jmv12Ct5GFzQ9GZUEF8VrYbL14F0fgA
	 v2+DcBzEaXE9lrdWapdiQwxbyQLPRsSBDFccY5HcTRLKG8PyV65/ETGyS0Xmcjr/oZ
	 DuwTATDsXzwig==
Date: Tue, 12 Mar 2024 19:12:19 -0700
Subject: [PATCH 4/5] libxfs: also query log device topology in get_topology
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433272.2063634.1143746697069724234.stgit@frogsfrogsfrogs>
In-Reply-To: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
References: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c |    1 +
 libxfs/topology.h |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 3a659c2627c7..9d34235d0f57 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -326,4 +326,5 @@ get_topology(
 {
 	get_device_topology(&xi->data, &ft->data, force_overwrite);
 	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
+	get_device_topology(&xi->log, &ft->log, force_overwrite);
 }
diff --git a/libxfs/topology.h b/libxfs/topology.h
index ba0c8f6696a7..fa0a23b77386 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -20,6 +20,7 @@ struct device_topology {
 struct fs_topology {
 	struct device_topology	data;
 	struct device_topology	rt;
+	struct device_topology	log;
 };
 
 void

