Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8J6A94q158686 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 01:10:09 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id okfhjHAhamApxNC1 for
	<xfs@oss.sgi.com>; Tue, 18 Sep 2012 23:11:20 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8J6BKgA020803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 02:11:20 -0400
Received: from andromeda.usersys.redhat.com (vpn1-7-14.gru2.redhat.com
	[10.97.7.14])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8J6BDjW014802
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 02:11:20 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/6] xfs: Fix m_agirotor reset during AG selection
Date: Wed, 19 Sep 2012 03:11:00 -0300
Message-Id: <1348035065-6934-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348035065-6934-1-git-send-email-cmaiolino@redhat.com>
References: <1348035065-6934-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_ialloc_next_ag() currently resets m_agirotor when it is equal to m_maxagi:

         if (++mp->m_agirotor == mp->m_maxagi)
	         mp->m_agirotor = 0;

But, if for some reason mp->m_maxagi changes to a lower value than current
m_agirotor, this condition will never be true, causing m_agirotor to exceed the
maximum allowed value (m_maxagi).

This implies mainly during lookups for xfs_perag structs in its radix tree,
since the agno value used for the lookup is based on m_agirotor. An out-of-range
m_agirotor may cause a lookup failure which in case will return NULL.

As an example, the value of m_maxagi is decreased during inode64->inode32
remount process, case where I've found this problem.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5aceb3f..445bf1a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -431,7 +431,7 @@ xfs_ialloc_next_ag(
 
 	spin_lock(&mp->m_agirotor_lock);
 	agno = mp->m_agirotor;
-	if (++mp->m_agirotor == mp->m_maxagi)
+	if (++mp->m_agirotor >= mp->m_maxagi)
 		mp->m_agirotor = 0;
 	spin_unlock(&mp->m_agirotor_lock);
 
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
