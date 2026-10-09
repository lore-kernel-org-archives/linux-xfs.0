Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE553C819C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590008; cv=none; b=OKv+3I+Ih6gjUiRCjNlkYH1CKkSaMACvR3GAVvYSPzQ/9GYy/Z9+Z1PhbOJnfi9AxK4OL6cED0NVFeWIvU7JfQDw4Je0hv5Aigm0QMouBUzdR5IaPgPsdIFewPkCz97z+ihAB25qBXBEkJUH+G3liTrPyiclxJWERyiwFSKxnoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590008; c=relaxed/simple;
	bh=bvrlGLzj7ykiWZqDO4F49CeMBiz4ksPzUzK6NhZTnG8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IeYm3dJ1ZFlJhREY2jM9v65CntRUH5eSH95+kOPjdhl9fYCZkG0rrZqjgUi4HQS4HibbFqhACq+d+4DULlSozUmuj+QlW5hzd3XpEf2aSWKx/HBGqd6+PLq00iKq5TwF4LnrMP6lD/fAlyEsXp7O7A8tfCTFcgqUWdKwczXyoTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmWiw9J5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmWiw9J5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 095D31F000FF;
	Fri,  9 Oct 2026 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791590007;
	bh=PyY+nHH4hm5+FNc0ctBgdgE9x20Fgdob8xI1aR4yDTA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YmWiw9J5k1Eaaxj65Oh0tU7vri68sYUez4nRREQuX6rx23hrArs+bfX9GfT7ZLWaz
	 ihbV2tK8KRhYSnBwSaqD8oywJZvoG/EujqGA7CKynKTHgXfaZD1s60TQ4UCxSG82Az
	 +Ftoiu55a+6pr84BFYBS5x6ECd1yxYkD4y1+jay5Ci2z6Pm+KU0DcVCCiOyRlLl4xc
	 DyQIHVZVL9EHX5vKlp1EVRxyOBrvvUTGmUse056uVwnNGue9G4wVmjLx3vwYOHBn9L
	 hk7bu+Zu3RZI0oKP2lDO+Cy5wKWqAWk0yDNc6MXEF3qda/MJgcp3j9ymb66cqbuT6/
	 5U9YNY+Xj2ADg==
Date: Fri, 09 Oct 2026 16:53:26 -0700
Subject: [PATCH 2/3] mkfs: add config file for the 2026 LTS kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948318.3720929.17786050362980005785.stgit@frogsfrogsfrogs>
In-Reply-To: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a config file for 7.3 since it'll be the LTS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/Makefile     |    3 ++-
 mkfs/lts_7.3.conf |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_7.3.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 16793bdb1e03e3..b2d99e620c78c4 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -19,7 +19,8 @@ CFGFILES = \
 	lts_6.1.conf \
 	lts_6.6.conf \
 	lts_6.12.conf \
-	lts_6.18.conf
+	lts_6.18.conf \
+	lts_7.3.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_7.3.conf b/mkfs/lts_7.3.conf
new file mode 100644
index 00000000000000..16d1c40e8f8a88
--- /dev/null
+++ b/mkfs/lts_7.3.conf
@@ -0,0 +1,29 @@
+# V5 features that were the mkfs defaults when the upstream Linux 7.3 LTS
+# kernel was released at the end of 2026.
+[block]
+
+[metadata]
+crc=1
+finobt=1
+rmapbt=1
+reflink=1
+inobtcount=1
+bigtime=1
+metadir=0
+autofsck=repair
+
+[data]
+
+[inode]
+sparse=1
+nrext64=1
+exchange=1
+
+[log]
+
+[naming]
+parent=1
+ftype=1
+version=2
+
+[realtime]

