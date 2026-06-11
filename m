Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAF33BE63F
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186708; cv=none; b=o24uZWrdj///ewVIOdLzZhPA6sQF0ozS1i3xiQiPPwMqmW3Ygsh4FabaoLWU7VACIbTZieXsL/LJ4RPcZJwHqd5fM1j56MqbWHv3RBaR7e4CwqjU3266mdymPwcqor0k8nbUzm7nu3frtmaMnhwMm0HEsqSJxu8GrMU3kqXiUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186708; c=relaxed/simple;
	bh=dcMkHvoNgxGb5PXv991Awe9naKU0zth4DyDgWD0FvSA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eudft8wDR4RyHEbewdJuoz4qLkpsROj/BR3o4djSUeMcT0DOi+GQzXXR2jFjUSyeqlo2nqiz7eb82jN/UnZhIaN1fQq5CTD6nGyewuhWd7wSuIOaUdv5dPRN8Vtre9LKuhnTjYbiBKqnBdh5/xl5wK+YiqQqsap/jqvNZefvjLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+2jD9o4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+2jD9o4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD3501F00893;
	Thu, 11 Jun 2026 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186706;
	bh=HP2Uaahludg7BAWpacwGf/ubozn8BkhDFtKkXumtkn0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=R+2jD9o4MWGHfdYz69CScPwgGYG9TkrlpH/mLkZFNfydwJrpY46AcamK+U/n7gEPq
	 Eixa4lKowKbUHf+Dt5aiIeOfI+CE7VZWU6PylaAp4/MUlGD3G99SlQSWEZwCsp5pSI
	 sUjqasjCBkqhTAmcdyWpzqiEneeoc5KcT3Jf6HbMgsWbJwFB51nEwqRrbYq+jDp/wY
	 0rlCJTu7g4VU/P+B79OkSY2XKCG19IYdtNfGOBiSmR/X5M8YdS8eTPrbN6DI0ArEqM
	 l75EBJ4Ktu7SDGCIxCBNe5ZjIl1pc4SKhctGVv6vOPVod1r9o2JbuIIOUcNsUVHmhj
	 Cqd5R3+obotMA==
Date: Thu, 11 Jun 2026 07:05:06 -0700
Subject: [PATCH 1/6] libfrog: fix buffer overflow in getparents path_to_string
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661261.728615.14375517216210339386.stgit@frogsfrogsfrogs>
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out rather indirectly that snprintf returns the number of
bytes that would be formatted into the buffer excluding the null
terminator.  However, it won't format more bytes than the size
parameter, so the proper way to detect overflows is to compare the
return value against the size parameter.  Fix that.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 56f6ba21e97756 ("libfrog: add parent pointer support code")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/getparents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libfrog/getparents.c b/libfrog/getparents.c
index e8f545392634e4..8a53c64332c839 100644
--- a/libfrog/getparents.c
+++ b/libfrog/getparents.c
@@ -355,7 +355,7 @@ path_to_string(
 		mntpt_len--;
 
 	ret = snprintf(gpi->buf, gpi->len, "%.*s", mntpt_len, mntpt);
-	if (ret != mntpt_len)
+	if (ret >= gpi->len)
 		return ENAMETOOLONG;
 	gpi->written += ret;
 

