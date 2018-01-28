Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46601 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeA1NHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jan 2018 08:07:18 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Date: Sun, 28 Jan 2018 13:59:56 +0100
Message-ID: <10612480.yRmMisqFVa@merkaba>
In-Reply-To: <20180125055144.qztiqeakw4u3pvqf@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Dave Chinner - 25.01.18, 06:51:
> The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> snapshot support I'm working on has been uploaded and can be found
> here:
> 
> https://www.youtube.com/watch?v=wG8FUvSGROw

I somehow knew that something about snapshots would be coming for XFS after 
seeing the reflink / COW and online scrub/repair work by Darrick. But I am 
highly surprised on the how. I also did not really expect pNFS file layout of 
Christoph to play a role here.

It totally makes sense to me right now, but on the other hand I found myself 
thinking "It can´t be that easy, can it?" after watching your talk.

Easy not in amount of coding work needed and some complexities you mentioned, 
so I totally get that it is a lot of work needed to pull this off, but easy in 
terms of the concept behind it. Yet, if a concept is easy that is quite a hint 
that it might actually be a good one. And if you really can get away with it… 
then by all means, have a go at it!

I am looking forward to this new "extraordinary way to eat your data" 
(Darrick) or create "blammo" and "kaboom" (Dave). :)

>From what I understand it is also way less of a "layering violation" than the 
approach in taken in BTRFS or ZFS. Actually it might not be a "layering 
violation" at all, since the different layers are still there and 
communicating with each other. Which opens a lot of potential on applying this 
to other filesystems and storage subsystems of the kernel.

I see benefit in having more than one concept and learn from each other. Maybe 
even a new dog like BTRFS can learn a trick from an old dog at some point in 
time. It sounds crazy to me to think like this at the moment… but for a long 
time it sounded crazy to try to implement snapshots or subvolumes to 
traditional filesystems.

Kudos to thinking out of the box!

-- 
Martin
