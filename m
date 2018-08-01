Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbeHAXJD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 19:09:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2AF11356C9
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 21:21:21 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDFF962A16
        for <linux-xfs@vger.kernel.org>; Wed,  1 Aug 2018 21:21:20 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] misc: add handy tarball targets
Message-ID: <89353d1e-b141-e8e6-e039-fb8340a45df0@redhat.com>
Date: Wed, 1 Aug 2018 16:21:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

It's a pain to need to know which version we're on to be able
to create a tarball, just make a couple of simple "tarball"
and "tarxz" targets that just DTRT and make a tarball with the
current version.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile b/Makefile
index 6774825..21983a3 100644
--- a/Makefile
+++ b/Makefile
@@ -178,6 +178,9 @@ $(SRCTARXZ) : default $(SRCTARINC) .gitcensus
 	   `cat .gitcensus` $(SRCTARINC)
 	echo Wrote: $@
 
+tarball: $(SRCTAR)
+tarxz: $(SRCTARXZ)
+
 .gitcensus: $(_FORCE)
 	$(Q)if test -d .git; then \
 	  git ls-files > .gitcensus && echo "new .gitcensus"; \

