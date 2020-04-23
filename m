Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32D8C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 19:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEABA20724
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 19:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFwwWpJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgDWTe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 15:34:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728700AbgDWTe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 15:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587670496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7AkDKKVwMUktFtrH9xwCO4UQYFEmR3uTm5H5XHSqbtE=;
        b=UFwwWpJWpSGiAisAcx3ObNYG4zfvjAnmJlkPz0b+JNzNNCM6z2SdYF1KOd43sAPwm/KKdl
        yWqryRT8HL3EnL/0TkPZ3YX0ClXn3QO8w0273USm0Vj+X2sGOb/gvz8zL2LItvumz3WdgT
        l93gCuLBkwzozqvKkvWU5agX79OUaJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-poULWfTFOOy7psdij1dnqg-1; Thu, 23 Apr 2020 15:34:52 -0400
X-MC-Unique: poULWfTFOOy7psdij1dnqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACC8C45F
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 19:34:51 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FB635D70C
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 19:34:51 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC] xfs: log message when allocation fails due to alignment
 constraints
Message-ID: <37a73948-ff5a-5375-c2e7-54174ae75462@redhat.com>
Date:   Thu, 23 Apr 2020 14:34:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This scenario is the source of much confusion for admins and
support folks alike:

# touch mnt/newfile
touch: cannot touch =E2=80=98mnt/newfile=E2=80=99: No space left on devic=
e
# df -h mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0      196M  137M   59M  71% /tmp/mnt
# df -i mnt/
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/loop0     102400 64256 38144   63% /tmp/mnt

because it appears that there is plenty of space available, yet ENOSPC
is returned.

Track this case in the allocation args structure, and when an allocation
fails due to alignment constraints, leave a clue in the kernel logs:

 XFS (loop0): Failed metadata allocation due to 4-block alignment constra=
int

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Right now this depends on my "printk_once" patch but you can change
xfs_warn_once to xfs_warn or xfs_warn_ratelimited for testing.

Perhaps a 2nd patch to log a similar message if alignment failed due to
/contiguous/ free space constraints would be good as well?

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203e74fa64aa..10f32797e5ca 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2303,8 +2303,12 @@ xfs_alloc_space_available(
 	/* do we have enough contiguous free space for the allocation? */
 	alloc_len =3D args->minlen + (args->alignment - 1) + args->minalignslop=
;
 	longest =3D xfs_alloc_longest_free_extent(pag, min_free, reservation);
-	if (longest < alloc_len)
+	if (longest < alloc_len) {
+		/* Did we fail only due to alignment? */
+		if (longest >=3D args->minlen)
+			args->alignfail =3D 1;
 		return false;
+	}
=20
 	/*
 	 * Do we have enough free space remaining for the allocation? Don't
@@ -3067,8 +3071,10 @@ xfs_alloc_vextent(
 	agsize =3D mp->m_sb.sb_agblocks;
 	if (args->maxlen > agsize)
 		args->maxlen =3D agsize;
-	if (args->alignment =3D=3D 0)
+	if (args->alignment =3D=3D 0) {
 		args->alignment =3D 1;
+		args->alignfail =3D 0;
+	}
 	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
 	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
 	ASSERT(args->minlen <=3D args->maxlen);
@@ -3227,6 +3233,13 @@ xfs_alloc_vextent(
=20
 	}
 	xfs_perag_put(args->pag);
+	if (!args->agbp && args->alignment > 1 && args->alignfail) {
+		xfs_warn_once(args->mp,
+"Failed %s allocation due to %u-block alignment constraint",
+			XFS_RMAP_NON_INODE_OWNER(args->oinfo.oi_owner) ?
+			  "metadata" : "data",
+			args->alignment);
+	}
 	return 0;
 error0:
 	xfs_perag_put(args->pag);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a851bf77f17b..29d13cd5c9ac 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -73,6 +73,7 @@ typedef struct xfs_alloc_arg {
 	int		datatype;	/* mask defining data type treatment */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
+	char		alignfail;	/* set if alloc failed due to alignmt */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
 } xfs_alloc_arg_t;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fda13cd7add0..808060649cad 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3563,6 +3563,7 @@ xfs_bmap_btalloc(
 	args.mp =3D mp;
 	args.fsbno =3D ap->blkno;
 	args.oinfo =3D XFS_RMAP_OINFO_SKIP_UPDATE;
+	args.alignfail =3D 0;
=20
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen =3D min(ap->length, mp->m_ag_max_usable);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7fcf62b324b0..e98dcb8e65eb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -685,6 +685,7 @@ xfs_ialloc_ag_alloc(
 		 * but not to use them in the actual exact allocation.
 		 */
 		args.alignment =3D 1;
+		args.alignfail =3D 0;
 		args.minalignslop =3D igeo->cluster_align - 1;
=20
 		/* Allow space for the inode btree to split. */

