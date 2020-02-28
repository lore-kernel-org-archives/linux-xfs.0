Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	LONGWORDS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990F8C3F2D0
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 04:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CE8B21556
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 04:50:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMQVrd4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgB1Euz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 23:50:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51339 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgB1Euy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 23:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582865452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ap579YiMblIA7YFToHNgmsWa5OReXncEoQsQMxr8CzY=;
        b=HMQVrd4F8Dpq3H9alnnFEEv8+hUAzThrSP3adO3pUuvsHSfR6Is9VsKi3YONO8wrXMCS9P
        Tar4Ka9rcHGsPkSoyouIiE2Br7/AD6vxzAG4jJiXZgAmCZAHjZtEYFQOJ8PbhoRvPwjcEB
        2e95nSEmKdYEOtpusZRgmJH9uYr9lHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-6LNbaar4MrGXe2HZYJClBg-1; Thu, 27 Feb 2020 23:50:50 -0500
X-MC-Unique: 6LNbaar4MrGXe2HZYJClBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4E038017CC;
        Fri, 28 Feb 2020 04:50:49 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BBE176E3EE;
        Fri, 28 Feb 2020 04:50:49 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fstests: fix up filters & expected output for latest
 xfs_repair
Message-ID: <ea796af5-4f7e-e882-c918-b6ff9f10f91f@redhat.com>
Date:   Thu, 27 Feb 2020 20:50:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A handful of minor changes went into xfs_repair output in the
last push, so add a few more filters and change the resulting
expected output.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I confirmed that xfs/030, xfs/033, and xfs/178 pass on both
current for-next, as well as v5.4.0

diff --git a/common/repair b/common/repair
index 5a9097f4..6668dd51 100644
--- a/common/repair
+++ b/common/repair
@@ -29,7 +29,13 @@ _filter_repair()
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
 s/(pointer to) (\d+)/\1 INO/;
-s/(sb root inode value) (\d+)( \(NULLFSINO\))?/\1 INO/;
+# Changed inode output in 5.5.0
+s/sb root inode value /sb root inode /;
+s/realtime bitmap inode value /realtime bitmap inode /;
+s/realtime summary inode value /realtime summary inode /;
+s/ino pointer to /inode pointer to /;
+#
+s/(sb root inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
 s/(realtime bitmap inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
 s/(realtime summary inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
 s/(inconsistent with calculated value) (\d+)/\1 INO/;
@@ -74,6 +80,8 @@ s/(inode chunk) (\d+)\/(\d+)/AGNO\/INO/;
 # sunit/swidth reset messages
 s/^(Note - .*) were copied.*/\1 fields have been reset./;
 s/^(Please) reset (with .*) if necessary/\1 set \2/;
+# remove new unlinked inode test
+/^bad next_unlinked/ && next;
 # And make them generic so we dont depend on geometry
 s/(stripe unit) \(.*\) (and width) \(.*\)/\1 (SU) \2 (SW)/;
 # corrupt sb messages
diff --git a/tests/xfs/030.out b/tests/xfs/030.out
index 2b556eec..4a7c4b8b 100644
--- a/tests/xfs/030.out
+++ b/tests/xfs/030.out
@@ -14,12 +14,12 @@ attempting to find secondary superblock...
 found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
+sb root inode INO inconsistent with calculated value INO
 resetting superblock root inode pointer to INO
 sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
+resetting superblock realtime bitmap inode pointer to INO
 sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
+resetting superblock realtime summary inode pointer to INO
 Phase 2 - using <TYPEOF> log
         - zero log...
         - scan filesystem freespace and inode maps...
@@ -131,12 +131,12 @@ attempting to find secondary superblock...
 found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
+sb root inode INO inconsistent with calculated value INO
 resetting superblock root inode pointer to INO
 sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
+resetting superblock realtime bitmap inode pointer to INO
 sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
+resetting superblock realtime summary inode pointer to INO
 Phase 2 - using <TYPEOF> log
         - zero log...
         - scan filesystem freespace and inode maps...
diff --git a/tests/xfs/178.out b/tests/xfs/178.out
index 8e0fc8e1..0bebe553 100644
--- a/tests/xfs/178.out
+++ b/tests/xfs/178.out
@@ -12,12 +12,12 @@ attempting to find secondary superblock...
 found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
+sb root inode INO inconsistent with calculated value INO
 resetting superblock root inode pointer to INO
 sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
+resetting superblock realtime bitmap inode pointer to INO
 sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
+resetting superblock realtime summary inode pointer to INO
 Phase 2 - using <TYPEOF> log
         - zero log...
         - scan filesystem freespace and inode maps...
@@ -48,12 +48,12 @@ attempting to find secondary superblock...
 found candidate secondary superblock...
 verified secondary superblock...
 writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
+sb root inode INO inconsistent with calculated value INO
 resetting superblock root inode pointer to INO
 sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
+resetting superblock realtime bitmap inode pointer to INO
 sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
+resetting superblock realtime summary inode pointer to INO
 Phase 2 - using <TYPEOF> log
         - zero log...
         - scan filesystem freespace and inode maps...

