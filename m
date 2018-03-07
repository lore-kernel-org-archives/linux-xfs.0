Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934059AbeCGXbc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 18:31:32 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5418481DE9
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 23:31:32 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 252976092E
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 23:31:32 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: don't require a dirty log on snapshots
Message-ID: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
Date: Wed, 7 Mar 2018 17:31:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today, freezing an xfs filesystem will add a dummy log entry
after it quiesces the filesystem, to trigger unlinked inode
recovery on the next mount.  This kind of sucks for readonly
snapshots on readonly devices; one must then specify 
"-o ro,norecovery" or mount will fail, because the log appears
dirty.  This is very nonobvious.

I propose improving the situation by moving unlinked inode recovery
out of log replay; check for and process unlinked inodes on every mount,
regardless of log dirtiness.  This way we can create snapshots with
clean logs.

There may be some devils in the details here but it passes a quick
sanity check, so let's see what reviewers think, and see what I've
overlooked...

Thanks,
-Eric
