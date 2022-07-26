Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE83DC04A68
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbiGZTsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:48:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A4E3122B;
        Tue, 26 Jul 2022 12:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4965B81A07;
        Tue, 26 Jul 2022 19:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA51C433D6;
        Tue, 26 Jul 2022 19:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864917;
        bh=+TLfBrYspZSSqGEkFp3i8Tuugsls5/WqxT+dLhS25z4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QbD3ojxYq4RJYJdEvIX6CuiazgbcHlJt47+jXpeeC0NbMfR8NV5RVdVU0QgzDLfrc
         ussKUziSIW/5ezlsyEp5fU3cGn67durAEzC5Kvk0kO/uHxe4nlYHQxAoZN17pl7nKi
         D9qQERVTUqr0mgrf4s6VzYDNFPcjQi535heuUvn4k4nxSjYv1mPnX8Yi7+6x2QZoGz
         kukwHN2i5fy5U0ZlIIONSbjELhBnxP9PXxSleTadMK19tfNaEft5lRIX7CLBS83Mjl
         BRIhFhUs596KdPpuEW5bsT/jZqWflsddVhXOeh5rl6v/2lW0BfbKkWHE7viRPHYUDq
         o0lPuXxMswxtQ==
Subject: [PATCH 1/2] common/rc: wait for udev before creating dm targets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 26 Jul 2022 12:48:36 -0700
Message-ID: <165886491692.1585061.2529733779998396096.stgit@magnolia>
In-Reply-To: <165886491119.1585061.14285332087646848837.stgit@magnolia>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then I see a failure when running generic/322 on btrfs:

QA output created by 322
failed to create flakey device

Looking in the 322.full file, I see:

device-mapper: reload ioctl on flakey-test (253:0) failed: Device or resource busy
Command failed.

And looking in dmesg, I see:

device-mapper: table: 8:3: linear: Device lookup failed (-16)
device-mapper: ioctl: error adding target to table

/dev/block/8:3 corresponds to the SCRATCH_DEV on this system.  Given the
failures in 322.out, I think this is caused by generic/322 calling
_init_flakey -> _dmsetup_create -> $DMSETUP_PROG create being unable to
open SCRATCH_DEV exclusively.  Add a call to $UDEV_SETTLE_PROG prior to
the creation of the target to try to calm the system down sufficiently
that the test can proceed.

Note that I don't have any hard evidence that it's udev at fault here --
the few times I've caught this thing, udev *has* been active spraying
error messages for nonexistent sysfs paths to journald and adding a
'udevadm settle' seems to fix it... but that's still only
circumstantial.  Regardless, it seems to have fixed the test failure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/common/rc b/common/rc
index f4469464..60a9bacd 100644
--- a/common/rc
+++ b/common/rc
@@ -4815,6 +4815,11 @@ _dmsetup_remove()
 
 _dmsetup_create()
 {
+	# Wait for udev to settle so that the dm creation doesn't fail because
+	# some udev subprogram opened one of the block devices mentioned in the
+	# table string w/ O_EXCL.  Do it again at the end so that an immediate
+	# device open won't also fail.
+	$UDEV_SETTLE_PROG >/dev/null 2>&1
 	$DMSETUP_PROG create "$@" >>$seqres.full 2>&1 || return 1
 	$DMSETUP_PROG mknodes >/dev/null 2>&1
 	$UDEV_SETTLE_PROG >/dev/null 2>&1

