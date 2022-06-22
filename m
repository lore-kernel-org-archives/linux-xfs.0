Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605EDC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 00:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiFVAHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 20:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiFVAHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 20:07:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B5915831;
        Tue, 21 Jun 2022 17:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sigJDkoz0M+e883teC6LqmUFk5CfAmSb0+UHfvzEgpk=; b=bf2SqSeOzQmU1Vp7uyC56FP9yg
        gNuBpSS2MwYW9FCuMphAA9pseLGidxaG5xNEU48HbHlkwhCSdP6cRlFjAdsyyp8uSuG1ORftzsGO0
        bM5Z8VlrWXR2pKEp+BjVr5znWEKSMqzjV2Cb0qCF5lc5q54UL7C9iY9JqSu5pB+N2wqq8da8w8cVz
        zG/dGQFLcWh3aGg+AvS076lTlL2uNBYCFqEwr91UeAvPbJEhjNKPkVZKRbHRV1hbmNEnYMGebX8e1
        jZPNOHOGIT6BDP0NjJXppKTuMPK/hkKGvBPeUiSMNyu5JUdh/oX/vNtp7Z4kfO+6DxbaVoHUomLNz
        ODBWFgtw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3ntm-007lSQ-Di; Wed, 22 Jun 2022 00:07:10 +0000
Date:   Tue, 21 Jun 2022 17:07:10 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrJdLhHBsolF83Rq@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 

The coverage for XFS is using profiles which seem to come inspired
by ext4's different mkfs configurations.

Long ago (2019) I had asked we strive to address popular configurations
for XFS so that what would be back then oscheck (now kdevops) can cover
them for stable XFS patch candidate test consideration. That was so long
ago no one should be surprised you didn't get the memo:

https://lkml.kernel.org/r/20190208194829.GJ11489@garbanzo.do-not-panic.com

This has grown to cover more now:

https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config

For instance xfs_bigblock and xfs_reflink_normapbt.

My litmus test back then *and* today is to ensure we have no regressions
on the test sections supported by kdevops for XFS as reflected above.
Without that confidence I'd be really reluctant to support stable
efforts.

If you use kdevops, it should be easy to set up even if you are not
using local virtualization technologies. For instance I just fired
up an AWS cloud m5ad.4xlarge image which has 2 nvme drives, which
mimics the reqs for the methodology of using loopback files:

https://github.com/linux-kdevops/kdevops/blob/master/docs/seeing-more-issues.md

GCE is supported as well, so is Azure and OpenStack, and even custom
openstack solutions...

Also, I see on the above URL you posted there is a TODO in the gist which
says, "find a better route for publishing these". If you were to use
kdevops for this it would have the immediate gain in that kdevops users
could reproduce your findings and help augment it.

However if using kdevops as a landing home for this is too large for you,
we could use a new git tree which just tracks expunges and then kdevops can
use it as a git subtree as I had suggested at LSFMM. The benefit of using a
git subtree is then any runner can make use of it. And note that we
track both fstests and blktests.

The downside is for kdevops to use a new git subtree is just that kdevops
developers would have to use two trees to work on, one for code changes just
for kdevops and one for the git subtree for expunges. That workflow would be
new. I don't suspect it would be a really big issue other than addressing the
initial growing pains to adapt. I have used git subtrees before extensively
and the best rule of thumb is just to ensure you keep the code for the git
subtree in its own directory. You can either immediately upstream your
delta or carry the delta until you are ready to try to push those
changes. Right now kdevops uses the directory workflows/fstests/expunges/
for expunges. Your runner could use whatever it wishes.

We should discuss if we just also want to add the respective found
*.bad, *.dmesg *.all files for results for expunged entries, or if
we should be pushing these out to a new shared storage area. Right now
kdevops keeps track of results in the directory workflows/fstests/results/
but this is a path on .gitignore. If we *do* want to use github and a
shared git subtree perhaps a workflows/fstests/artifacts/kdevops/ would
make sense for the kdevops runner ? Then that namespace allows other
runners to also add files, but we all share expunges / tribal knowledge.

Thoughts?

  Luis
