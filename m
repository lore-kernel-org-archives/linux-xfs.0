Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD193286292;
	Wed, 19 Feb 2025 00:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926157; cv=none; b=X5Ts0JRV7C8kln3Mr8LldFNn8GEcz6pzdvQi3mDORXu9TKCUDR/uogQ/mkbb6er3aeCohOOTisFLLqRI7N1Zn2+S6teikQQXg9cLs32H4/J42PZKLi+V4qxKvaMCugyH7CI256MMANGjC2pnwxyJNxX2tVcWzs/hqxwOOaXuGRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926157; c=relaxed/simple;
	bh=3lM42Bq+QmbY7fV3s16uMGQOcNVyZfecabdhUXlgMck=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvraC/11/kx/W3B/WWC546GzWXTgsmpR9H4dGbkcm8cjEiHi135LqGHa9uLzEnjtfmQTydqeApuM0ytD8+50st5Fmp8Yrz69NAtiMbAyvrk9jYsHAoNMs595yQ/SEC0A/4ackGAFClg2g4yMUSh/MtEMhUPxckUPy5SJDojW8Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bobzedmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bobzedmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C51C4CEE2;
	Wed, 19 Feb 2025 00:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926156;
	bh=3lM42Bq+QmbY7fV3s16uMGQOcNVyZfecabdhUXlgMck=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BobzedmdOK//56Lo8TmuTArSpVOQqJNnA1DnusGv6C3ZYd85BaGmK7geRN4+YJgJ1
	 8mfbQPDP+WrDlybRtDIZx+Y3xoq1RZqAcGrrhl+RKsnVd2StC+aQh1T0NjHIDdGTEb
	 hfnnexkCgsGSmPgqgoVMiTcDXG9ETzsswNMr+GYKvZN414HqvUNEX/nU9yKu8mibT2
	 Y5P54zTrF2TXTXR4XXpDHulA2lzNMmCSM/HGjV2kaFxnqy0apEOeHylPsjqAyAxX8V
	 CCZks/zpz0U+9Sy/Fe77dy7dNqnqU8cjLCOAVG8+0omaLKOVuqH9U2pJbn0/sSwnvP
	 qKmhpYC0PMybQ==
Date: Tue, 18 Feb 2025 16:49:15 -0800
Subject: [PATCH 1/2] dio-writeback-race: fix missing mode in O_CREAT
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <173992586628.4077946.5512645303623484204.stgit@frogsfrogsfrogs>
In-Reply-To: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
References: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this build error:

In file included from /usr/include/fcntl.h:314,
                 from dio-writeback-race.c:40:
In function 'open',
    inlined from 'main' at dio-writeback-race.c:110:7:
/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:11: error: call to '__open_missing_mode' declared with attribute error: open with O_CREAT or O_TMPFILE in second argument needs 3 arguments
   50 |           __open_missing_mode ();
      |           ^~~~~~~~~~~~~~~~~~~~~~

Cc: <fstests@vger.kernel.org> # v2025.02.16
Fixes: 17fb49493426ad ("fstests: add a generic test to verify direct IO writes with buffer contents change")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/dio-writeback-race.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/src/dio-writeback-race.c b/src/dio-writeback-race.c
index 963ed207fc1b6b..2d3156e5b0974a 100644
--- a/src/dio-writeback-race.c
+++ b/src/dio-writeback-race.c
@@ -107,7 +107,7 @@ int main (int argc, char *argv[])
 		fprintf(stderr, "failed to allocate aligned memory\n");
 		exit(EXIT_FAILURE);
 	}
-	fd = open(argv[optind], O_DIRECT | O_WRONLY | O_CREAT);
+	fd = open(argv[optind], O_DIRECT | O_WRONLY | O_CREAT, 0600);
 	if (fd < 0) {
 		fprintf(stderr, "failed to open file '%s': %m\n", argv[optind]);
 		goto error;

