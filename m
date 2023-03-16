Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB49C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCPTgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCPTgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:36:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11FDBDD35;
        Thu, 16 Mar 2023 12:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1246E620F9;
        Thu, 16 Mar 2023 19:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C95FC4339C;
        Thu, 16 Mar 2023 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995394;
        bh=UIZczfgKMoAbondSMQ3yRYrjcrJZ+bWoTggKD3FCZdc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=H/ty7yw9kSlBJyXPu+BeUfgBd/vCBAOVWhwcA29ahR5Az3bOXwhC2wmIsYx2gtK1e
         WFWtTIv0mO9nYqLcV+6clZLM9KrI9n6yX9kQdCVaZS/N6jcUde9MB7UiFQJG7ylvIK
         OLIqg/Mv4Jjnl2iU9oNHHLLQfecO0a2MXTnSrGQbfTfktYobPd5fzJw+wEiTUeH5OU
         Y8lOya3mmw/nb4W9OmNnyIrI9PCvKKWZv97FYGd7LWQdwkiyF3ZZVvlLdXlBj4ZN24
         Fnmx936F14jqkHXOtF6qqNnEZUnH0MOywUw+jmPhY6qt3C9TTbL+7AzowFiwDAvtBn
         NhWWdYQ65IUwg==
Date:   Thu, 16 Mar 2023 12:36:34 -0700
Subject: [PATCH 14/14] xfs/851: test xfs_io parent -p too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417839.17926.13744291683244196909.stgit@frogsfrogsfrogs>
In-Reply-To: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
References: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Test the -p argument to the xfs_io parent command too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/851     |   15 +++++++++++++++
 tests/xfs/851.out |   10 ++++++++++
 2 files changed, 25 insertions(+)


diff --git a/tests/xfs/851 b/tests/xfs/851
index 27870ec05a..8233c1563c 100755
--- a/tests/xfs/851
+++ b/tests/xfs/851
@@ -12,6 +12,7 @@ _begin_fstest auto quick parent
 
 # get standard environment, filters and checks
 . ./common/parent
+. ./common/filter
 
 # Modify as appropriate
 _supported_fs xfs
@@ -96,6 +97,20 @@ ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
 mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
 _verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
 
+# Make sure that parent -p filtering works
+mkdir -p $SCRATCH_MNT/dira/ $SCRATCH_MNT/dirb/
+dira_inum=$(stat -c '%i' $SCRATCH_MNT/dira)
+dirb_inum=$(stat -c '%i' $SCRATCH_MNT/dirb)
+touch $SCRATCH_MNT/gorn
+ln $SCRATCH_MNT/gorn $SCRATCH_MNT/dira/file1
+ln $SCRATCH_MNT/gorn $SCRATCH_MNT/dirb/file1
+echo look for both
+$XFS_IO_PROG -c 'parent -p' $SCRATCH_MNT/gorn | _filter_scratch
+echo look for dira
+$XFS_IO_PROG -c 'parent -p -n dira' -c "parent -p -i $dira_inum" $SCRATCH_MNT/gorn | _filter_scratch
+echo look for dirb
+$XFS_IO_PROG -c 'parent -p -n dirb' -c "parent -p -i $dirb_inum" $SCRATCH_MNT/gorn | _filter_scratch
+
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/851.out b/tests/xfs/851.out
index c375ba5f00..f44d3e5d4f 100644
--- a/tests/xfs/851.out
+++ b/tests/xfs/851.out
@@ -57,3 +57,13 @@ QA output created by 851
 *** testfolder1/file2 OK
 *** Verified parent pointer: name:file2, namelen:5
 *** Parent pointer OK for child testfolder1/file2
+look for both
+SCRATCH_MNT/gorn
+SCRATCH_MNT/dira/file1
+SCRATCH_MNT/dirb/file1
+look for dira
+SCRATCH_MNT/dira/file1
+SCRATCH_MNT/dira/file1
+look for dirb
+SCRATCH_MNT/dirb/file1
+SCRATCH_MNT/dirb/file1

