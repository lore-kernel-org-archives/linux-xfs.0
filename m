Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755008AbcK3Wg1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Nov 2016 17:36:27 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F095AACEC
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2016 22:36:26 +0000 (UTC)
Received: from Liberator.example.com (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAUMaPib000807
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2016 17:36:26 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: AGI buffer type handling
Message-ID: <203e6e5c-7663-b49b-36af-5885aa1f461a@redhat.com>
Date: Wed, 30 Nov 2016 16:36:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We were missing a xfs_trans_buf_set_type() to XFS_BLFT_AGI_BUF
in xlog_recover_clear_agi_bucket.

Fix this in 2 stages; first simply add it to this function for
simple -stable backports, then move all of them into
xfs_read_agi() so it doesn't get forgotten again.

-Eric
