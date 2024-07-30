Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92777621
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299449; cv=none; b=QU+XsirkTAoh2SZ/OKnVURQf9WnTijYJYDwH0P+JiCXywgs30ZjYdLKe5RvV/Ag8RsIHu4YcygfRYLBtzrJfV4owb+Wa336Nydd2Crs9HmR8uDUMbJUG1PVPQKiDeZtlkIl9frGFl+NaFL5EgtSb3FdLdLDtxMh6UFPuSPM5kVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299449; c=relaxed/simple;
	bh=7GtJ2hLxQ5NL+C4VNNj9EnBCXdko7Mkt0R8IG/ecJx0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MsXcxQpBTHucXqVLHf76wh9dib2GfbfyLZ3KSjaE0di4VfcKOBkPaOrlbaINi7hyFivWUDqhj2IVvE9n9/8iklN7kFD4XPlsgCCKI6WpfXXsCJJcZ52eCzlJVM3XREbuTzNCBRK7jjIppXk9vlOr4Dgzuxa2H8kZ9LGKWJwL+GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JR1gzURV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JR1gzURV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE50C4AF07;
	Tue, 30 Jul 2024 00:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299449;
	bh=7GtJ2hLxQ5NL+C4VNNj9EnBCXdko7Mkt0R8IG/ecJx0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JR1gzURV2JvEN6tEn1AZqXCBDPQCI8PidYvcf9myK3Wtty7i2GUIknPVzEcX+GgFv
	 jQ2h34o/dbaXt7BUUmsMQcrjWmh3eq90aNy19Hojb1PU2xCNmL3kQPatMdXboz9mmr
	 f4mPf0VnCYlKkzJ3PdoVCU5+UKO58LCpb0A3DbiRYKOfUzVxyF4BwKaDRsuomy+ZKR
	 y7w6Vt4SmTL473LBGpRJN0pi3XGg/vtJ4ApeLV+hqL5AlwyCSBjxaXS5DcGyD0iOCG
	 I2vV5h6kaeHDzCSh6P+nF35y8MCK81QFMbYH8HcXkEDD1qOTWSpfvFtHz/0XHPWcEL
	 U097DAV0Lh6TA==
Date: Mon, 29 Jul 2024 17:30:49 -0700
Subject: [PATCH 027/115] xfs: check unused nlink fields in the ondisk inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842824.1338752.8524616543740957475.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 40cb8613d6122ca80a9e42e4cecc4d308c3b80fb

v2/v3 inodes use di_nlink and not di_onlink; and v1 inodes use di_onlink
and not di_nlink.  Whichever field is not in use, make sure its contents
are zero, and teach xfs_scrub to fix that if it is.

This clears a bunch of missing scrub failure errors in xfs/385 for
core.onlink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_buf.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 82cf64db9..aee581d53 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -488,6 +488,14 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
+	if (dip->di_version > 1) {
+		if (dip->di_onlink)
+			return __this_address;
+	} else {
+		if (dip->di_nlink)
+			return __this_address;
+	}
+
 	/* don't allow invalid i_size */
 	di_size = be64_to_cpu(dip->di_size);
 	if (di_size & (1ULL << 63))

