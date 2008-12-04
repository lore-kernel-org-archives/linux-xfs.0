Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB46IrnU028554 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 00:18:53 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id DD5BC30408D
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 22:18:48 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id RAA20606 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 17:18:46 +1100
Message-ID: <4937765D.2030601@sgi.com>
Date: Thu, 04 Dec 2008 17:19:09 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Remove unused variable in ktrace_free()
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

entries_size is probably left over from when we used to pass the
size to kmem_free().

--- xfs-fix.orig/fs/xfs/support/ktrace.c
+++ xfs-fix/fs/xfs/support/ktrace.c
@@ -113,21 +113,16 @@ ktrace_alloc(int nentries, unsigned int
  void
  ktrace_free(ktrace_t *ktp)
  {
-	int     entries_size;
-
  	if (ktp == (ktrace_t *)NULL)
  		return;

  	/*
  	 * Special treatment for the Vnode trace buffer.
  	 */
-	if (ktp->kt_nentries == ktrace_zentries) {
+	if (ktp->kt_nentries == ktrace_zentries)
  		kmem_zone_free(ktrace_ent_zone, ktp->kt_entries);
-	} else {
-		entries_size = (int)(ktp->kt_nentries * sizeof(ktrace_entry_t));
-
+	else
  		kmem_free(ktp->kt_entries);
-	}

  	kmem_zone_free(ktrace_hdr_zone, ktp);
  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
