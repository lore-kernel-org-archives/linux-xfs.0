Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CC1392C3A;
	Tue, 29 Sep 2026 03:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653390; cv=none; b=Spd0zIWSZ++8T9uPDSwntay8L8yfs/o34HarnLP/0fcQuyq6Tmk34WtofZIoP7InFIobvlzAvoEkfU/FKZG8tAxP1sCWzSvkm9rEEYUmqiQukIOoQcM0MYcKcVRVEzsyi/KuZfjRKqNWu7pSVipIc9XJK5xWVxboJYxVXmChgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653390; c=relaxed/simple;
	bh=rZgqwFYUjwIvny8Pu3lHjPvnuFX4DEivlleG/gsbcJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQYtRGNy6WMqVpGI9mQY4ImzY1rKm8bL/xVYwYdt9RC0c6faW114f51Hj7Te3t2yPrAH4u/P1JNROV7M16+CZoxp+uxxn9rWbUvdZlkGx2cAxvKT/03Bktfb5lGOfVT6AsMFkuve4BvmPQzhjJqlyP280YK6oj9sa6W2ZPKow6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=m/bjmYXV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Pxstf1lI; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="m/bjmYXV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Pxstf1lI"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 51A15130193A;
	Mon, 28 Sep 2026 23:43:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 23:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653387;
	 x=1790660587; bh=mN/2SSV8bIw24exSybjBxan284YWLD0YYt6t0Umtf4c=; b=
	m/bjmYXVAasRh0xyF47KEJG7Zmxn+6bI3gtqt6ip5j8TEoMZ9giVbJuvHbF32LqQ
	J1gB7diA96j64dY9ryX7i43LR5NE/GXc6xeEHLMIUsXaApdieqrSshs1tGV7eGIN
	cBUfQXA+T6z0cao/bSPqATRc0x9EDT8ldEERb05yMPmFLsMlN+L72e9O680wJRJZ
	zK7L9yLeSEqtGdum6RwlFdBIeS66RVKw4AAvBo6WoY8CFdqTosftV2pKqhxPvgit
	x2WTD0Y/SNSJJTWkGVgXjDNZ/Wzano1HkG4RwF+n94lSOkPGDOYxUrtjK2wxrbGE
	B8ypvNrW2u15OJmYsv/n/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653387; x=1790660587; bh=m
	N/2SSV8bIw24exSybjBxan284YWLD0YYt6t0Umtf4c=; b=Pxstf1lIaYJ6It2Dt
	XYl09MKu5wXe6DyBDfDoIngstyuriZxvJ66IXljztAMGQlQaTTz8Wzp6hPdCF8bb
	+h2Py2iXvqZ3nuMfdPLVhtcxaefT9HM9QXlb4zifQPYLblx1Zo8b+xcBl4kW/7nt
	xsspas6tl2BRodH/Dz6SRFhmXjGiGpwVJPUrPxRshJibVDKdao9wBMfufPkOCJl8
	HEkWPmseCLuMoKx5AHjwkTeocSsqSAaVRicS/nEjoxk9yj3XlxsQg5q+0cF1F+Hz
	z3eVrnBAdkaSXew2JYNo9t8EW2OdRoRhPvgdaoA9HuZsIIVeu3BDFuWC6a8PCAhQ
	5E41g==
X-ME-Sender: <xms:yjO7ajkdZZgG_2FOAMT9VTx-gp96HOvHEGBSL12mminnsd-upM17rQ>
    <xme:yjO7apzF2ykKaWLA8Y41NVuT9lPJ2l3nvV2vICX5BP8s-bJT_YH6sRa3gc4JqrQcB
    N0bdEmnCNJf8HvNfuO76KNHNEgYu-xC-rjWq54fQ2KnAgXS6Cw>
X-ME-Received: <xmr:yjO7ah2gtRaeh_TqjyDFtWhQyl-uwEL1TCwk8RLpVcQb7_44HnpYW7Nw4nlhQaJ-BF6VLQljZa9aHL9AdC59N5IVaTebT4s>
X-ME-Proxy-Cause: dmFkZTGoJB+17Zq7ThrEPjmxn4ZGYu519RzWwVi/88aejzKjstMboztaed73ef7D6avpE+
    +4ud1a3y7i3orjwLfnXoctNyz4isc8MlqqkCj9w/LgYTxltRiENCW6GCIqrBIGfd6BoOtn
    3U4T9DnMQq0t334tHmkLT0tBGbfhvTaaBwaOBKtxwtl6WpY46qwankbHLMumQlIvXZxJZX
    MK4M+NdZABlSsm1lFGpu8Zoavf0+po6/QQ3FmqOSdXOPNwreWLw4U6EONlQdAFPuoTNGlS
    rFYPmLdcGE1rV4M0fAMpJKofG+st3+8PfQ+b7I9sMwGW86B3jq8HWH1QNmIbUmtd6GqseK
    WXBUUBpFFgHeK9liDg6OqtGpj503qSZRpKFKN80ywKozzDLGfTIpNSRIpB0J7X9j9kdDFo
    NfP0M85lsYUf++BKyCpxcDEiYTPrJoAH8DW5zTa5+tEaGnTn6IQGdE5otaXfk/OhUSHo+d
    QtS1DlHqPu5wnj79Rv5/H8vkxZKWrTFKnHex9Nm3oRCq/HyRSwEmRvgSr1/p+Cr6f7cDut
    lLam5cR2VTzEn2u/ohPNQCHnE/CPKmlmMgCBKphlenALV49psp5KqhSOhI3YnTVHwZ8CPq
    nywlxVlrO0ModMzqKT8z8ZRgDn5Mr5lMOd5yuzk4bhk/SVJdYTVGY/z5TZwQ
X-ME-Proxy: <xmx:yjO7aqbe5DZ8VxR2MCiDyHlEgTOcZIGl1vO_C7cku3RsL4dsa-hY7A>
    <xmx:yjO7aglOV1FYf8Ar4JRQeL1p1eSJDh2_lHjeA5rZ1-qC73jVVm0xnQ>
    <xmx:yjO7arxlwUmw6RkQ7TkEf7ADdVOl3hHllm94VCEYOBw80dbS6Ojbcw>
    <xmx:yjO7ahtWoJe1UDGp4lXvnGnpsSzrSZDqPvF8q4COOagGVNGE_IqCDA>
    <xmx:yzO7as8EEG9-dULRWNj307nfRVakTfkCssSFq__PckHsvznEEqvj2UFg>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:59 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] configfs: remove d_add() calls before configfs_attach_group()
Date: Tue, 29 Sep 2026 13:36:04 +1000
Message-ID: <20260929034158.1455429-5-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

These d_add() calls cannot be necessary.  The inode given is NULL so all
they do is attach the dentry to the hash table.

If configfs_attach_group() fails, then d_drop() is called so the dentry
will be detached.
If configfs_attach_group() succeeds, then
 configfs_attach_group -> configfs_attach_item ->configfs_create_dir
must have succeeded, so d_instantiate() will have been called and the
dentry hashed there.

So the only effect is that the dentry will be hashed-negative for a
short period which will allow a lookup to find nothing without waiting
for the directory i_rwsem.  I can find no indication that this might be
important.

Adding a dentry as negative, and then later making it positive is an
unusual pattern and appears to be unnecessary, so it is best avoided.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/configfs/dir.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 3c88f13f1ca2..145a092171fe 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -715,8 +715,6 @@ static int create_default_group(struct dentry *parent,
 	ret = -ENOMEM;
 	child = d_alloc_name(parent, group->cg_item.ci_name);
 	if (child) {
-		d_add(child, NULL);
-
 		ret = configfs_attach_group(&group->cg_item, child, frag);
 		if (!ret) {
 			sd = child->d_fsdata;
@@ -1901,8 +1899,6 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 	err = -ENOMEM;
 	dentry = d_alloc_name(root, group->cg_item.ci_name);
 	if (dentry) {
-		d_add(dentry, NULL);
-
 		err = configfs_dirent_exists(dentry);
 		if (!err)
 			err = configfs_attach_group(&group->cg_item,
-- 
2.50.0.107.gf914562f5916.dirty

