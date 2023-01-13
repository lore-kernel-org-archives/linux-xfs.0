Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FECC3DA78
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Jan 2023 21:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjAMV21 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Jan 2023 16:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAMV21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2023 16:28:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45DBB4B6;
        Fri, 13 Jan 2023 13:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A97AB821EE;
        Fri, 13 Jan 2023 21:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C97C433EF;
        Fri, 13 Jan 2023 21:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673645303;
        bh=+LOMe2OqPEJSgizf4FONXQOWnYteBL2TgQhVXr9S6lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EwweU6WpaSNbtsWS6wu67tNYRWd1uBZknrDUzeGcYwy+WYv8WtOYXGJSvq+PpzH6E
         wNj0AlrthpO2w5fn9Q7atxMx9wi32mQXRAQH6WtuCbbXPW5+7yZ+9Qb6jL0s4W/yVd
         JalYZm7ypx9esqHCOh/P5TRLLrQMKqsM3q7Lz572YFpg29a1pw7IuK95/KpfmdrYa6
         KhqqR9cgInJGHglj8B4ejqNTfYlEBNraiNrC3fwN7LEJNzcWVsa31c3np+Yoz5z6zv
         DkLmq06aTyhe91rBL8g4w1gG4ne6NPw/lCuUc4pATvItJW3PZYACjOF/QbMXc730UD
         L8Z85JXxaxkZA==
Date:   Fri, 13 Jan 2023 13:28:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [NYE DELUGE 1/4] xfs: all pending online scrub improvements
Message-ID: <Y8HM9q0KoDyrAEbq@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
 <20230113201033.h2otptldp232pz3p@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113201033.h2otptldp232pz3p@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 14, 2023 at 04:10:33AM +0800, Zorro Lang wrote:
> On Fri, Dec 30, 2022 at 01:13:21PM -0800, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > As I've mentioned several times throughout 2022, I would like to merge
> > the online fsck feature in time for the 2023 LTS kernel.  The first big
> > step in this process is to merge all the pending bug fixes, validation
> > improvements, and general reorganization of the existing metadata
> > scrubbing functionality.
> > 
> > This first deluge starts with the design document for the entirety of
> > the online fsck feature.  The design doc should be familiar to most of
> > you, as it's been on the list for review for months already.  It
> > outlines in brief the problems we're trying to solve, the use cases and
> > testing plan, and the fundamental data structures and algorithms
> > underlying the entire feature.
> > 
> > After that come all the code changes to wrap up the metadata checking
> > part of the feature.  The biggest piece here is the scrub drains that
> > allow scrub to quiesce deferred ops targeting AGs so that it can
> > cross-reference recordsets.  Most of the rest is tweaking the btree code
> > so that we can do keyspace scans to look for conflicting records.
> > 
> > For this review, I would like people to focus the following:
> > 
> > - Are the major subsystems sufficiently documented that you could figure
> >   out what the code does?
> > 
> > - Do you see any problems that are severe enough to cause long term
> >   support hassles? (e.g. bad API design, writing weird metadata to disk)
> > 
> > - Can you spot mis-interactions between the subsystems?
> > 
> > - What were my blind spots in devising this feature?
> > 
> > - Are there missing pieces that you'd like to help build?
> > 
> > - Can I just merge all of this?
> > 
> > The one thing that is /not/ in scope for this review are requests for
> > more refactoring of existing subsystems.  While there are usually valid
> > arguments for performing such cleanups, those are separate tasks to be
> > prioritized separately.  I will get to them after merging online fsck.
> > 
> > I've been running daily online scrubs of every computer I own for the
> > last five years, which has helped me iron out real problems in (limited
> > scope) production.  All issues observed in that time have been corrected
> > in this submission.
> 
> The 3 fstests patchsets of the [NYE DELUGE 1/4] look good to me. And I didn't
> find more critical issues after Darrick fixed that "group name missing" problem.
> By testing it a whole week, I decide to merge this 3 patchsets this weekend,
> then we can shift to later patchsets are waiting for review and merge.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Ok, thanks!

--D

> Thanks,
> Zorro
> 
> > 
> > As a warning, the patches will likely take several days to trickle in.
> > All four patch deluges are based off kernel 6.2-rc1, xfsprogs 6.1, and
> > fstests 2022-12-25.
> > 
> > Thank you all for your participation in the XFS community.  Have a safe
> > New Years, and I'll see you all next year!
> > 
> > --D
> > 
> 
