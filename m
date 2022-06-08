Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7760CCA483
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiFHJK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiFHJJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:09:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486222DD58;
        Wed,  8 Jun 2022 01:26:59 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 11A6068AA6; Wed,  8 Jun 2022 10:26:55 +0200 (CEST)
Date:   Wed, 8 Jun 2022 10:26:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation
 in SGID directories
Message-ID: <20220608082654.GA16753@lst.de>
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-2-amir73il@gmail.com> <20220602005238.GK227878@dread.disaster.area> <CAOQ4uxjcumjxeWypahgYd9wLExLuipd9MTCc_8vfq6SFY7L4dA@mail.gmail.com> <20220602103149.gc6b5hzkense5nrs@wittgenstein> <CAOQ4uxjJBCw7bzK6TAuVd2hs+cs_86z97F06q7k9BE7yVP-Cvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjJBCw7bzK6TAuVd2hs+cs_86z97F06q7k9BE7yVP-Cvw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 11:25:10AM +0300, Amir Goldstein wrote:
> TBH, I am having a hard time following the expected vs. actual
> behavior in all the cases at all points in time.
> 
> Christoph,
> 
> As the author of this patch, do you have an opinion w.r.t backporting
> this patch alongs with vs. independent of followup fixes?
> wait for future fixes yet to come?

To me backporting it seems good and useful, as it fixes a relatively
big problem.  The remaining issues seem minor compared to that.

