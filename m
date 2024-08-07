Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266CA13E41F
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058114; cv=none; b=MjiNDYL4cyCaktmuWLWYln/tcNsvdlVsalRc2ZSVh5zHNCdCgV/mIarAXePl8HtPouf4+7gMVBCkLM89uKQZK1rC4uBTLEJs/uQNhAhfJgH2g3Qntsc4w+6FOmKsLu4eh0rr1jmgVF70djL/V+4Lrappl1MEXdCS7q1B55RI7c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058114; c=relaxed/simple;
	bh=Pd6KU/ivC7dWbu070Vz+ll3x5aAQmTiFSJG/E2Zakj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AV2Ad+9DAwAaJBD/V+2cqP2TQIXF2R9aAIBTBA2CEzFP1cLGwXLRxiIlOK2CmVBiW+2vG/bIRxUvv0aDo2pFvoZ99PA6U0ORnbErGlVVnvP37FFAiJQUV+EaJZOSGZ5T3u9ez0X5W2fcQ+RHlW5BosX7zSUxi7gg79Ynxun2O74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csR10qbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csR10qbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BD4C32781;
	Wed,  7 Aug 2024 19:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723058112;
	bh=Pd6KU/ivC7dWbu070Vz+ll3x5aAQmTiFSJG/E2Zakj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=csR10qbSGyFhLnicUr0Ih21aMF1vZCCt+P6O8cQ5Ab9PogxQxZD35yhdPE39effox
	 IhEi+/itCzHygcFC9fqT3kagosIdxbZEUL1wrpP8hvDxVG0SJzGzDKClzaasOXfc82
	 Nr2sBKyCqoozBXz7xe4neD2vG73MIWHwffeywPG0U3yfBXSi+PsqqMOEcZsGiXxBXS
	 k4+zmJyWOWfzKOXl5MkR40kaRnpcLhoJ2iNk+MPbYudfNkFNgMEB7isvL95hw2Wgb3
	 QHiHbgILMICZXnofhYQVhH4I427727UVsQzrcdw1OavVecaQDUxosZlNxuPhPhAdoh
	 JEegHh2e6YCuw==
Date: Wed, 07 Aug 2024 12:15:12 -0700
Subject: [PATCH 5/5] design: fix the changelog to reflect the new changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172305794161.969463.5451370159032939139.stgit@frogsfrogsfrogs>
In-Reply-To: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
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

Minor updates to the changelog to reflect the last change (where we
forgot to do this) and this one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 design/XFS_Filesystem_Structure/docinfo.xml |   32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index c2acce19..1eddb1f4 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -198,4 +198,36 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.14159265</revnumber>
+		<date>February 2023</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email>djwong@kernel.org</email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Add epub output.</member>
+				<member>large extent counts</member>
+				<member>logged extended attribute updates</member>
+			</simplelist>
+		</revdescription>
+	</revision>
+	<revision>
+		<revnumber>3.141592653</revnumber>
+		<date>August 2024</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email>djwong@kernel.org</email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>metadump v2</member>
+				<member>exchange range log items</member>
+				<member>parent pointers</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>

