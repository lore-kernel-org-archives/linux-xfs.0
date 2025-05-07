Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9257522688B;
	Wed,  7 May 2025 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654848; cv=none; b=vBV7x/yb615+e4bqx8PfIDeZerq0cCDZXWMI4fTZ50TcSfqNb1IsiV2DFCyVn+5Mk17riiA5DzlRsWemtDQjMNxysDy/fp15XPAVGbueSPZRsQFCA3bNnJQUtaj8+y8FxJpvq0JWIIEbZ7t34zJvQwygspNR49zyCwTS6HOh8dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654848; c=relaxed/simple;
	bh=4KKqHxOrKNkwdY7dPW9FFpI854MQIc8MsJmop8h2V+Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUXziMUeeXKP/Z3u9gCb8Ywdsjd1ioN0bMysmp9OKXbw+NRGN+1F6rDi8nDIGHIQ88lzBjO/aG/yQYmuoKd4O47LeJoW9e9b969JZt7HUbsRRtUbCmDHsEfa3zdtDDMdbT+8Vs1zwRB5HIq84d2asdiVHTxsgrJ3z1MSBQrDy+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5bLI9ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5bLI9ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07196C4CEE7;
	Wed,  7 May 2025 21:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746654848;
	bh=4KKqHxOrKNkwdY7dPW9FFpI854MQIc8MsJmop8h2V+Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R5bLI9gaizgj4uR7uGZEBnmeWnT8GaeTd0Dyf7LVdsRGmQyVHTSn2zkrMu6b3E3BD
	 yMqZhX/VUpiLPLLb4+rC4O+0a2QLFGgtnQe0EnAZQaTgSTPXkmFc4YXGXSq8wrCbyG
	 DQI3KqWQkmsAxnlNdQgDb12VXrolE7+sbYD0IaGBntfLKSJXbJBPDmDJTpgZ2g21QD
	 KjWcoK49OblAUZLlgNGiRVSyuLeZ8jL8Wr/3sKNf5xIVleLzQ8ziJ4rtjhPa7mZHBh
	 9ZTr2R4QTFYCh9Wyy7zw0eC83LsYCc6CQ2csoFhTf1XTUbzvBdOzHm+g0AOGTBKwdE
	 MG3SajVXNStiA==
Date: Wed, 07 May 2025 14:54:07 -0700
Subject: [PATCH 1/2] fsstress: fix attr_set naming
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <174665480825.2706436.15433477670941336936.stgit@frogsfrogsfrogs>
In-Reply-To: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
References: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back in 2020 I converted attr_set to lsetxattr, but neglected to notice
that the attr name now has to have the prefix "user." which attr_set
used to append for us.  Unfortunately nobody runs fsstress in verbose
mode so I didn't notice until now, and even then only because fuse2fs
stupidly accepts any name, even if that corrupts the filesystem.

Found by running generic/642 on fuse2fs.

Cc: <fstests@vger.kernel.org> # v2022.05.01
Fixes: 808f39a416c962 ("fsstress: stop using attr_set")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 14c29921e8b0f8..ed9d5fa1efc3d9 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2481,7 +2481,7 @@ attr_remove_f(opnum_t opno, long r)
 void
 attr_set_f(opnum_t opno, long r)
 {
-	char		aname[10];
+	char		aname[32];
 	char		*aval;
 	int		e;
 	pathname_t	f;
@@ -2493,7 +2493,7 @@ attr_set_f(opnum_t opno, long r)
 	init_pathname(&f);
 	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
 		append_pathname(&f, ".");
-	sprintf(aname, "a%x", nameseq++);
+	sprintf(aname, "user.a%x", nameseq++);
 	li = (int)(random() % (sizeof(lengths) / sizeof(lengths[0])));
 	len = (int)(random() % lengths[li]);
 	if (len == 0)

