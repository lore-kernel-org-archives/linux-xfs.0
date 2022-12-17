Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D329EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 18:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLQSnc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 13:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLQSnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 13:43:31 -0500
Received: from newman.eecs.umich.edu (newman.eecs.umich.edu [141.212.113.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FC4DF52
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 10:43:29 -0800 (PST)
Received: from email.eecs.umich.edu (email.eecs.umich.edu [141.212.113.99] (may be forged))
        by newman.eecs.umich.edu (8.15.2/8.14.4) with ESMTPS id 2BHIhBAS3015457
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 17 Dec 2022 13:43:11 -0500
Received: from email.eecs.umich.edu (localhost [127.0.0.1])
        by email.eecs.umich.edu (8.15.2/8.13.0) with ESMTP id 2BHIhBCV2419449;
        Sat, 17 Dec 2022 13:43:11 -0500
Received: from localhost (tpkelly@localhost)
        by email.eecs.umich.edu (8.15.2/8.14.4/Submit) with ESMTP id 2BHIhBaq2419445;
        Sat, 17 Dec 2022 13:43:11 -0500
Date:   Sat, 17 Dec 2022 13:43:11 -0500 (EST)
From:   Terence Kelly <tpkelly@eecs.umich.edu>
To:     Mike Fleetwood <mike.fleetwood@googlemail.com>
cc:     Dave Chinner <david@fromorbit.com>, Suyash Mahar <smahar@ucsd.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
In-Reply-To: <CAMU1PDid0KYipUw-1Wznn_zVBcx6G5Y1K=AK7pLf60TqX02_Dw@mail.gmail.com>
Message-ID: <alpine.DEB.2.22.394.2212171325450.2414696@email.eecs.umich.edu>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com> <Y5i0ALbAdEf4yNuZ@magnolia> <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com> <20221215001944.GC1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu> <CAMU1PDid0KYipUw-1Wznn_zVBcx6G5Y1K=AK7pLf60TqX02_Dw@mail.gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



It's confusing.

My FAST '15 paper was co-authored with AdvFS developers from the HP 
Storage Division.  The paper mentions the open-source release of AdvFS.

There's not a lot of recent activity on open-source AdvFS:

https://sourceforge.net/p/advfs/discussion/

One thing is certain, however:  HP did not "abandon" AdvFS in 2008.  At 
the time of my FAST paper it was used under the hood in HP products and 
was being actively developed internally.  See Section 3 of the FAST paper. 
The whole point of the paper is to describe a new (internal-only) AdvFS 
feature.

I'm pretty sure (relying on memory) that the changes to AdvFS made by HP 
between 2008 and 2015 did not find their way into the open-source release.



On Sat, 17 Dec 2022, Mike Fleetwood wrote:

> On Fri, 16 Dec 2022 at 01:06, Terence Kelly <tpkelly@eecs.umich.edu> wrote:

>> (AdvFS is not open source and I'm no longer an HP employee, so I no 
>> longer have access to it.)
>
> Just to put the record straight, HP did (abandon and) open source AdvFS
> in June 2008.
> https://www.hp.com/hpinfo/newsroom/press/2008/080623a.html
>
> It's available under a GPLv2 license from
> https://advfs.sourceforge.net/
>
> Mike
>
