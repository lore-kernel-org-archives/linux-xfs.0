Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9806345C18;
	Thu, 20 Jun 2024 07:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718869433; cv=none; b=e4vCL90LTHoKk88MwCz8VCuRAVTr0y+3ahKpbHNbUq1kCEWwvUGjA6MNYNRZKExNtEapj0ik7TLRb10Mju4iJmawGlZLFeKS1Hrxp9WoiUkrp3P/8hAeYD0ZWaJ7escfMnoVPLmUkuKEAZOIuO0w2xK+FunWWrlo75oBIWDCGGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718869433; c=relaxed/simple;
	bh=2wZuP2tGNgUyHH0sO6Iikxk/kDANcJqGrqJ9vQBGR2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZUFqK4TQ5cFhjrkhhLZJH3bjgLsARBhOXCzKZQsStpx2kkL2nTW2ElCc+MVazdsn3YdihsExAbmKUevPFFgj/hlLYBXdec5SuEQh0OTihWRRHwIOobQRaFL813udpMg2vodL0uVXR1Ng4HDG6Wif/oLh1UAcCm/4aJ7HbZuZFog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: cd3f94202ed811ef9305a59a3cc225df-20240620
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:1823fc96-0938-45f2-86a2-8f5271a1870a,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.1.38,REQID:1823fc96-0938-45f2-86a2-8f5271a1870a,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:82c5f88,CLOUDID:f45b09256ab3039538acd0274731d486,BulkI
	D:240620153437FZVNTPXL,BulkQuantity:1,Recheck:0,SF:66|38|24|72|19|44|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:11|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_ULN
X-UUID: cd3f94202ed811ef9305a59a3cc225df-20240620
Received: from node4.com.cn [(39.156.73.12)] by mailgw.kylinos.cn
	(envelope-from <shaozongfan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 416432350; Thu, 20 Jun 2024 15:43:36 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id 0E56516002081;
	Thu, 20 Jun 2024 15:43:36 +0800 (CST)
X-ns-mid: postfix-6673DDA7-866860212
Received: from localhost.localdomain (unknown [172.30.110.47])
	by node4.com.cn (NSMail) with ESMTPA id 8047316002081;
	Thu, 20 Jun 2024 07:43:35 +0000 (UTC)
From: shaozongfan <shaozongfan@kylinos.cn>
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	shaozongfan <shaozongfan@kylinos.cn>
Subject: [PATCH] xfs: fix a NULL pointer problem
Date: Thu, 20 Jun 2024 15:43:13 +0800
Message-Id: <20240620074312.646085-1-shaozongfan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

when a process using getdents64() api to get a Folder inside
the file directory,meantime other process delete the file
directory.it would cause an error like this:

[  100.640099] Unable to handle kernel NULL pointer dereference at virtua=
l address 0000000000000001
[  100.641246] Mem abort info:
[  100.641636]   ESR =3D 0x96000007
[  100.642057]   Exception class =3D DABT (current EL), IL =3D 32 bits
[  100.642815]   SET =3D 0, FnV =3D 0
[  100.643235]   EA =3D 0, S1PTW =3D 0
[  100.643664] Data abort info:
[  100.644063]   ISV =3D 0, ISS =3D 0x00000007
[  100.644574]   CM =3D 0, WnR =3D 0
[  100.644984] user pgtable: 64k pages, 48-bit VAs, pgdp =3D 000000001351=
05a5
[  100.645876] [0000000000000001] pgd=3D00000001ac6b0003, pud=3D00000001a=
c6b0003, pmd=3D00000001aad30003, pte=3D0000000000000000
[  100.647204] Internal error: Oops: 96000007 [#1] SMP
[  100.647843] Modules linked in: binfmt_misc fuse devlink xt_CHECKSUM ip=
t_MASQUERADE ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_rejec=
t_ipv4 xt_conntrack ebtable_nat ip6table_nat nf_nat_ipv6 ip6table_mangle =
tun bridge ip6table_raw ip6table_security stp llc iptable_nat nf_nat_ipv4=
 nf_nat iptable_mangle iptable_raw iptable_security nf_conntrack nf_defra=
g_ipv6 nf_defrag_ipv4 rfkill ip_set nfnetlink ebtable_filter ebtables ip6=
table_filter ip6_tables iptable_filter sch_fq_codel sunrpc vfat fat ip_ta=
bles sr_mod cdrom virtio_gpu virtio_console virtio_net virtio_scsi net_fa=
ilover failover dm_mirror dm_region_hash dm_log gb
[  100.654877] Process getdents (pid: 6455, stack limit =3D 0x00000000a82=
41109)
[  100.655759] CPU: 0 PID: 6455 Comm: getdents Kdump: loaded Tainted: P  =
         OE     4.19.90-25.10.v2101.ky10.aarch64 #1
[  100.657418] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/=
2015
[  100.658484] pstate: 80000005 (Nzcv daif -PAN -UAO)
[  100.659297] pc : xfs_dir2_sf_get_parent_ino+0x1c/0x30
[  100.660093] lr : xfs_dir2_sf_getdents.isra.0+0xd8/0x248
[  100.660922] sp : ffff80016eda3bd0
[  100.661476] x29: ffff80016eda3bd0 x28: ffff800167c4d900
[  100.662310] x27: 0000000000000000 x26: 0000000000000000
[  100.663149] x25: 0000000000000000 x24: ffff800174ca5000
[  100.663980] x23: 000000000000000a x22: 0000000000000000
[  100.664822] x21: ffff800161337780 x20: ffff8001437b8000
[  100.665647] x19: 0000000000000000 x18: 0000000000000000
[  100.666482] x17: 0000000000000001 x16: 0000000000000000
[  100.667328] x15: 0000000000000000 x14: 0000000000000000
[  100.668159] x13: 0000000000000000 x12: 0000000000000000
[  100.668985] x11: 0000000000000000 x10: 0000000000000000
[  100.669816] x9 : 0000000000000000 x8 : 0000000000000000
[  100.670643] x7 : 0000000000000000 x6 : ffff8001704a6414
[  100.671517] x5 : 0000000000000004 x4 : 0000000004195704
[  100.672355] x3 : 000000000000002e x2 : 0000000000000001
[  100.673181] x1 : 0000000000000002 x0 : ffff0000084cda20
[  100.674007] Call trace:
[  100.674427]  xfs_dir2_sf_get_parent_ino+0x1c/0x30
[  100.675168]  xfs_dir2_sf_getdents.isra.0+0xd8/0x248
[  100.675943]  xfs_readdir+0x184/0x1d0
[  100.676522]  xfs_file_readdir+0x40/0x50
[  100.677149]  iterate_dir+0x8c/0x1a8
[  100.677717]  ksys_getdents64+0xb4/0x348
[  100.678335]  __arm64_sys_getdents64+0x28/0x38
[  100.679027]  el0_svc_common+0x78/0x130
[  100.679640]  el0_svc_handler+0x38/0x78
[  100.680249]  el0_svc+0x8/0x1b0
[  100.680756] Code: aa0003f3 aa1e03e0 d503201f 91000a61 (39400660)
[  100.681720] SMP: stopping secondary CPUs
[  100.684250] Starting crashdump kernel...
[  100.684868] Bye!

Signed-off-by: shaozongfan <shaozongfan@kylinos.cn>
---
 fs/xfs/xfs_dir2_readdir.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 9f3ceb461515..db6c910cad96 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -51,7 +51,7 @@ xfs_dir2_sf_getdents(
 	struct xfs_mount	*mp =3D dp->i_mount;
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp, *sfp1;		/* shortform structure */
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
@@ -93,7 +93,10 @@ xfs_dir2_sf_getdents(
 	 * Put .. entry unless we're starting past it.
 	 */
 	if (ctx->pos <=3D dotdot_offset) {
-		ino =3D xfs_dir2_sf_get_parent_ino(sfp);
+		sfp1 =3D sfp;
+		if (sfp1 =3D=3D NULL)
+			return 0;
+		ino =3D xfs_dir2_sf_get_parent_ino(sfp1);
 		ctx->pos =3D dotdot_offset & 0x7fffffff;
 		if (!dir_emit(ctx, "..", 2, ino, DT_DIR))
 			return 0;
--=20
2.25.1

