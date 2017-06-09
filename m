Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdFIDGA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 23:06:00 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A9E3C0587C8
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2017 03:06:00 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34B118AE26
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2017 03:06:00 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsdump: add AC_SYS_LARGEFILE
Message-ID: <7120a48c-a832-ed92-411d-b97888f41e54@redhat.com>
Date: Thu, 8 Jun 2017 22:05:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

After:

7fda99a0 xfs.h: require transparent LFS for all users

xfsdump stopped building against the xfs headers; add
largefile support.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/configure.ac b/configure.ac
index 7bb6f1d..8d78ed4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,8 @@ AC_CONFIG_SRCDIR([common/main.c])
 AC_CONFIG_HEADER(include/config.h)
 AC_PREFIX_DEFAULT(/usr)
 
+AC_SYS_LARGEFILE
+
 AC_PROG_LIBTOOL
 
 AC_ARG_ENABLE(shared,

