Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FFEC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FDB221F2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLCUfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:35:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbgLCUfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607027615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gmF4OrqP94Jv8pLG5vjmu23E6sL8fzY4gKL+jYtpGE=;
        b=IvqYZLFNzAHDFgxH1cQY0YrfXKhbvQOphJQOJyVnX/v7RWPunU9ezE78oXGq9inroUTVlD
        QE4MEKV3HCgUhBkXNEvVvoklHLI8nnAcK7b88M8H+Ce2w8z60aQtT/XTeI/lFknH3I6P+3
        a3vXR88BrB8G23lwah4diePzabhP2v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-VwC8WUgQOQGK7BrnmsxkTg-1; Thu, 03 Dec 2020 15:33:27 -0500
X-MC-Unique: VwC8WUgQOQGK7BrnmsxkTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A193A107ACE8
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:33:26 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79BDC5D9CC
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:33:26 +0000 (UTC)
Subject: [PATCH 3/3 V2] xfsprogs: make things non-gender-specific
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
Message-ID: <7b81f21d-68b9-86e1-de7e-f9e82dd28195@redhat.com>
Date:   Thu, 3 Dec 2020 14:33:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Users are not exclusively male, so fix that implication
in the xfs_quota manpage and the configure.ac comments.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix configure.ac comments too, and fix a missed "him" in the manpage
    also "choses" is not a word :)

diff --git a/configure.ac b/configure.ac
index 645e4572..48f3566d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,7 +113,7 @@ esac
 # Some important tools should be installed into the root partitions.
 #
 # Check whether exec_prefix=/usr: and install them to /sbin in that
-# case.  If the user choses a different prefix assume he just wants
+# case.  If the user chooses a different prefix assume they just want
 # a local install for testing and not a system install.
 #
 case $exec_prefix:$prefix in
diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 74c24916..cfb87621 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -128,7 +128,7 @@ To most users, disk quotas are either of no concern or a fact of life
 that cannot be avoided.
 There are two possible quotas that can be imposed \- a limit can be set
 on the amount of space a user can occupy, and there may be a limit on
-the number of files (inodes) he can own.
+the number of files (inodes) they can own.
 .PP
 The
 .B quota
@@ -167,10 +167,10 @@ the file, not only are the recent changes lost, but possibly much, or even
 all, of the contents that previously existed.
 .br
 There are several possible safe exits for a user caught in this situation.
-He can use the editor shell escape command to examine his file space
+They can use the editor shell escape command to examine their file space
 and remove surplus files.  Alternatively, using
 .BR sh (1),
-he can suspend
+they can suspend
 the editor, remove some files, then resume it.
 A third possibility is to write the file to some other filesystem (perhaps
 to a file on

