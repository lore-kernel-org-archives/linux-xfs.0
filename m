Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3592F32
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666839; cv=none; b=oPtKZCPbiB/64j8cQme53T+tvjbF1JzqR/JPYPSbzg0kF4r00rvcd5vIOev7HxGt/VTPF31QYZez31MGRa5DCuupN7APFrHkuXRcr3gu4IEXTENdrJSWDDnG4dahcg8VFcKCDSFv0zteCOxZSmZxghsOBuSL/ZJ17w5gXp45hdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666839; c=relaxed/simple;
	bh=2OHE14oUnOBOKyOkUxAcLvTryl+Jt0UQk/4iuLWUvfE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TmXOkSjcpVYBSJxfFoTIYWx75MJQs828D3MF4g2O/M5Gjnea+WY6dGoZlA18c+OZRfgtv5kK6/Cx/kJBe22/3mSkLOcV6s3VHWirIKsXmW24qIhcVbI5qnOwT9pDE2d1lDdTQrRZ7KwAEreBwt70v88V0gcd7VEESUBAUvWn7kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arDMwSg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arDMwSg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3478FC4CECF;
	Wed, 27 Nov 2024 00:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666839;
	bh=2OHE14oUnOBOKyOkUxAcLvTryl+Jt0UQk/4iuLWUvfE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=arDMwSg3wSgQuNrDT7hZHC62gmChv1/GRloKWUUYFVxLBfeUtW6v8ngc0NR8iaqQ/
	 20M+pg6NBiRd54yngWpKKLTdx99MEYNg0u2v2j+eiTWt5b+o+sNOI47u6bdmTOYnCl
	 LOfe0lo4KLOVIQRhqjoDKvy2iUyBPoFUTs3bUXnXrOvBZez+EUADWPS3Cd71//BwTh
	 vZ+4MqpXddtS918iI2gYxKtZkHN1nWRJ6yZ0Nx40UxwYmjYIpJiguf8ToTeiS5RB3x
	 fpc/hWbeix0rXZR/+yRv+vRldVvO0MyGkt+o/GOuFRX/YMaBw2MnIuDyuTXHV97EZX
	 olk6alq1KdoCg==
Date: Tue, 26 Nov 2024 16:20:38 -0800
Subject: [PATCH 10/10] xfs-documentation: release for 6.1[23]
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662358.996198.14378980413890439472.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make a new release since we've just landed ondisk format changes for
6.12 and 6.13.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 design/XFS_Filesystem_Structure/docinfo.xml |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 1eddb1f42f11a1..3aadb6637070d2 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -230,4 +230,23 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.1415926535</revnumber>
+		<date>November 2024</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email>djwong@kernel.org</email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>update online fsck docs</member>
+				<member>filesystem properties</member>
+				<member>metadata directory tree</member>
+				<member>realtime groups</member>
+				<member>metadir and quota </member>
+				<member>realtime sb metadump</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>

