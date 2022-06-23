Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4B5C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 21:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiFWVjy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 17:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWVju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 17:39:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7026253A68;
        Thu, 23 Jun 2022 14:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B951IFfxXwVmTMpaQxGWiDFfMTyoQ6AY48dvmxhHbnM=; b=LFz2tPRqct9R+0ucOSJcnOsd57
        riXu0xmaPBB+IS8amG1jhrxd7brgKyxcEJrLzTbakquqrT6rOIZi8Mpeb5a+dpTGy5P0ZFDVmPRoP
        TOfPr+ZohqI4JwOMXDuSnzYHdVqOIfay/CViL0Vef5sX+nsXjfExQBattzy7boKk5rVc4DKUDiK35
        XYSsn5GathqHdJGxoW3xA6dmXi7DC3zJQgnQhEkL0e7eJTgHNnKuAxtZLY8qmgienuPS6k8b6+/oF
        0AIXPvaOsU8fBwaAfB6OyTfuZpAxwc8ZC0zQugSS0SEEpgZeMtqtiMW/17Annb7ioFL3XjtnYhngw
        v8dmJwag==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4UYD-00GsZS-5Z; Thu, 23 Jun 2022 21:39:45 +0000
Date:   Thu, 23 Jun 2022 14:39:45 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrTdobjy2ARkrul1@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <CAOQ4uxiNncOAM6cLPia6VNbKz0nZ4vUx1GHnHAN44JRgC6q1ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiNncOAM6cLPia6VNbKz0nZ4vUx1GHnHAN44JRgC6q1ug@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 08:31:30AM +0300, Amir Goldstein wrote:
> To put it in more blunt terms, the core test suite, fstests, is not
> very reliable. Neither kdevops nor fstests-bld address all the
> reliability issue (and they contribute some of their own).
> So we need the community to run both to get better and more
> reliable filesystem test coverage.

The generic pains with fstests / blktests surely can be shared and
perhaps that is just a think we need to start doing more regularly at
LSFMM more so than a one-off thing.

> Nevertheless, we should continue to share as much experience
> and data points as we can during this co-opetition stage in order to
> improve both systems.

Yes, my point was not about killing something off, it was about sharing
data points, and I think we should at least share configs.

I personally see value in sharing expunges, but indeed if we do we'd
have to decide if to put them up on github with just the expunge list
alone, or do we also want to upload artifacts on the same tree. Or
should we dump all the artifacts into a storage pool somewhere. Some
artifacts can grow to insane sizes if a test is bogus, I ran into one
once which was at least 2 GiB of output on a *.bad file. The error was
just reapeating over and over. I think IIRC it was for ZNS for btrfs or
for a blktests zbd test where the ouput was just an error repeating
itself over and over. We could just have a size limit on these. And if
experience is to show us anyting perahps adopt an epoch thing if we
use git.

  Luis
