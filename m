Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3570445024;
	Tue, 27 Aug 2024 18:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784400; cv=none; b=XwEKnDY1rQ5UlGEVUdbB4FVheTq4II/EJr1FoXNbt03fi+ybgjuEKxpMw20v2xoUSYDsFOhvxkIk0i7GFeaM5pShM34TJt5UAueIgqqQJsVjTLuKUTmwnDj8w4+/jrI0ghLJyrgR8g/D9DcziBLkkvUkyws9PhHp7aTkOYJ5lKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784400; c=relaxed/simple;
	bh=Daumx+b2+l+iYnWKqN+sooVTSb7fT8vnxq4nNrqU5S8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m7KBKgRDhej0mt4wgTMOkd7XyVIMjigDSSOcV8GeeHuvnv4iyADVQsWn1lO/rpfMomPwpYCT8HpGJGW/VghPvzXL8C6tLcxFFpHxfBma0zvbk936SHGe4m+nKl7BqlYek/jUyDRoHt1IJLnsRXQKcOzJMpzpBPmoF00GUuqBJL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5JvaWYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5JvaWYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCA1C4FEA1;
	Tue, 27 Aug 2024 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784399;
	bh=Daumx+b2+l+iYnWKqN+sooVTSb7fT8vnxq4nNrqU5S8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T5JvaWYLCKZ1ECGn6I3Z8PbCdoE1wXTJiTObM27Fg7GVeMAYyVB3bT3PbGq9yt25t
	 uMNX5VIGpjdGlOj8LPUCksRvLjfC+HMuVFp6qCJgzhDEP2+wl1iylHTu/SWwdTVCKw
	 kAMpYl8f7ddiY274CkyyQGEyNbG+w8g9FRzPrx8pqLya7GV5qCnBbUogyGof2gspFL
	 tiGG5t7j0gWz7zMwOJXqjMPowd/8kYN1yQg4urbkhtttdxsw/yzeNSSqXiE2kEWWPf
	 x4Fln08vXzdAAbboxR8OzMfAnlfQzZIXQBgbGvb02TSR2BLjQ6mtPdaZdANdxTv5d2
	 qJ0coIpd+JWOA==
Date: Tue, 27 Aug 2024 11:46:39 -0700
Subject: [PATCH 1/1] xfs/004: fix column extraction code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423017.2039568.10354044892529803918.stgit@frogsfrogsfrogs>
In-Reply-To: <172478423001.2039568.8722356306961050383.stgit@frogsfrogsfrogs>
References: <172478423001.2039568.8722356306961050383.stgit@frogsfrogsfrogs>
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

Now that the xfs_db freesp command prints a CDF of the free space
histograms, fix the pct column extraction code to handle the two
new columns by <cough> using awk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/004 |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/004 b/tests/xfs/004
index 8b2fd9b320..473b82c945 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -82,14 +82,17 @@ then
 fi
 
 # check the 'pct' field from freesp command is good
-perl -ne '
-	    BEGIN	{ $percent = 0; }
-	    /free/	&& next;	# skip over free extent size number
-	    if (/\s+(\d+\.\d+)$/) {
-		$percent += $1;
-	    }
-	    END	{ $percent += 0.5; print int($percent), "\n" }	# round up
-' <$tmp.xfs_db >$tmp.ans
+awk '
+{
+	if ($0 ~ /free/) {
+		next;
+	}
+
+	percent += $5;
+}
+END {
+	printf("%d\n", int(percent + 0.5));
+}' < $tmp.xfs_db > $tmp.ans
 ans="`cat $tmp.ans`"
 echo "Checking percent column yields 100: $ans"
 if [ "$ans" != 100 ]

