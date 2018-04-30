Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753973AbeD3Pkn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 11:40:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A69B8C051677
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 15:40:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D85180881
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 15:40:43 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/5] xfs: add online relabel capabilities
Message-ID: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
Date: Mon, 30 Apr 2018 10:40:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Sending V1 just to the xfs list for xfs comments, and assuming
at least a V2 will emerge; I'll cc: fsdevel & btrfs on that one.

This implements online label set/get ioctls for xfs, following the
btrfs example.  We've had at least one request for this, and Chris Mason
tells me he's heard similar requests, and apparently even Darrick wished
for this once.  :)

Patch5 is the xfs_io userspace patch, once this is all sorted I'll add a
wrapper to xfs_admin as well.

This can also be tested w/ the "btrfs filesystem label" command since it
re-uses their ioctl.

Thanks,
-Eric
