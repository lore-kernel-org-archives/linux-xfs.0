Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDC7C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798D7206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:08:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FK5qFAeN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgF2TIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:08:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39741 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730880AbgF2TI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 15:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=n2qVe7QVtMWlsu3tW293XYJBZ3r5SYGfqQyhGd9NB2s=;
        b=FK5qFAeNANqld3bC3idPx5R9BJwMfVKnx2X3Kc4DmkwoY69uGZZ1wLqeKkU80xjjjmdYVT
        KpLrly0jEJXPI9ARJpVlPnKPW4gytpbKOaDKlKt6Jerj5jhlMqh8+MvzLcu/v9WMeuAQG9
        Dm3j4OWcgHLOSegfjevVeo7NWznJh5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-L3fpmOSlM7CetVm3iyl5YQ-1; Mon, 29 Jun 2020 15:08:13 -0400
X-MC-Unique: L3fpmOSlM7CetVm3iyl5YQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3B1210059A3;
        Mon, 29 Jun 2020 19:08:11 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 074F960BF3;
        Mon, 29 Jun 2020 19:08:10 +0000 (UTC)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jonathan Corbet <corbet@lwn.net>
Cc:     cgroups@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] doc: cgroup: add f2fs and xfs to supported list for writeback
Message-ID: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Date:   Mon, 29 Jun 2020 14:08:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

f2fs and xfs have both added support for cgroup writeback:

578c647 f2fs: implement cgroup writeback support
adfb5fb xfs: implement cgroup aware writeback

so add them to the supported list in the docs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

TBH I wonder about the wisdom of having this detail in
the doc, as it apparently gets missed quite often ...

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index ce3e05e..4f82afa 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1684,9 +1684,9 @@ per-cgroup dirty memory states are examined and the more restrictive
 of the two is enforced.
 
 cgroup writeback requires explicit support from the underlying
-filesystem.  Currently, cgroup writeback is implemented on ext2, ext4
-and btrfs.  On other filesystems, all writeback IOs are attributed to
-the root cgroup.
+filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
+btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are 
+attributed to the root cgroup.
 
 There are inherent differences in memory and writeback management
 which affects how cgroup ownership is tracked.  Memory is tracked per

