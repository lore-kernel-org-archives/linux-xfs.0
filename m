Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC0D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881688; cv=none; b=aCnmTbFQ6/z8KWuXWLrp/32lnQrwoN/qeJq8phZxUpFrGYWKF20QVjUonEhpiKtaRDrWRD/oRjs9TFX3AFzFG7wjzPQAiG2PMMAPRSgh8T0IeahRnkA4sU4mm2IJspmpgOa5c4pBuyGfEY+bDNxiTnxh3DAl39PlpJrpSX94K34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881688; c=relaxed/simple;
	bh=yE6I7n0u7gAhzDpnEXStsFeVPmU9aUdrobTEZmriWYo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7/fmdWs2YnpooqcMvlzujqKFxvvCOzQbdGXbp3jw9nPvYUhhZpgpGUtnN2oKURu4NSD0aD1hNcjlAGeGPFe6D5O/1hOujmNZQE/wo4VvUKfx2qIP9T7xmwjkX7s+vEmJDb2n9p2wE6G9Yx7Pqs9wE4mG1UXmjqOiQNESEVr/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amM1Ocyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amM1Ocyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD79BC116B1;
	Tue,  2 Jul 2024 00:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881687;
	bh=yE6I7n0u7gAhzDpnEXStsFeVPmU9aUdrobTEZmriWYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=amM1Ocyuyag7g3I7TLIEMCed1N8Xi+1+9RYm7fqiHU6phV+V7A7nywm4Qp7EJHKm7
	 c6Hj/QtUj0TlLdaEcF0wi0/abpojdxzFL6i9eCgslseDxzM5w4Bsn72JuVVlkkDSTH
	 3KBUSgisqlzNnNTz3OAhPCPvBr84B+qD6LUK72V4kpSOp+yUGsKaUIvTX6aKcEA2lC
	 W+GclsaPNCTBwu7TlsL9oFR2buysJ5I0XozuLp+yE/nbyoi1JCrE4ChGGUBUZV9h1F
	 mi+Zf+eTloZPjWHXUoRbf3ZjGLsljlwejEc6cE9kBOiAk7dsoqjAPpt0Y9QQqxkSmG
	 YA3wD5mmn6XkQ==
Date: Mon, 01 Jul 2024 17:54:47 -0700
Subject: [PATCH 05/12] xfs_db: advertise exchange-range in the version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116786.2006519.17065535694551373149.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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

Amend the version command to advertise exchange-range support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index b48767f47fe9..c39011634198 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -706,6 +706,8 @@ version_string(
 		strcat(s, ",NEEDSREPAIR");
 	if (xfs_has_large_extent_counts(mp))
 		strcat(s, ",NREXT64");
+	if (xfs_has_exchange_range(mp))
+		strcat(s, ",EXCHANGE");
 	return s;
 }
 

