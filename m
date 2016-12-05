Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbcLEWsD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Dec 2016 17:48:03 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D153D3F20D
        for <linux-xfs@vger.kernel.org>; Mon,  5 Dec 2016 22:48:02 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uB5Mm1au030949
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Mon, 5 Dec 2016 17:48:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_logprint: di_gen is unsigned
Message-ID: <c453839b-61db-9500-b39d-e6580d1748b5@redhat.com>
Date: Mon, 5 Dec 2016 16:48:01 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

di_gen is unsigned:

        __uint32_t      di_gen;         /* generation number */

but we print it as a signed int in logprint, so see oddities like:

 forkoff:24  dmevmask:0x0  dmstate:0  flags:0x0  gen:-628807103

Fix this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index f49316e..3863ba9 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -269,7 +269,7 @@ xlog_recover_print_inode_core(
 	       di->di_size, (unsigned long long)di->di_nblocks,
 	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
-	     "gen:%d\n"),
+	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
 	       (int)di->di_flags, di->di_gen);
 	if (di->di_version == 3) {

