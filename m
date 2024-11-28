Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7EC18E25
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 02:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732760983; cv=none; b=BaQjEdVdD4+Q4eywmjHjf0o4bF1As68jHC0Xv3kYjO3qyKoTpAJxYEL81xcKam/yk0yELcaEDlq7l3swnvcwcQwBXgd5KOtxE1MLxIpD1NZOJXOFN9YwwS7Ln1jlB12UrXDFnIAA3ZIisOEcj3TNF77STX8A+HWs6WkEdY4sAWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732760983; c=relaxed/simple;
	bh=bkVJ4OpPORjzjrBUkLn+cHuMt9w48zL7LJ4EP9vWDLI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AcZGEGcOmxmtL7BfnQqKu+h0WduRyX8NUW886F2Jadj+iZ5S+6rwPQC3nFLPbXhp1Oz2rzDPiCkIW+pRvtNl1a7jn6TbZ+1kGgR9RiJNvFIgp308u6IQjUUdcAdkEOw8j02WUruQXDf999cZsxWgTYIVI7R5akjkn4J/PG/nxT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzeqC7y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzeqC7y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3972C4CECC;
	Thu, 28 Nov 2024 02:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732760982;
	bh=bkVJ4OpPORjzjrBUkLn+cHuMt9w48zL7LJ4EP9vWDLI=;
	h=Date:From:To:Cc:Subject:From;
	b=KzeqC7y2C9LWGKXBVkictvyqfKVJw5TW5bfomfDaGdgWlDbFNxZqQ2RUQE9tyXpA3
	 77Ege3bbSRjDE3uiiQ1JxmkLpd6b4MZ4Lg3dusYIdDvm27yeGtEQ6CAkdDIJ+bcnOE
	 wZnUY/Fpbl6Vnk9DeTKdSJiUMkB6x2YHptL/PKeIU/jhjTFT9zkM9DvvqSrMGfoYcD
	 hEHZpnqeg9VCysgDP9esj5wIaQqFHe9Yf1hfEIsqFZCe7bVSFWuLVfOoZrdr8tSHbk
	 VoJvocht7nXoJMcj2cRu/pFQ43Y+aquMKnY9V8/QGtiO6/Qu2bGZvKVoCTc6/QB20M
	 CE6MwyN3pB/Yw==
Date: Wed, 27 Nov 2024 18:29:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH xfsprogs 6.12] man: document the -n parent mkfs option
Message-ID: <20241128022942.GV9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Document the -n parent option to mkfs.xfs so that users will actually
know how to turn on directory parent pointers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
This fell out at some point when hch and I were refactoring parent
pointers; can this be included in 6.12?
---
 man/man8/mkfs.xfs.8.in |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index a854b0e87cb1a2..95b3d42700cf0e 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -900,8 +900,20 @@ .SH OPTIONS
 
 When CRCs are enabled (the default), the ftype functionality is always
 enabled, and cannot be turned off.
 .IP
 In other words, this option is only tunable on the deprecated V4 format.
+.TP
+.BI parent= value
+This feature creates back references from child files to parent directories
+so that online repair can reconstruct broken directory files.
+The value is either 0 to disable the feature, or 1 to create parent pointers.
+
+By default,
+.B mkfs.xfs
+will not create parent pointers.
+This feature is only available for filesystems created with the (default)
+.B \-m crc=1
+option set.
 .RE
 .PP
 .PD 0
