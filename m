Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E80C432BE
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Aug 2021 00:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4139861004
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Aug 2021 00:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhH1AWd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 20:22:33 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:39068 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhH1AWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 20:22:31 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 5874661C27;
        Sat, 28 Aug 2021 10:21:39 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id n244a20sUbwo; Sat, 28 Aug 2021 10:21:39 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 4210661BEF;
        Sat, 28 Aug 2021 10:21:38 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id A1DE8680468; Sat, 28 Aug 2021 10:21:37 +1000 (AEST)
Date:   Sat, 28 Aug 2021 10:21:37 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Mysterious ENOSPC [was: XFS fallocate implementation incorrectly
 reports ENOSPC]
Message-ID: <20210828002137.GA3642069@onthe.net.au>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210827220343.GQ3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 28, 2021 at 08:03:43AM +1000, Dave Chinner wrote:
> On Fri, Aug 27, 2021 at 04:53:47PM +1000, Chris Dunlop wrote:
>> On 8/25/21 9:06 PM, Chris Dunlop wrote:
>>> Background: I'm chasing a mysterious ENOSPC error on an XFS
>>> filesystem with way more space than the app should be asking
>>> for. There are no quotas on the fs. Unfortunately it's a third
>>> party app and I can't tell what sequence is producing the error,
>>> but this fallocate issue is a possibility.
>>
>> Oh, another reference: this is extensive reflinking happening on this
>> filesystem.
>
> Ah. Details that are likely extremely important. The workload,
> layout problems and ephemeral ENOSPC symptoms match the description
> of the problem that was fixed by the series of commits that went
> into 5.13 that ended in this one:
>
> commit fd43cf600cf61c66ae0a1021aca2f636115c7fcb
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Wed Apr 28 15:06:05 2021 -0700
>
>    xfs: set aside allocation btree blocks from block reservation

Oh wow. Yes, sounds like a candidate. Is there same easy(-ish?) way of 
seeing if this fs is likely to be suffering from this particular issue or 
is it a matter of installing an appropriate kernel and seeing if the 
problem goes away?

The job getting this ENOSPC error is one of 45 similar jobs, and it's the 
only one getting the error. There doesn't seem to be anything special 
about this job, it's main file where the writes are going is the 9th 
largest (up to 1.8T), and it has a lot of extents (842G split into 750M 
extents) but not as many as some others (e.g. 809G split into 1G extents).  
That said, the app works in mysterious ways so this particular job may be 
a special snowflake in some unobvious manner.

Cheers,

Chris
