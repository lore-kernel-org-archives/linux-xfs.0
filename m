Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 56D457CBA
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 11:44:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D07FEAC001
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 09:44:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rhMRusR7GplLepdN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 09:44:46 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 45B948EB3C
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 16:44:45 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u5HGiiq2000615
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 12:44:45 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_copy: fix minor sparse endian nit
Message-ID: <a51bba5e-01ba-d73b-6fe6-ac3a411c7283@redhat.com>
Date: Fri, 17 Jun 2016 11:44:44 -0500
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

The intermediate variable should not have been endian-annotated;
it is the local cpu representation not the on-disk representation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2119a0b..1bc5163 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -506,7 +506,7 @@ sb_update_uuid(
 	 */
 	if (!uuid_equal(&tcarg->uuid, &ag_hdr->xfs_sb->sb_uuid) &&
 	    xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb)) {
-		__be32 feat;
+		__uint32_t feat;
 
 		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
 		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
