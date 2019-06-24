Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfFXNzj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 09:55:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 02D78356D4
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2019 13:55:39 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD166600D1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2019 13:55:38 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: fix built-in help for project setup
Message-ID: <8b7e8e8d-0297-caff-568e-c9d1e75eda63@redhat.com>
Date: Mon, 24 Jun 2019 08:55:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

-s is used to set up a new project, not -c.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/project.c b/quota/project.c
index 7c22947..03ae10d 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -43,7 +43,7 @@ project_help(void)
 " and subdirectories below it (i.e. a tree) can be restricted to using a\n"
 " subset of the available space in the filesystem.\n"
 "\n"
-" A managed tree must be setup initially using the -c option with a project.\n"
+" A managed tree must be setup initially using the -s option with a project.\n"
 " The specified project name or identifier is matched to one or more trees\n"
 " defined in /etc/projects, and these trees are then recursively descended\n"
 " to mark the affected inodes as being part of that tree - which sets inode\n"
