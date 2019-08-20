Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D1AC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 12:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3B3322DBF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 12:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfHTMXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 08:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729155AbfHTMXE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 08:23:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB46AA35FE0;
        Tue, 20 Aug 2019 12:23:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 482AB1001B11;
        Tue, 20 Aug 2019 12:23:02 +0000 (UTC)
Date:   Tue, 20 Aug 2019 08:23:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820122300.GB14307@bfoster>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
 <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
 <20190820080741.GE1119@dread.disaster.area>
 <62649c5f-5390-8887-fe95-4f873af62804@gmail.com>
 <20190820105101.GA14307@bfoster>
 <20190820112304.GF1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820112304.GF1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 20 Aug 2019 12:23:04 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 09:23:04PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 06:51:01AM -0400, Brian Foster wrote:
> > On Tue, Aug 20, 2019 at 04:53:22PM +0800, kaixuxia wrote:
> > FWIW if we do take that approach, then IMO it's worth reconsidering the
> > 1-2 liner I originally proposed to fix the locking. It's slightly hacky,
> > but really all three options are hacky in slightly different ways. The
> > flipside is it's trivial to implement, review and backport and now would
> > be removed shortly thereafter when we replace the on-disk whiteout with
> > the in-core fake whiteout thing. Just my .02 though..
> 
> We've got to keep the existing whiteout method around for,
> essentially, forever, because we have to support kernels that don't
> do in-memory translations of DT_WHT to a magic chardev inode and
> vice versa (i.e. via mknod). IOWs, we'll need a feature bit to
> indicate that we actually have DT_WHT based whiteouts on disk.
> 

I'm not quite following (probably just because I'm not terribly familiar
with the use case). If current kernels know how to fake up whiteout
inodes in memory based on a dentry, why do we need to continue to create
new on-disk whiteout inodes just because a filesystem might already have
such inodes on disk? Wouldn't the old format whiteouts just continue to
work as expected without any extra handling?

I can see needing a feature bit to restrict a filesystem from being used
on an unsupported, older kernel, but is there a reason we wouldn't just
enable that by default anyways?

Brian

> So we may as well fix this properly now by restructuring the code as
> we will still have to maintain this functionality for a long time to
> come.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
