Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388315AbeGXDbP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 23:31:15 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B54D530832D1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 02:27:08 +0000 (UTC)
Received: from Liberator-5.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8232392D03
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 02:27:08 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2 V3] xfs_repair: rework inode clearing and free inode
 validation
Message-ID: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
Date: Mon, 23 Jul 2018 19:27:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Warn the user if any free inodes contain errors, and set exit code
in the process.  Do this by running the existing dinode verifier and
clearing / warning if it fails.

2nd patch separates out the inode validation from the clearing function

There is a functional change here which I'm on the fence about; free
inodes are now only cleared if they won't pass the dinode verifier,
which is the only thing the kernel would squawk about.  But that's
a subset of the clear_inode checks.

The old clear_dinode function checked a lot of things that the
verifier simply doesn't care about, but I think it's ok for
those tests to go away; if the kernel does care about, say, extent
count on a free inode, the verifier should test it.
