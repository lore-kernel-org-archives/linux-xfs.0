Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B27123EAB3;
	Fri,  4 Sep 2026 06:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503179; cv=none; b=LORF9owS6dv3I72l+Oc3NHrq7lLI3EGykBOdqB1x63bm8TgASofguYTG0UeT9heW7DR93hXjfZszveNj3Wgcy7NCVqEG/tB0JtHRPNML2gVgb4Kd9Gp92tM96APzMM8rb0zHz6j8fclfrWpkSDmo5mAileILDornVs/kjDhRb8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503179; c=relaxed/simple;
	bh=vVYSBUbYs7BkYnqihGU/eCveDgxEcJeyHRH2g8WZaTI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cLSWg/Wy0GJXQDE8VQp+4/6NLMG3ANigCpuO/KC6XHM5Wfy+Ci3pp3G6pKOYe6z/wgs6fm5J6nRTs4lCnxho2DM0uHbrVUCronSsbBS2vgULTnE09THdH9BigAkUEqwuUcA/d7PqGvbeoeLMe4MV+FskOIdXAuqKg4AOfymqlVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJb34317; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJb34317"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EE9341F00A3D;
	Fri,  4 Sep 2026 06:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503178;
	bh=nIaFbU8+UAxNP0Qsysbyz3d9qjfBY/MAR1m7URjSTXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DJb34317lTnhiO8/QU43aNruRhtw5ryCEbs9Zw0CpyeH+FP5Mm/Uu6GrmlDZvx6ws
	 dhR5PJdlsoQUkA/0hTcS75gNkOog8fNHY2XHDykGwPz5AV+oJxjbZcm1H4jTeu+Bu0
	 AKD+vEPmZHDEYOdjVzTda8fg48cMzTyjNA8Lo0NXgqBg8XflaEdbb5FLqZQOi+hGVr
	 bpsxrD4JhICI65k+UCK7aXzWwn/JyIGnfszri6Br+ij79X9ipZsW1E4K4DBxUgg+nU
	 EdVQMEdDe9vrQr9tnbvrdGUrwYOcqpQ4wlEh5+Welk05sfCCq49fQpeMuu5xiHgWeC
	 Jhmlqt3eBmOzg==
Date: Thu, 03 Sep 2026 23:26:17 -0700
Subject: [PATCH 2/6] xfs: report healthy filesystem events in scrub stats
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178850312540.1198660.5374727427398156944.stgit@frogsfrogsfrogs>
In-Reply-To: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM also notices that I forgot to expose the "clean bill of health"
scrub stats.  Fix that.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/stats.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index f3f1fbfb6d9955..da0c05ffe5cd0b 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -84,6 +84,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
 	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
 	[XFS_SCRUB_TYPE_RTREFCBT]	= "rtrefcountbt",
+	[XFS_SCRUB_TYPE_HEALTHY]	= "healthy",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */

