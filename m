Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UGOEBb143081 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 11:24:14 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DjGTtMRycCZQZvTG for
	<xfs@oss.sgi.com>; Fri, 30 Mar 2012 09:24:13 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2UGOCTb014144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 12:24:12 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q2UGOBIO010715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 12:24:12 -0400
Message-ID: <4F75DE2B.7030807@redhat.com>
Date: Fri, 30 Mar 2012 11:24:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] Fix wrong flag ASSERT in xfs_attr_shortform_getvalue
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This ASSERT is testing an if_flags flag value against
a di_aformat enum value.  di_aformat is never assigned
XFS_IFINLINE.

This happens to work for now, because XFS_IFINLINE has
the same value as XFS_DINODE_FMT_LOCAL, and that's tested
just before we call this function.

However, I think the intention is to assert that we have
read in the data, i.e. XFS_IFINLINE on if_flags, before
we use if_data.  This is done in other places through the
code as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note, maybe it should be:

	ASSERT(args->dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);

but there is an if statement in the caller which assures that,
so as the code stands that would seem pointless.  I'm not 100%
sure what the original intent was, though, so ...

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 76d93dc..8ca76ad 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -441,7 +441,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 	xfs_attr_sf_entry_t *sfe;
 	int i;
 
-	ASSERT(args->dp->i_d.di_aformat == XFS_IFINLINE);
+	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
