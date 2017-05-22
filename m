Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934804AbdEVPc0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 11:32:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12A6161982
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:32:26 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-168.brq.redhat.com [10.40.204.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 616EE7D640
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 15:32:25 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/3 V2] Resubmit items failed during writeback 
Date: Mon, 22 May 2017 17:32:17 +0200
Message-Id: <20170522153220.25072-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


Hi,

this is the second version of this patchset, based on the comments on the
previous version.

Each patch has its own changelog, but some of the highlights are:

- Use atomic operations to set/clear xfs_log_item flags (including a patch to
  convert all the existing operations to atomic operations)
- call xfs_buf_do_callbacks_fail() from inside xfS_buf_iodone_error
- Use a helper function to resubmit the failed buffers.

The whole discussion is quite long, so I hope to have addressed all the topics
discussed.

- The patchset has passed xfstests and my reproducer to this specific bug.

-- 
2.9.3

