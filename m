Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A4DC38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjARAyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjARAx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:53:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239574862A;
        Tue, 17 Jan 2023 16:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF95B81645;
        Wed, 18 Jan 2023 00:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14810C433AC;
        Wed, 18 Jan 2023 00:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002523;
        bh=/KxbZEY/IJPxnr66j/aq+BobD4FM5r9xj9Zmw3RonKA=;
        h=Date:Subject:From:To:Cc:From;
        b=lYn3N/MvIRXKYJ87Qihv1hZy4jJpcU+t5Dhf+mbWCpz1AIEhCUghfw2MtmKP1uYC7
         NEXGxwZUIvrjcUSIqcT9Lo+wfLnb/L616H/1GyXI0SF2xvcyJjUjUXRLp+VfFmgzXR
         0UowYNlpQjwKAkPLVDFEHQm7xzQxKP8QFbLu0V0q3bbxlk85SjVNZEU+SbNbwMcnDP
         QfXgUtIyKypVqpJHAdkziLyz2F1vHKjSiBB3xsjObSZ2n/IEilPbUHAhwhHSpjfWUg
         27GPyLKYvQAZeLVfh+C7nETXAfLnxIJUVRfFcXNjARk5OMSwSM4iqPiyh42DN6W7Pt
         m1RGujlyFRDpA==
Date:   Tue, 17 Jan 2023 16:42:02 -0800
Subject: [PATCHSET v2 0/4] fstests: filesystem population fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, david@fromorbit.com
Message-ID: <167400103044.1915094.5935980986164675922.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

[original patchset cover letter from Dave]

common/populate operations are slow. They are not coded for
performance, and do things in very slow ways. Mainly doing loops to
create/remove files and forcing a task to be created and destroy for
every individual operation. We can only fork a few thousand
processes a second, whilst we can create or remove tens of thousands
of files a second. Hence population speed is limited by fork/exit
overhead, not filesystem speed. I also changed it to run all the
creation steps in parallel, which means they run as fast as the
filesystem can handle them rather than as fast as a single CPU can
handle them.

patch 1 and patch 3 address these issues for common/populate and
xfs/294.  I may update a bunch of other tests that use loop { touch
file } to create thousands of files to speed them up as well.

The other patch in this series (patch 2) fixes the problem with
populating an Xfs btree format directory, which currently fails
because the removal step that creates sparse directory data also
causes the dabtree index to get smaller and free blocks, taking the
inode from btree to extent format and hence failing the populate
checks.

More details are in the commit messages for change.

[further changes from Darrick]

This series moves the FMT_BTREE creation bugfix to be first in line,
since it's a bug fix.  Next, I convert the directory and xattr creation
loops into separate programs to reduce the execve overhead.  This alone
is sufficient for a 10x reduction in runtime without substantially
altering what gets written to disk and comes out in the xfs fsck fuzz
tests.

The last patch in this series starts parallelizing things, but I've left
most of that out since the parallelization patches make it harder to
reliably generate a filesystem image where we can fuzz a two-level inobt
and still mount the fs to run online fsck.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-populate-slowness
---
 common/populate |   89 ++++++++++++++++++++++++++++++-------------------------
 src/popattr.py  |   62 ++++++++++++++++++++++++++++++++++++++
 src/popdir.pl   |   72 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+), 41 deletions(-)
 create mode 100755 src/popattr.py
 create mode 100755 src/popdir.pl

