Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847F8EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 03:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjHBDLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 23:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjHBDK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 23:10:58 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8A0E6F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 20:10:56 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 3723AdgS021122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 1 Aug 2023 23:10:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690945841; bh=oDuzipdKU583K29pRtqoQyZ9L7A8qrekewodEcpjYRk=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=MhP+2LxlaovI9BGlSjeFkpcgCvBt9Jh79/UpOiV2xPHDByAOm2VH//4erBv+eP6Ws
         CCBCUzMT7SKA2Q/o5frNxYb4eiwTdxwFmBuZrcJTfHQH4DCSFXJuzLtQxGbJt//qAS
         xpFHD6ARorYVO6YIiKVel9Pw7P0a5d4mQbifSrHizAFVyAKAxz7NO5aUk9K0sv9GmO
         H/CDJDKZuHI4TQ6YHLGpNYNV+W62paFNGx3WPfD1C65ny952nJPJ/Wo8k4uMVPzevT
         86bIzbZpap1Ok4F30k9YSekQGcYGCeNxwisglU6sGwdaenVtZuVl364RZvzfw39Led
         c5s8reHm2Mpaw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4F2B015C04F1; Tue,  1 Aug 2023 23:10:39 -0400 (EDT)
Date:   Tue, 1 Aug 2023 23:10:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Interim XFS backports for 5.15 and 6.1
Message-ID: <20230802031039.GC358316@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

As some of you may know, Leah has been out on medical leave for a
while.  I had hoped that she would be back in mid-July, but it looks
like it's going to be a bit longer.

As a result, I've taken it on myself to try to look at the more
obvious backlog of patches that need to be backported to 5.15.  I've
come up with this list (see below), and I've been giving this patch
series extensive testing to make sure none of these would cause
regressions.  Most of these fix bugs where the fact that a commit
needs to be backported is noted in an xfstests test, and indeed,
backporting the commit address the test failure.  Hence, xfs in 5.15
passes xfstests significantly cleaner as a result.

I did note that there is one commit in the 6.1 LTS, "xfs: disable
reaping in fscounters scrub" (2d5f38a31980 in upstream) that was not
in the 5.15 LTS, but when I tried backporting this commit to 5.15, it
resulted in a number of xfstests regressions, so I've dropped this
commit from my proposed backports list for now.  I assume some one or
more additional patches would need to be backported to 5.15 LTS.  A
problem for later.

I'm continuing to run some additional tests, but so far, things look
solid.  So I'm sending this to the linux-xfs list now so (a) XFS
developers can take a look at the commits and the patches, and see if
they look sane, and (b) to ask what the process should be in terms
sending these commits to Greg in Leah's absence.  Leah has
significantly more xfs experience than I do, so I won't be offended if
more review is desired before giving these patches an LGTM.  In fact,
I'd kind of appreciate it.  :-)

Also, I can also e-mail these patches to linux-xfs, but I didn't know
if this would be desired before I potentially spammed the linux-xfs
list.

Anyway, here is the summary of the proposed backports to 5.15.  Please
take a look.

Thanks,

					- Ted

(Commit id's are in the xfs-5.15 branch in my xfs-lts-backports git
tree[1].  Commits that have the note "not yet in 6.1" branch has been
backported to the proposed xfs-6.1 branch, although please note that
the xfs-6.1 branch hasn't yet gotten as much testing as the xfs-5.15
branch.)

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tytso/xfs-lts-backports.git


46080ca79d18 xfs: hoist refcount record merge predicates
    commit 9d720a5a658f5135861773f26e927449bef93d61 upstream.   (v6.2)
    note: not yet in 6.1 LTS
    pre-req for: xfs: estimate post-merge refcounts correctly
    
45b231886605 xfs: estimate post-merge refcounts correctly
    commit b25d1984aa884fc91a73a5a407b9ac976d441e9b upstream.   (v6.2)
    note: not yet in 6.1 LTS
    fixes: xfs/179

d16ab63aad9b xfs: add missing cmap->br_state = XFS_EXT_NORM update
    commit 1a39ae415c1be1e46f5b3f97d438c7c4adc22b63 upstream.   (v5.18)
    pre-req for: xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
    
b9de7b77ccd9 xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
    commit d62113303d691bcd8d0675ae4ac63e7769afc56c upstream.   (v6.0)
    fixes: xfs/553
    
60cd06e242be xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
    commit a9248538facc3d9e769489e50a544509c2f9cebe upstream.   (v6.4)
    note: not yet in 6.1 LTS
    fixes: xfs/597
    
679add840fa6 xfs: use the directory name hash function for dir scrubbing
    commit 9dceccc5822f2ecea12a89f24d7cad1f3e5eab7c upstream.   (v6.4)
    note: not yet in 6.1 LTS
    fixes: xfs/597
    
a07ec38ecc0e xfs: get root inode correctly at bulkstat
    commit 817644fa4525258992f17fecf4f1d6cdd2e1b731 upstream.   (v6.2)
    note: not yet in 6.1 LTS
    fixes: xfs/557
    
85cd6053e920 xfs: bound maximum wait time for inodegc work
    commit 7cf2b0f9611b9971d663e1fc3206eeda3b902922 upstream.   (v5.19)
    requested backport to fix bug: https://lore.kernel.org/all/20230710215354.GA679018@onthe.net.au/T/#u

eb639a92fb50 xfs: introduce xfs_inodegc_push()
    commit 5e672cd69f0a534a445df4372141fd0d1d00901d upstream.   (v5.19)
    requested backport to fix bug: https://lore.kernel.org/all/20230710215354.GA679018@onthe.net.au/T/#u

