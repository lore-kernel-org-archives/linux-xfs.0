Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C53C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 05:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BABC520727
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 05:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Jz7cAV9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfKRF0U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 00:26:20 -0500
Received: from sender3-of-o52.zoho.com.cn ([124.251.121.247]:21970 "EHLO
        sender2.zoho.com.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725208AbfKRF0T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 00:26:19 -0500
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2019 00:26:18 EST
ARC-Seal: i=1; a=rsa-sha256; t=1574053818; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=CFiTydxXmqD9bMG7v780o3N8ddqWN6K3FCgyTdlTsez+ICLl9SEtemLlO1rFmwdlnFVn0KaMzc1ve2S2pA//ZQDSMywCMchSASZ55qhlGgITwNozY47/lo2c/INkLP4RSjDGEAEdUnzyuSWpR2MhhKkB3r8PeWHkAF6uLKrdeQw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1574053818; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=W+4d37NiUZrTVp/T//URhJAtULIpMWsOCTG3JUgcQbA=; 
        b=SfZrHruFtbvLbpQPjNc72IC+JSlnZfJ+XGA4IFDCxatxJXqhBCbg8JNLUagIec/KDcUIuQTVBtngdQoSW3hkUMbcgLGEpH8Fm+eXwz7ARt58nKunz86ZgaxuRX//6Mv41ix92didw44LkKsvKlQgBBZdKpmg9s6dWyjCHjCQdl8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574053818;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=1801; bh=W+4d37NiUZrTVp/T//URhJAtULIpMWsOCTG3JUgcQbA=;
        b=Jz7cAV9vUe3W4KyujDLRcYQXLcQV6tl7gVqHx1v+Ljon9oHqojtRod0Rc50n5YC5
        ZkEOZtA8Vu7ezLL5/F5sGKbob4KLpIxLDCTIwMJBQFp3pj5hakvhUeJmc/iSvEmO7Gl
        mbdedSI3usWavsqw8+/jaZGYDbtDrn2dLYPcKTdA=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 157405381681740.021350625482796; Mon, 18 Nov 2019 13:10:16 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, jaegeuk@kernel.org, chao@kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191118050949.15629-2-cgxu519@mykernel.net>
Subject: [RFC PATCH 2/3] f2fs: show prjquota info on statfs for a file
Date:   Mon, 18 Nov 2019 13:09:48 +0800
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191118050949.15629-1-cgxu519@mykernel.net>
References: <20191118050949.15629-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently we replace filesystem statistics using prjquota info
on statfs when specified directory has project id inherit flag.
However, statfs on a file(accurately non-dir) which is under the
project quota dir(with inherit flag) still shows whole filesystem
statistics. In container use case, it will give container user
inconsistent experience and cause confusion about available free
space.

Detail info like below:
We use project quota to limit disk space usage for a container
and run df command inside container.

Run df on a directory:

[root /]# df -h /etc/
Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% Mounted=
 on
kataShared=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.0G=C2=A0=C2=A0 13M 1012M=C2=A0=
=C2=A0 2% /

Run df on a file:

[root /]# df -h /etc/exports
Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% Mounted=
 on
kataShared=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.5T=C2=A0 778M=C2=A0 1.5T=C2=A0=
=C2=A0 1% /

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/f2fs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1443cee15863..c5b9a92d606b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1287,8 +1287,9 @@ static int f2fs_statfs(struct dentry *dentry, struct =
kstatfs *buf)
 =09buf->f_fsid.val[1] =3D (u32)(id >> 32);
=20
 #ifdef CONFIG_QUOTA
-=09if (is_inode_flag_set(dentry->d_inode, FI_PROJ_INHERIT) &&
-=09=09=09sb_has_quota_limits_enabled(sb, PRJQUOTA)) {
+=09if ((is_inode_flag_set(dentry->d_inode, FI_PROJ_INHERIT) ||
+=09     !S_ISDIR(dentry->d_inode->i_mode)) &&
+=09    sb_has_quota_limits_enabled(sb, PRJQUOTA)) {
 =09=09f2fs_statfs_project(sb, F2FS_I(dentry->d_inode)->i_projid, buf);
 =09}
 #endif
--=20
2.20.1



