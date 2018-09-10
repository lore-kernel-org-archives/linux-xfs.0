Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726337AbeIKDOp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Sep 2018 23:14:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A050531500B3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Sep 2018 22:18:35 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 614AC600C7
        for <linux-xfs@vger.kernel.org>; Mon, 10 Sep 2018 22:18:35 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: validate size vs format, take 2
Message-ID: <0c8c405b-8929-82a6-5c9a-f5965da2c464@redhat.com>
Date: Mon, 10 Sep 2018 17:18:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

[PATCH] xfs: verify size-vs-format for symlinks & dirs redux,
now with more cowbell^Wdi_forkoff validation.
