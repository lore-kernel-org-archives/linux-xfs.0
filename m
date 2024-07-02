Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8671A8BE2
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882845; cv=none; b=K3OSPh3Gux9lqw3G4GEsRUk/74mKpp3NIZS0Oae8wNPHqYw9hGfQzK8aK/Q1y8VMBdshkmB3O7vOxMVweZfvvwUkZyUQ40AXn9hvdZthK4eqRaH1eGP4KeMV7H2GSq8BnXj2/0PWwmmZ4rQ9D/bhlgYIOIBdQNfskJNmWdPVscY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882845; c=relaxed/simple;
	bh=u/qgYqcFuq90H1YCmaR6ejeF7k52AVhghPEc/hOq9Gc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G84RO0X6EfB+aD6xhIR+Wz7UGuMZrUzIZWPYBk7bRK+YE4ME6UK4beBwz1i9WbWz+eEd2Ai7FMB4mvTK5lp0PFoNWKppnO0D2Dy1f0LJL2iCg1zr+PhqfcIfSCA6z7UyPP/guNPivbRdvRwICdbZvqGaWUyTqBuLcP79xWAsQxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hggEtzMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hggEtzMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE51C116B1;
	Tue,  2 Jul 2024 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882845;
	bh=u/qgYqcFuq90H1YCmaR6ejeF7k52AVhghPEc/hOq9Gc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hggEtzMg9E2Rtp0rXGuNGK4fy2/EB7NRyJaWuPz3JTAU0wHTWTzRxAEXjflA8X5Jr
	 nBkWZv/ubjR1Bmd0hwn9d0I0hKYVcUk+gm/r6Fj/w2rgxAxHQkcwLv3+Yo2YlCccSC
	 o0VjMzekfFLITgK5o2UUzvfpPaEHb2xAQjJvpiC35sbnMV3QQlrXBh0aLhcDmG23eL
	 PfevO4Ds2lhpochPVOCpVfSjZc7ojrUDgsTfOLx6f1MYCfHAFIRdhx2O70TATVVhof
	 iSnM8HZ1puWmAT4CTaLGtuo3hRv8ckZYg9To0aneIWq6A7jM9Nt/DowJP/6ptIKHmp
	 NWhM14uPJzQrQ==
Date: Mon, 01 Jul 2024 18:14:04 -0700
Subject: [PATCH 13/24] xfs_db: report parent pointers in version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121263.2009260.1429651097097993711.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Report the presents of PARENT pointers from the version subcommand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index c39011634198..7836384a1faa 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -708,6 +708,8 @@ version_string(
 		strcat(s, ",NREXT64");
 	if (xfs_has_exchange_range(mp))
 		strcat(s, ",EXCHANGE");
+	if (xfs_has_parent(mp))
+		strcat(s, ",PARENT");
 	return s;
 }
 

