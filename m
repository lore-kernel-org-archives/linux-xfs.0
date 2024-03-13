Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3D8BA2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295893; cv=none; b=txR/EcECmAFC8/g0LF350ZslvH5rCXrW/JH3MieeQxBHVSo5VwAGtx7qxYKZqtON7jzMU87LiRhkwB0lHvUisPFxm8t6i+Dj4KWtU8MJ30JgrkoGuNQbj12lAByo84qwzyekr5z93dQFFtmsi4xZavCjUuZuS/A3L4l5+Vvp1fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295893; c=relaxed/simple;
	bh=8kHd6+w53P0AmOt650tLXs73TW5VKvxj9sIN9mLT4tI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwfgEA4Ircg00TXGJIFgGfgoam7yMPHZBWrqPdwu8cxXkQ05S4Orf3f3h1NMjNi8mx9sLWcPKjdlILfNa4Guuw/P2CbfT0BY6voVMhamD5QijgrrspeJ+ZWKRednnauxqM0K0luG6VcoFWs238vjG9LLKPDYmJm53IYMoCks+KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVUVHySt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVUVHySt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAC9C433F1;
	Wed, 13 Mar 2024 02:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295893;
	bh=8kHd6+w53P0AmOt650tLXs73TW5VKvxj9sIN9mLT4tI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SVUVHyStrKWavtj9WJkQDR5ojezzQyi0QpXBXGMU8fW3eFoNRAe7qYihqAlcDdfXY
	 JWhyEPU9gYARLlJ2TZHqgRgL2iMv+O6mMSitWGQxaT2W80fjOksWAMZVEb1NQLt/IB
	 KoTrYpCt81SzN/my3K/vTsL02IKk7uD9f+GrNNzI6/KNH1HpoSoP1ZybW4zqsJ5nIV
	 3S7mVnPNaezf1Cdg+NiRFXhfRHoiDdr9kMBGJJ5px5Wb8XKu5MyKGWHqBTw6x9fxQS
	 kH3Kmaff2uSwmHCEhIghB0vAbm4bBUJrTWwFYxApoyAHdNUBaQIktJq4sSHgauD3OZ
	 XI6PgqGblZlmA==
Date: Tue, 12 Mar 2024 19:11:32 -0700
Subject: [PATCH 1/5] libxfs: remove the unused fs_topology_t typedef
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433229.2063634.360630278280106571.stgit@frogsfrogsfrogs>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/topology.h b/libxfs/topology.h
index 1af5b054947d..3a309a4dae05 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -10,13 +10,13 @@
 /*
  * Device topology information.
  */
-typedef struct fs_topology {
+struct fs_topology {
 	int	dsunit;		/* stripe unit - data subvolume */
 	int	dswidth;	/* stripe width - data subvolume */
 	int	rtswidth;	/* stripe width - rt subvolume */
 	int	lsectorsize;	/* logical sector size &*/
 	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
+};
 
 void
 get_topology(

