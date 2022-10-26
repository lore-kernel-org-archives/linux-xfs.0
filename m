Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFC0C38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 08:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiJZIPK convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 04:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiJZIPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 04:15:08 -0400
X-Greylist: delayed 1287 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Oct 2022 01:15:06 PDT
Received: from smtp-out004.kontent.com (smtp-out004.kontent.com [81.88.40.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B791F2E9
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 01:15:04 -0700 (PDT)
Received: from rakete.bodenbinder.de (p2e595528.dip0.t-ipconnect.de [46.89.85.40])
        (Authenticated sender: bodenbinder_de@smtp-out004.kontent.com)
        by smtp-out004.kontent.com (Postfix) with ESMTPA id CFEC130641DE
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 09:53:35 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by rakete.bodenbinder.de (Postfix) with ESMTP id A08F12B0CFAE
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 09:53:30 +0200 (CEST)
Message-ID: <793f95a4b1f1efa959540aed9c48e751dd648c91.camel@bodenbinder.de>
Subject: xfs_scrub: inode record: Attempting optimization
From:   Matthias Bodenbinder <matthias@bodenbinder.de>
Reply-To: matthias@bodenbinder.de
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Date:   Wed, 26 Oct 2022 09:53:30 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I am not sure if this is the right place to ask my question. If not
please forgive me and point me to the correct place.

I have a question about xfs_scrub. When I run this on my root directory
I get plenty of info messages like:

####
# xfs_scrub -v / 
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/: using 24 threads to scrub.
Phase 2: Check internal metadata.
Phase 3: Scan all inodes.
Phase 4: Repair filesystem.
Info: inode 100663763 (3/467) inode record: Attempting optimization.
Info: inode 67169419 (2/60555) inode record: Attempting optimization.
Info: inode 33566167 (1/11735) inode record: Attempting optimization.
...

Phase 5: Check directory tree.
Phase 7: Check summary counters.
44,0GiB data used;  1,2M inodes used.
43,6GiB data found; 1,2M inodes found.
1,2M inodes counted; 1,2M inodes checked.
####


I see more than 3200 Info lines like this. And they occur also with any
subsequent scrub. They are not going away.

Can I fix this somehow or shall I just ignore it?

Kind Regards
Matthias

PS
This is on EndeavourOS with kernel 5.15.74-lts

