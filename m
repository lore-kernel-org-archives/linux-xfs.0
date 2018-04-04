Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751417AbeDDSrO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 14:47:14 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 386282B0F
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 13:46:38 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/6] xfs: quota fixes and enhancements
Message-ID: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Date: Wed, 4 Apr 2018 13:47:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

A semi-random smattering of quota stuff.  First three seem quite
good to go, the rest are more along the lines of a suggestion
or conversation-starter.  ;)

(the first patch is just removing an unused arg).

xfs_repair doesn't look at quota blocks.  At all.  It relies
on quotacheck in the kernel to fix them up as needed.

But quotacheck doesn't check crc or UUID, so those errors
never get fixed, even though verifiers flag them.  So,
fix (some of) that by validating the uuid during quotacheck.
That's patches 2 & 3.

Also, when we are initializing quota, it's running quota
blocks through the full verifiers, and complaining loudly
about running xfs_repair (which won't do anything) even though
it's about to run the in-kernel repair.  The rest of the
patches take a stab at making that cleaner.

(One oddity is that we still don't catch a quota block which
has nothing but the crc wrong, I think.  I need to think harder
about that because crc handling for quotas seems special...)

Thanks,
-Eric
