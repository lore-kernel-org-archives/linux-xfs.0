Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPRmq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 13:42:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41ADD83F3D
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 17:42:46 +0000 (UTC)
Received: from Liberator-6.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 037E65D6A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 17:42:45 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] xfsprogs: more libxfs/ spring cleaning
Message-ID: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Date: Thu, 16 May 2019 12:42:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

It wasn't super clear before - my goal here is to keep reducing
cosmetic differences between kernelspace & userspace libxfs/*
files and functions.

To that end, 3 more patches ... the first one may requires someone
who groks the libxfs_* API namespace picture (looking at you, Dave!)

(this abandons the "make new files" patches I sent before, at least
for now, I'll heed dave's advice to minimize moves...)

Thanks,
-Eric
