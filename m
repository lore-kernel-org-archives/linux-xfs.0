Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D118E362
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838121; cv=none; b=RI1N1obMSnZH9TZD2Son/ePl4v+2oJkRy5TXPBhP7KLDtjmRe+Jodv5ZDcTVCZDdIdLO7hVygNBj95MAiZn3ruOwsWovWtm4Cfd9gmeVEIKB5QzihEEoGm79qzccr+rX4OS0dW/GEmyzbHf4IVHi58e/MFCJ1NLPkxK58OoB/8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838121; c=relaxed/simple;
	bh=18yFyHhbAi5zIgGqMR0YimdlfX5zZe5II3niaoDOgDs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dfvzewF3NGdcdqVXRwDCz+Qg0jreB5SvTo2XRaWHciR1XWXvtW7RAQvppyiLkHwYyFUTwRKvpEK1SOscIjw3St5pdDH6RvkI6YSGT/Yp+6n5s9LwbUeXNVYtSp1PS7/CxiKs92lXwZgY4HyOtZ7xV3zmedcIjmfQq0OYE2WnPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGdW+7pE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGdW+7pE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA2CC4CEC3;
	Fri, 25 Oct 2024 06:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838120;
	bh=18yFyHhbAi5zIgGqMR0YimdlfX5zZe5II3niaoDOgDs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fGdW+7pEPBqEP9K/2qn/zqu9O1FchFSRxsOa89a6k28NA515eHmJEKbIKU5oTKpYV
	 IeWSfkfpcoS0Qh3cAWIY+rf+pAda/vohS5eIGRIuB06hiBq8MEHDeU2kEhg6HdEskU
	 MWtkD9V8JMSm3ZQW41gj8pmZXAm2t7MITZQJImWhNw6Kv4mY32tbvXzO5cfuFwKni2
	 3ZNl/5+YDslzuw/wo2kE9WWiiOZfdmq4fC5A/DDQEOJiWF4YtZEt8fS9nQd80Ws29a
	 NKJL5cyyACmCxGBFL3GYSXcLh1x3Sh6F33k8K6UK9iGU9gArny28CWExESi96MTik6
	 GU+G6fyio/5NQ==
Date: Thu, 24 Oct 2024 23:35:20 -0700
Subject: [PATCH 4/8] xfs_db: access realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773789.3041229.10050634092165024838.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to point the io cursor at the realtime
device, let's make it so that the "dblock" command can walk the contents
of realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |   17 +++++++++++++++--
 db/faddr.c |    4 +++-
 2 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/db/block.c b/db/block.c
index 6ad9f038c6da67..ff34557a612a2f 100644
--- a/db/block.c
+++ b/db/block.c
@@ -196,6 +196,13 @@ dblock_help(void)
 ));
 }
 
+static inline bool
+is_rtfile(
+	struct xfs_dinode	*dip)
+{
+	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+}
+
 static int
 dblock_f(
 	int		argc,
@@ -235,8 +242,14 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
-		nb * blkbb, DB_RING_ADD, nex > 1 ? &bbmap : NULL);
+	if (is_rtfile(iocur_top->data))
+		set_rt_cur(&typtab[type], (int64_t)dfsbno << mp->m_blkbb_log,
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
+	else
+		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
 	free(bmp);
 	return 0;
 }
diff --git a/db/faddr.c b/db/faddr.c
index ec4aae68bb5a81..fd65b86b5e915d 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -323,7 +323,9 @@ fa_drtbno(
 		dbprintf(_("null block number, cannot set new addr\n"));
 		return;
 	}
-	/* need set_cur to understand rt subvolume */
+
+	set_rt_cur(&typtab[next], (int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
+			DB_RING_ADD, NULL);
 }
 
 /*ARGSUSED*/

