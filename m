Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334451B4245
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688708; cv=none; b=bAvfBjltOM3X3F8IodOjNgKNQioY/AliACheFkbC0cqRnKEkUbkadTMoEhw8hBmG1dvkJuUp6ModHl9at7+2QBLXm/BMmdFFjSBEGA4wgeQ36yAhcs36D+bYbIb2RTlZTK2O1ww83qmzXMmBQIa2QW11CGMPdrZ0oPbnng4YAmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688708; c=relaxed/simple;
	bh=qzIXa/Rlk9CV2h1vN9erSeGTfGFZNUEwbRH4OpJFyDg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KiNFl/Np18KL69cC97W7WNCsbfIPLj5H1qceZ6hjDxYiA0Pq04Io6vLVIwA7rMQvG4whsTMgDrbLB2QcwbxVxAaM5EqbAdZk99BjqvE4m2MbZgE+CTqGXcUlZO1G5wVkwkyZin9iuN5fBHTLZlU0N/F7BaZ3GcHmL5Y4LvIzhAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpQ3MVOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpQ3MVOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CF0C4CED2;
	Tue, 31 Dec 2024 23:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688706;
	bh=qzIXa/Rlk9CV2h1vN9erSeGTfGFZNUEwbRH4OpJFyDg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XpQ3MVOmD3f2wWRU6xkPyEscaM3ebB1XRTjh7My+gZ4vDO+koWbewvCmbZp6g2ZRT
	 XrMgigYepYTsLNrQoTXSp+UGzrcC5HJcSmDwVPmAHdOELnHU9ykLzULLhDIVNagvIV
	 Ba6CN2htzfll8MOulZuD518RtSL2/l30rrI6NKpGAUQBRL5L2RP9tg4F3DIz+dXgPn
	 tWn2OSEBTtgeenXGjF7Fato6fDP698XhUCJXagOBl6dhlwkVpUz3rPHC6DK591P1EV
	 o5lRstsgSnQZ9a0pYJpBPhUJhAxV61hwpaAu0qrVxXpofo9iIaJ/JQd9Yu8UE1rWwo
	 ILNgP5GrAe50w==
Date: Tue, 31 Dec 2024 15:45:06 -0800
Subject: [PATCH 01/11] xfs_io: display rtgroup number in verbose fsrefs output
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777884.2709794.12247373333506534863.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Display the rtgroup number in the verbose fsrefcounts output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/fsrefcounts.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)


diff --git a/io/fsrefcounts.c b/io/fsrefcounts.c
index ad1f26dfde3ec3..9127f536da382e 100644
--- a/io/fsrefcounts.c
+++ b/io/fsrefcounts.c
@@ -13,6 +13,7 @@
 
 static cmdinfo_t	fsrefcounts_cmd;
 static dev_t		xfs_data_dev;
+static dev_t		xfs_rt_dev;
 
 static void
 fsrefcounts_help(void)
@@ -119,7 +120,7 @@ dump_refcounts_verbose(
 	unsigned long long		i;
 	struct xfs_getfsrefs		*p;
 	int				agno;
-	off_t				agoff, bperag;
+	off_t				agoff, bperag, bperrtg;
 	int				boff_w, aoff_w, tot_w, agno_w, own_w;
 	int				nr_w, dev_w;
 	char				bbuf[40], abuf[40], obuf[40];
@@ -132,6 +133,7 @@ dump_refcounts_verbose(
 	nr_w = 4;
 	tot_w = MINTOT_WIDTH;
 	bperag = (off_t)fsgeo->agblocks * (off_t)fsgeo->blocksize;
+	bperrtg = bytes_per_rtgroup(fsgeo);
 	sunit = (fsgeo->sunit * fsgeo->blocksize);
 	swidth = (fsgeo->swidth * fsgeo->blocksize);
 
@@ -173,6 +175,13 @@ dump_refcounts_verbose(
 				"(%lld..%lld)",
 				(long long)BTOBBT(agoff),
 				(long long)BTOBBT(agoff + p->fcr_length - 1));
+		} else if (p->fcr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
+			agno = p->fcr_physical / bperrtg;
+			agoff = p->fcr_physical - (agno * bperrtg);
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fcr_length - 1));
 		} else
 			abuf[0] = 0;
 		aoff_w = max(aoff_w, strlen(abuf));
@@ -231,6 +240,16 @@ dump_refcounts_verbose(
 			snprintf(gbuf, sizeof(gbuf),
 				"%lld",
 				(long long)agno);
+		} else if (p->fcr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
+			agno = p->fcr_physical / bperrtg;
+			agoff = p->fcr_physical - (agno * bperrtg);
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fcr_length - 1));
+			snprintf(gbuf, sizeof(gbuf),
+				"%lld",
+				(long long)agno);
 		} else {
 			abuf[0] = 0;
 			gbuf[0] = 0;
@@ -420,6 +439,7 @@ fsrefcounts_f(
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
 	xfs_data_dev = fs ? fs->fs_datadev : 0;
+	xfs_rt_dev = fs ? fs->fs_rtdev : 0;
 
 	head->fch_count = map_size;
 	do {

