Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18BC1862
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063576; cv=none; b=NCIbcmjcM1LGJxB1gEqIvB1NlrngG1jHnaecBV7yG/tYz2LvG3lyuPWf6BA0xMcFblOdCgZSrbyg6GqnuT14BH8c7TTdh1ekGw4BdHmNYqLqIO9cCuI9nQ9MYylQbjYIKgZJi6LDkDPmv3W/471GPftUeBDZ9Bnxplk9YkNSegk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063576; c=relaxed/simple;
	bh=0Tq1dBj50r8t0p4f/GbpiltLenVOdsnTIhMegwpiIrk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iT73FxrXORbcI3hX8T1j4maQSuy3oIz09D9Hieq2u0tifdlCe+qJq2tIBgYM8O+U4pNSv0WEnkIURayk6kXi1mVSR1hlma/R2z0fBRfuUdZxB6p4JkRe180Kp+cJgAILZUJB2MAmKlI9Oq4kc4lTtaAZNjhW3EL1eyKN5jTPGyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUDU9YAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUDU9YAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ED0C4CED6;
	Thu, 16 Jan 2025 21:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737063574;
	bh=0Tq1dBj50r8t0p4f/GbpiltLenVOdsnTIhMegwpiIrk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mUDU9YAEJWmmr4q03876BLNI+fcrucmb1rqIp6g2ca8Xe9VY6eFnrWBpzJZTuvMsu
	 ljRoqSiRgAvokwYX6UV9jd8GcRUS2rb8dfOQ7VjVULN16W79boaT/z+i59NRPzWTEu
	 KwbBxOBwBa6++7SlcS2yS3MkJ4Q+WV1oFhNaIxMQEFvdP8aIUu9URKwx33IzsYBRfO
	 iIC+eJ287+S0Zw15Q6gVYhf3LftgEcnVFRmTrJrsEAgnglVH94N04JQIaH2uU9PPBy
	 mT6g8TQq/nYaZn5y/D+CfRLkR0zVBDGlXmcGfhueVZ/K9tjf6JSFuI0xIHLiLj8Dbu
	 IA/iFisHT8pWw==
Date: Thu, 16 Jan 2025 13:39:34 -0800
Subject: [PATCH 4/8] xfs_db: improve error message when unknown btree type
 given to btheight
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173706332266.1823674.6627837665243659732.stgit@frogsfrogsfrogs>
In-Reply-To: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
References: <173706332198.1823674.17512820639050359555.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

I found accidentally that if you do this (note 'rmap', not 'rmapbt'):

xfs_db /dev/sda -c 'btheight -n 100 rmap'

The program spits back "Numerical result out of range".  That's the
result of it failing to match "rmap" against a known btree type, and
falling back to parsing the string as if it were a btree geometry
description.

Improve this a little by checking that there's at least one semicolon in
the string so that the error message improves to:

"rmap: expected a btree geometry specification"

Fixes: cb1e69c564c1e0 ("xfs_db: add a function to compute btree geometry")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/btheight.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/db/btheight.c b/db/btheight.c
index 6643489c82c4c9..98165b522e4f6f 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -145,6 +145,12 @@ construct_records_per_block(
 		}
 	}
 
+	p = strchr(tag, ':');
+	if (!p) {
+		fprintf(stderr, _("%s: expected a btree geometry specification.\n"), tag);
+		return -1;
+	}
+
 	toktag = strdup(tag);
 	ret = -1;
 

