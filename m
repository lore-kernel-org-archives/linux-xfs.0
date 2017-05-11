Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932239AbdEKN5k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 09:57:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 43D061555E
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 13:57:40 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-141.brq.redhat.com [10.40.204.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97FD58A8C5
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 13:57:39 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] Resubmit items failed during writeback
Date: Thu, 11 May 2017 15:57:31 +0200
Message-Id: <20170511135733.21765-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


This patchset aims to fix the AIL items retry problem that is on my plate for a
while, and it's based on a discussion I had with Dave off-list.

This basically consists of:

1- a mechanism to properly report failures during writeback back to the items
   attached to the failed buffer
2- Use this mechanism to detect such failures and properly re-submit the items
   failed previously

It is worth to mention that this same problem is also possible in dquot code,
but the fix is almost identical to the inodes.

I am not submitting a fix for dquot yet to avoid the need to create VX for both
patches, once we agree with the solution, I'll submit a fix to dquot.

Reviews are welcome :-)

-- 
2.9.3

