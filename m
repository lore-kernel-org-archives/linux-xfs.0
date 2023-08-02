Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56572C04A6A
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 17:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjHBRFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjHBRFj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 13:05:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5CE1B9
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 10:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F8161A4D
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 17:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC193C433C8;
        Wed,  2 Aug 2023 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690995937;
        bh=hlrK8x8sei3OVRLx5rXVnQrCY8jn4lE3MFm+w14m7C4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pIssmb9E/tgY1hQ/vys0RXcd3g/8zK6FwYofO7DlDnE0Q1Izl49xICC+yhAy4txy+
         NKHXjizHS2sFIK0gbhe/FJT37eHWbO/XO1taVCpGQ687/dFmFGchTo13zeGyXbawmf
         /m/q+E3vmAJg+UVVTtDbO1aep8jucS+W6IdScuGkklEm0JXxJf/o3dV4qN7nm7i1tu
         fZtA28Q4LFKsNQzWC709rZbQvnT9YZsqhLpe7733v4oBnA/4ZWIsnxcQvA8qnUxsfT
         Xnf/nYFou19Dx3nEsPDHPgb8f57llSrTLlAAmHDTr43ul06vdq7JdH73SGZqWy0YPQ
         SgHQaPpKLhVwA==
Date:   Wed, 2 Aug 2023 10:05:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: Interim XFS backports for 5.15 and 6.1
Message-ID: <20230802170536.GZ11352@frogsfrogsfrogs>
References: <20230802031039.GC358316@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802031039.GC358316@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 11:10:39PM -0400, Theodore Ts'o wrote:
> Hi,
> 
> As some of you may know, Leah has been out on medical leave for a
> while.  I had hoped that she would be back in mid-July, but it looks
> like it's going to be a bit longer.
> 
> As a result, I've taken it on myself to try to look at the more
> obvious backlog of patches that need to be backported to 5.15.  I've
> come up with this list (see below), and I've been giving this patch
> series extensive testing to make sure none of these would cause
> regressions.  Most of these fix bugs where the fact that a commit
> needs to be backported is noted in an xfstests test, and indeed,
> backporting the commit address the test failure.  Hence, xfs in 5.15
> passes xfstests significantly cleaner as a result.
> 
> I did note that there is one commit in the 6.1 LTS, "xfs: disable
> reaping in fscounters scrub" (2d5f38a31980 in upstream) that was not
> in the 5.15 LTS, but when I tried backporting this commit to 5.15, it
> resulted in a number of xfstests regressions, so I've dropped this
> commit from my proposed backports list for now.  I assume some one or
> more additional patches would need to be backported to 5.15 LTS.  A
> problem for later.
> 
> I'm continuing to run some additional tests, but so far, things look
> solid.  So I'm sending this to the linux-xfs list now so (a) XFS
> developers can take a look at the commits and the patches, and see if
> they look sane, and (b) to ask what the process should be in terms
> sending these commits to Greg in Leah's absence.  Leah has
> significantly more xfs experience than I do, so I won't be offended if
> more review is desired before giving these patches an LGTM.  In fact,
> I'd kind of appreciate it.  :-)
> 
> Also, I can also e-mail these patches to linux-xfs, but I didn't know
> if this would be desired before I potentially spammed the linux-xfs
> list.

Yes, sending a patchset tagged CANDIDATE to linux-xfs is accepted
practice.  Usually the, er, release manager will give them the once
over, ack them, and then you can send them to gregkh for stable.

Example:
https://lore.kernel.org/linux-xfs/20230714064509.1451122-1-amir73il@gmail.com/

and acked followup:
https://lore.kernel.org/linux-xfs/20230715063114.1485841-1-amir73il@gmail.com/

> Anyway, here is the summary of the proposed backports to 5.15.  Please
> take a look.
> 
> Thanks,
> 
> 					- Ted
> 
> (Commit id's are in the xfs-5.15 branch in my xfs-lts-backports git
> tree[1].  Commits that have the note "not yet in 6.1" branch has been
> backported to the proposed xfs-6.1 branch, although please note that
> the xfs-6.1 branch hasn't yet gotten as much testing as the xfs-5.15
> branch.)
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tytso/xfs-lts-backports.git
> 
> 
> 46080ca79d18 xfs: hoist refcount record merge predicates
>     commit 9d720a5a658f5135861773f26e927449bef93d61 upstream.   (v6.2)
>     note: not yet in 6.1 LTS

Greg will most probably NAK the whole 5.15 patchset on account of these
patches that aren't in 6.1.  <redact angry djwong rant about unfunded
mandates from the community leadership>

--D

>     pre-req for: xfs: estimate post-merge refcounts correctly
>     
> 45b231886605 xfs: estimate post-merge refcounts correctly
>     commit b25d1984aa884fc91a73a5a407b9ac976d441e9b upstream.   (v6.2)
>     note: not yet in 6.1 LTS
>     fixes: xfs/179
> 
> d16ab63aad9b xfs: add missing cmap->br_state = XFS_EXT_NORM update
>     commit 1a39ae415c1be1e46f5b3f97d438c7c4adc22b63 upstream.   (v5.18)
>     pre-req for: xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
>     
> b9de7b77ccd9 xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
>     commit d62113303d691bcd8d0675ae4ac63e7769afc56c upstream.   (v6.0)
>     fixes: xfs/553
>     
> 60cd06e242be xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
>     commit a9248538facc3d9e769489e50a544509c2f9cebe upstream.   (v6.4)
>     note: not yet in 6.1 LTS
>     fixes: xfs/597
>     
> 679add840fa6 xfs: use the directory name hash function for dir scrubbing
>     commit 9dceccc5822f2ecea12a89f24d7cad1f3e5eab7c upstream.   (v6.4)
>     note: not yet in 6.1 LTS
>     fixes: xfs/597
>     
> a07ec38ecc0e xfs: get root inode correctly at bulkstat
>     commit 817644fa4525258992f17fecf4f1d6cdd2e1b731 upstream.   (v6.2)
>     note: not yet in 6.1 LTS
>     fixes: xfs/557
>     
> 85cd6053e920 xfs: bound maximum wait time for inodegc work
>     commit 7cf2b0f9611b9971d663e1fc3206eeda3b902922 upstream.   (v5.19)
>     requested backport to fix bug: https://lore.kernel.org/all/20230710215354.GA679018@onthe.net.au/T/#u
> 
> eb639a92fb50 xfs: introduce xfs_inodegc_push()
>     commit 5e672cd69f0a534a445df4372141fd0d1d00901d upstream.   (v5.19)
>     requested backport to fix bug: https://lore.kernel.org/all/20230710215354.GA679018@onthe.net.au/T/#u
> 
