Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfBSXdr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Feb 2019 18:33:47 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98C2AC01D33A
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:33:47 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B55A60BE8
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:33:47 +0000 (UTC)
Subject: [PATCH 3/3] libhandle: zero terminate fspath string
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <bce2b57b-50c8-0b56-b42d-9ff357c26eb6@redhat.com>
Date: Tue, 19 Feb 2019 17:33:46 -0600
MIME-Version: 1.0
In-Reply-To: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

I had a heck of a time chasing through whether we were null terminated
by now or not, so just be safe and do it explicitly.

Addresses-Coverity-ID: 1297520 ("Buffer not null terminated")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libhandle/handle.c b/libhandle/handle.c
index eb099f4..d3927a3 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -108,6 +108,7 @@ path_to_fshandle(
 
 		fdhp->fsfd = fd;
 		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath));
+		fdhp->fspath[sizeof(fdhp->fspath) - 1] = '\0';
 		memcpy(fdhp->fsh, *fshanp, FSIDSIZE);
 
 		fdhp->fnxt = fdhash_head;
