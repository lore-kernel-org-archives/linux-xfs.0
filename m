Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbeEDRdJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 13:33:09 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5209A30001EA
        for <linux-xfs@vger.kernel.org>; Fri,  4 May 2018 17:33:09 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20E6430012B0
        for <linux-xfs@vger.kernel.org>; Fri,  4 May 2018 17:33:09 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/5] xfs: quota verifier/repair improvements take 2
Message-ID: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
Date: Fri, 4 May 2018 12:33:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

A new attempt at the quota improvements regarding in-kernel repair 
and verifier behavior.

This series structures things a bit differently to avoid the log
replay verifier failure Darrick hit :( and also uses his new
sub-buffer verifier error function to print the specific corrupted
quota.

Ran this one through -g quick,auto with "-o quota" and saw no
regressions.

For now I've left out the last 2 patches from last time which try to
quiet down the kernel messages when mounting/quotachecking a corrupted
fs, I want to think about those & let them soak a bit more.

Thanks,
-Eric
