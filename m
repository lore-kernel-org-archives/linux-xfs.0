Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44652 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbeJWM0E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 08:26:04 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 25737B6A
        for <linux-xfs@vger.kernel.org>; Mon, 22 Oct 2018 23:04:00 -0500 (CDT)
Subject: [PATCH 1/2] xfs_repair: initialize realloced bplist in
 longform_dir2_entry_check
From: Eric Sandeen <sandeen@sandeen.net>
References: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
Message-ID: <480fc460-e8cd-cb34-924c-59c874ab393e@sandeen.net>
Date: Mon, 22 Oct 2018 23:04:31 -0500
MIME-Version: 1.0
In-Reply-To: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

If we need to realloc the bplist[] array holding buffers for a given
directory, we don't initialize the new slots.  This causes a problem
if the directory has holes, because those slots never get filled in.

At the end of the function we call libxfs_putbuf for every non-null
slot, and any uninitialized slots are segfault landmines.

Make sure we initialize all new slots to NULL for this reason.

Reported-by: Oleg Davydov <burunduk3@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index b87c751..9d24a4f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2348,6 +2348,8 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 
 		db = xfs_dir2_da_to_db(mp->m_dir_geo, da_bno);
 		if (db >= num_bps) {
+			int last_size = num_bps;
+
 			/* more data blocks than expected */
 			num_bps = db + 1;
 			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
@@ -2355,6 +2357,9 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 				do_error(_("realloc failed in %s (%zu bytes)\n"),
 					__func__,
 					num_bps * sizeof(struct xfs_buf*));
+			/* Initialize the new elements */
+			for (i = last_size; i < num_bps; i++)
+				bplist[i] = NULL;
 		}
 
 		if (isblock)
