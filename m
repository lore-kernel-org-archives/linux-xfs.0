Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42672 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbeBBVge (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 16:36:34 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9F3E811704
        for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2018 15:36:11 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: xfs_scrub: call for testing
Message-ID: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
Date: Fri, 2 Feb 2018 15:36:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hey all - 

Darrick's done a great job with landing the xfs_scrub code in
upstream kernel v4.15, and now merged on the for-next branch of
xfsprogs to be released in xfsprogs-4.15.0.

As with any big new body of code, there might be some rough
edges despite best efforts.  It'd be great to have people do
some testing at this semi-early stage.

The 10,000ft overview is that the new xfs_scrub command can
/validate/ a lot of what's on disk while the filesystem
is mounted; and the ability to repair will come in the future.

For now, with the 4.15 kernel, functionality is limited to
"scrubbing" meaning that it will simply check for consistency;
in 4.15 there is no facility to repair or optimize/preen the
filesystem.

I'd really value feedback on scrub as it stand at this point -
Is the documentation clear?  Is the output correct?  Do the
tool's arguments make sense?  Does it segfault?  Does it
find real errors?  Does it crash your kernel? Does it
eat your data?

(haha no it won't eat your data)
((haha no can't promise that with 100% certainty))

Thanks,
-Eric
