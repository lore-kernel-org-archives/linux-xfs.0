Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BCEC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbiLaDSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:18:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EED55BF;
        Fri, 30 Dec 2022 19:18:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4EC8CE1AC6;
        Sat, 31 Dec 2022 03:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D938BC433D2;
        Sat, 31 Dec 2022 03:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456712;
        bh=i7DvBEN6p6qXaIKjalTOnsFfs3DbDSR8qCDuvh0bxc4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wq8QhBC04CAP6asS+gBD55tQojrs2O2ZVnpWV3Mbb+jzZKdUz2PwQ7209q7OkTbhK
         M5ro4Wc6wRPsQN4HAEiw/OvRMF1wWlq+pq+lhwY0nQUeSs/Cn+ZmpoziQo2tfVBmIh
         M4jo98YOuJRSJxDVggxEEO5ybNdkE6Rchi2OxAhvgGDjJDsPUv5wh2bi3b7sBjy5bL
         sU+h6wef/7h+lLRqIYt9166AMMUslptubCMeC5ekdVJt73D/a+3nB9PJfp+l9XrqW2
         YnKISu8AbOtM8aKxfMlWpzwaHwrQdy6LjfYp16lq/QWU529wh2+UXKPRDg4aw2ec+K
         ROuH7EkY7Drow==
Subject: [PATCH 10/10] common/xfs: fix _xfs_get_file_block_size when rtinherit
 is set and no rt section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884985.740253.9646865961874534890.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's possible for the sysadmin to set rtinherit on the directory tree
even if there isn't a realtime section attached to the filesystem.  When
this is the case, the realtime flag is /not/ passed to new files, and
file data is written to the data device.  The file allocation unit for
the file is the fs blocksize, and it is not correct to use the rt
extent.

fstests can be fooled into doing the incorrect thing if test runner puts
'-d rtinherit=1 -r extsize=28k' into MKFS_OPTIONS without configuring a
realtime device.  This causes many tests to do the wrong thing because
they think they must operate on units of 28k (and not 4k).  Fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/common/xfs b/common/xfs
index 7b7b3a35b5..546853247c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -207,6 +207,8 @@ _xfs_get_file_block_size()
 {
 	local path="$1"
 
+	# If rtinherit or realtime are not set on the path, then all files
+	# will be created on the data device.
 	if ! ($XFS_IO_PROG -c "stat -v" "$path" 2>&1 | grep -E -q '(rt-inherit|realtime)'); then
 		_get_block_size "$path"
 		return
@@ -217,6 +219,15 @@ _xfs_get_file_block_size()
 	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
 		path="$(dirname "$path")"
 	done
+
+	# If there's no realtime section, the rtinherit and rextsize settings
+	# are irrelevant -- all files are created on the data device.
+	if $XFS_INFO_PROG "$path" | grep -q 'realtime =none'; then
+		_get_block_size "$path"
+		return
+	fi
+
+	# Otherwise, report the rt extent size.
 	_xfs_get_rtextsize "$path"
 }
 

