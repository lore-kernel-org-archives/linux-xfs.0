Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F345199E89
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291341; cv=none; b=GMPfjxFMVP07x1VjLN886aScFiaPQoY0Li0ag0tQ8G685HWu96/P/AmIs99Xe9cHB2vAcSAjxFeAF2uDKePG6YhvvpT2C/+JZFsENioT6x0V+JyOkgTu2L50s89YxzYSDo8e4PT3foiOzohTYFR5ZAjqUKHX1nQdxUTTvBRUpf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291341; c=relaxed/simple;
	bh=QIw7FIt2UxQFfw564EFsT25hq7NNPJQEozHGX+kyk0o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A83SkQoyTdfy+9XT79jE5cIiqaLZIu4bNQABBP3bgypm7dvPs70RJdBJ6M39VdQoTKhjz4smQiE+zjHFva58TtR2pXRNTRCtOJFhP5WrgPFUPPli01W0LSxOEVwMi9zeLG3KZI05IzzKVmXii9gSH2rv81CHdY95Ox8lyMMNv1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/OR+ssh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/OR+ssh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8F4C2BCB8;
	Mon, 23 Mar 2026 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291341;
	bh=QIw7FIt2UxQFfw564EFsT25hq7NNPJQEozHGX+kyk0o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O/OR+sshR1PZUS5MHivD09oAevXqiah2INvC0oni2pNqGJ509EGMDaDEIo8Ol6IGN
	 NigmZZu2dWbxyHPBCPFJ9RYRYi8xJh/P1eeouVPeS1JPpTAV3a4qPUr3gVvyq8c9om
	 PX6VdU8hWetOEOwlnR3XeWpxgY4Mgf6Qd9sb2sFBb5Ywy5HrZESFXQfR2VFgn78rFT
	 Fm8qfFpsKKs6y6iH1cSLe6Tpjk0NtDYfxWE2Vx4F8iOmWC5Qs7KBSnDtARid78nAKn
	 nfjHd0tyKkAXc9C81x/Zmayr6TdIrhvE3zvBHP3NuhYMEDZJGwytXXy1WTRl3DQW+q
	 cxlW/sDXOg/qg==
Date: Mon, 23 Mar 2026 11:42:19 -0700
Subject: [PATCH 04/40] libfrog: fix missing gettext call in current_fixed_time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120811.2266274.5951436397416404749.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This error message can be seen by regular users, so it should be looked
up in the internationalization catalogue with gettext.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libfrog/util.c b/libfrog/util.c
index d49cf72426f6c8..5bae5bab46f91d 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -83,8 +83,8 @@ current_fixed_time(
 			epoch = strtoll(source_date_epoch, &endp, 10);
 			if (errno != 0 || *endp != '\0') {
 				fprintf(stderr,
-			"%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n",
-				progname, source_date_epoch);
+ _("%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n"),
+						progname, source_date_epoch);
 
 				return false;
 			}

