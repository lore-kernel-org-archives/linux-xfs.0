Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdFHOAZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 10:00:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31216793FC
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2017 14:00:20 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-167.brq.redhat.com [10.40.204.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AFDC97DCC
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2017 14:00:19 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2 V3] Resubmit items failed during writeback
Date: Thu,  8 Jun 2017 16:00:12 +0200
Message-Id: <20170608140014.25132-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

this is the 3rd revision of this patchset, based on the discussion in the
previous version, hoping to have fixed all the issues pointed there :)

I've removed the atomic handling of the xfs_log_item flags once it has been
decided to convert the usage to atomic handling after the patchset if accepted,
so, I'll add it to another patchset together with the dquot fix for the items
resubmission.

More details on each patch.

Cheers

-- 
2.9.3

