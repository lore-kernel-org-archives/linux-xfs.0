Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB6155726;
	Fri, 21 Jun 2024 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718951806; cv=none; b=uLYMISjPMVwwuvQaNkM5AjaYYCJWpGBHFmD/w1lPIcKv6dGFGF4UJWOfZ00BYr4/ooTnBoUX3luD6anijUQMbUh+xJymIi0v647N3HU1Zo+rCsYfXOwRDaNi32RlQgfbQ5C4KjXjX0XEf2Zqme4Pw65P9LVPFch2sja8a7j2QJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718951806; c=relaxed/simple;
	bh=SeOA9xWxKKzQPlgCO/8S9Eg4rEDvcft1OMFHJ0h3Dd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZfKGzDKxgvB7ipFlCH1YQ7SrsomTKiKWaiWoOMBpeovvBUsF9E0Lun+rfVN5YuKeuIZwakTlqF2rB1lcZknz8INRZ8LjVqJhM/CzEoboYI7mYUet+3v8xmLTiLYmBPMfZjb0jnfEsPtzCFnCCqizb5wvDpKPtfGZYKjyvOZ7ztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9b3d93762f9811ef9305a59a3cc225df-20240621
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:38f83400-ebcd-457b-95e2-bff20ceb7e73,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.1.38,REQID:38f83400-ebcd-457b-95e2-bff20ceb7e73,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:82c5f88,CLOUDID:efbffc488a517e55c9999e9aeaa54cd3,BulkI
	D:2406211432491TQQYW5Q,BulkQuantity:1,Recheck:0,SF:57|66|24|72|19|44|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR
X-UUID: 9b3d93762f9811ef9305a59a3cc225df-20240621
Received: from node4.com.cn [(39.156.73.12)] by mailgw.kylinos.cn
	(envelope-from <shaozongfan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 295107956; Fri, 21 Jun 2024 14:36:35 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id 828DC16002082;
	Fri, 21 Jun 2024 14:36:35 +0800 (CST)
X-ns-mid: postfix-66751F73-442141348
Received: from localhost.localdomain (unknown [172.30.110.47])
	by node4.com.cn (NSMail) with ESMTPA id 10E0316002082;
	Fri, 21 Jun 2024 06:36:33 +0000 (UTC)
From: shaozongfan <shaozongfan@kylinos.cn>
To: hch@infradead.org
Cc: chandan.babu@oracle.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	shaozongfan <shaozongfan@kylinos.cn>
Subject: [PATCH] xfs:trigger a-NULL-pointer-problem
Date: Fri, 21 Jun 2024 14:34:53 +0800
Message-Id: <20240621063452.516357-1-shaozongfan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ZnPjpCovlQq7_ptP@infradead.org>
References: <ZnPjpCovlQq7_ptP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>Can you share your reproducer?
Sorry ,beacuse some reason real reproducer can't share you,
But i simulate a reproducer in fllow patch and attachments=20

> if (ctx->pos - ino =3D xfs_dir2_sf_get_parent_ino(sfp);
> + sfp1 =3D sfp;
> + if (sfp1 =3D=3D NULL)
> + return 0;
> + ino =3D xfs_dir2_sf_get_parent_ino(sfp1);

> This looks ... odd. Assigning one pointer variable to another
> doesn't revalidate anything. And xfs_dir2_sf_getdents is called
> with the iolock held, which should prevent xfs_idestroy_fork
> from racing with it. And if for some reason it doesn't we need
> to fix the synchronization.
In this problem, not if_data =3D NULL, but if_root =3D NULL.
Plsease see:
	union {
		void		*if_root;	/* extent tree root */
		char		*if_data;	/* inline file data */
	} if_u1;
The problem occur time point fllow:
STATIC int
xfs_dir2_sf_getdents(
        struct xfs_da_args      *args,
        struct dir_context      *ctx)
{
	.......
line63	ASSERT(dp->i_df.if_u1.if_data !=3D NULL);
                   *** if_root =3D NULL ***    	                        =20
line96  ino =3D xfs_dir2_sf_get_parent_ino(sfp);
        ......
}

Why add a poniter sfp1?
if_data and if_root share a address,
But sfp1 don't share,when if_root =3D NULL,
sfp1 can Make sure there is no null pointer=E3=80=82

Signed-off-by: shaozongfan <shaozongfan@kylinos.cn>
---
 fs/xfs/xfs_dir2_readdir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9f3ceb461515..13675db04042 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
 #include "xfs_error.h"
+#include "xfs_linux.h"
=20
 /*
  * Directory file type support functions
@@ -88,7 +89,8 @@ xfs_dir2_sf_getdents(
 		if (!dir_emit(ctx, ".", 1, dp->i_ino, DT_DIR))
 			return 0;
 	}
-
+	if (xfs_params.fstrm_timer.val =3D=3D 2666)
+		dp->i_df.if_u1.if_root =3D NULL;
 	/*
 	 * Put .. entry unless we're starting past it.
 	 */
--=20
2.25.1

