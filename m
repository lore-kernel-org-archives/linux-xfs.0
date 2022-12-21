Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF06FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 23:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiLUXIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 18:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLUXIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 18:08:00 -0500
Received: from newman.eecs.umich.edu (newman.eecs.umich.edu [141.212.113.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E680722B1A
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 15:07:58 -0800 (PST)
Received: from email.eecs.umich.edu (email.eecs.umich.edu [141.212.113.99] (may be forged))
        by newman.eecs.umich.edu (8.15.2/8.14.4) with ESMTPS id 2BLN7m193273015
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 21 Dec 2022 18:07:48 -0500
Received: from email.eecs.umich.edu (localhost [127.0.0.1])
        by email.eecs.umich.edu (8.15.2/8.13.0) with ESMTP id 2BLN7mVP3803868;
        Wed, 21 Dec 2022 18:07:48 -0500
Received: from localhost (tpkelly@localhost)
        by email.eecs.umich.edu (8.15.2/8.14.4/Submit) with ESMTP id 2BLN7mAJ3803865;
        Wed, 21 Dec 2022 18:07:48 -0500
Date:   Wed, 21 Dec 2022 18:07:48 -0500 (EST)
From:   Terence Kelly <tpkelly@eecs.umich.edu>
To:     Dave Chinner <david@fromorbit.com>
cc:     Suyash Mahar <smahar@ucsd.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: wish list for Santa (was: Re: XFS reflink overhead,
 ioctl(FICLONE))
In-Reply-To: <20221220021619.GF1971568@dread.disaster.area>
Message-ID: <alpine.DEB.2.22.394.2212211734340.3789880@email.eecs.umich.edu>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com> <Y5i0ALbAdEf4yNuZ@magnolia> <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com> <20221215001944.GC1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu> <20221218014649.GE1971568@dread.disaster.area> <alpine.DEB.2.22.394.2212180125330.2578935@email.eecs.umich.edu> <20221220021619.GF1971568@dread.disaster.area>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi Dave,

To answer your question below:

When we sent our observations about ioctl(FICLONE) performance recently, 
starting this e-mail thread, we were hoping for one of several outcomes: 
Perhaps we were misusing the feature, in which case guidance on how to 
obtain better performance would be helpful.  Or if we're not doing 
anything wrong, an explanation of why ioctl(FICLONE) isn't as fast as we 
expected based on experience with the clone-based crash-tolerance 
mechanism in AdvFS.  In recent days we've been getting the latter, for 
which we are grateful.  We may try to pass along your explanations in a 
paper we're writing; if so we'll offer y'all the opportunity to review 
this paper and ask if you'd like to be acknowledged.

In the longer term, we're very interested in any developments related to 
crash tolerance.  The details of interfaces are less important as long as 
user-level applications can with reasonable convenience and performance 
obtain a simple guarantee:  Following a power failure or other crash a 
file can always be restored to a state that the application deemed 
consistent (application-level invariants & correctness criteria hold). 
Ideally the application would like a synchronous function call whose 
successful return provides the consistent-recoverability guarantee for the 
current state of the file.  That's the guarantee that the original 
failure-atomic msync() of EuroSys 2013 provided.

Obtaining this guarantee with ioctl(FICLONE) is quite convenient:  When 
the application knows that the file is in a consistent state, the 
application makes a clone and stashes the clone in a safe place.  Loosely 
speaking, the performance desired is that the work of cloning should be 
"O(delta) not O(data)", i.e., the time and effort required to make & stash 
a clone should be proportional to the amount of data in the file changed 
between consecutive clones, not to the logical size of the entire file. 
I gather from our recent correspondence that XFS cloning today requires 
O(data) time and effort, not O(delta).  Which is progress; we have a much 
better understanding of what's going on under the hood.

We understand that you're volunteers and that you're busy with many 
important matters.  We're not asking for any further work, though we'll 
surely applaud from the sidelines any improvements toward crash tolerance.

I've been thinking about alternative approaches to crash tolerance for 
over a decade.  In practice today people use things like relational 
databases and transactional key-value stores to protect application data 
integrity from crashes. I'm interested in other approaches, including but 
not limited to failure-atomic msync() and the moral equivalents thereof 
implemented with help from file systems.  I've worked on a half-dozen 
variants of this theme and I'd be happy to explain why I think this area 
is exciting to anyone willing to listen.  In a nutshell I look forward to 
the day when file systems render relational databases and transactional 
key-value stores obsolete for some (not all) use cases.

Thanks again for your extraordinary help clarifying matters, which goes 
above & beyond the call of duty, and happy holidays!

-- Terence



On Tue, 20 Dec 2022, Dave Chinner wrote:

>> I mainly want to emphasize that nobody is asking for the behavior of 
>> AdvFS in that FAST 2015 paper.
>
> OK, so what are you asking us to do, then?
