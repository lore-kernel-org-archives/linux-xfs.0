Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56674 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755446AbcKCSPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Nov 2016 14:15:46 -0400
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc] larger
 batches for crc32c)
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
 <20161028160218.1af40906@roar.ozlabs.ibm.com>
 <20161031030853.GK22126@dastard>
 <20161101143918.4f154154@roar.ozlabs.ibm.com>
 <20161101054725.GZ14023@dastard> <58194CF8.1000501@tlinx.org>
 <20161103082950.GJ9920@dastard> <581B601A.4060403@tlinx.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9e488621-04e1-a9c6-04f7-78c954bd3d6e@sandeen.net>
Date: Thu, 3 Nov 2016 13:15:44 -0500
MIME-Version: 1.0
In-Reply-To: <581B601A.4060403@tlinx.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "L.A. Walsh" <xfs@tlinx.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/3/16 11:04 AM, L.A. Walsh wrote:
> 
> 
> Dave Chinner wrote:
>>
>> As most users never have things go wrong, all they think is "CRCs
>> are unnecessary overhead". It's just like backups - how many people
>> don't make backups because they cost money right now and there's no
>> tangible benefit until something goes wrong which almost never
>> happens?
> ----
>     But it's not like backups.  You can't run a util
> program upon discovering bad CRC's that will fix the file system
> because the file system is no longer usable.

Sure you can - xfs_repair knows what to do in such a case.

It's not guaranteed that you get /all/ your data back, in every
corrupted fs situation, but that's not because of CRCs - a bad CRC
is just the messenger about filesystem corruption.

> That means you
> have to restore from backup.  Thus, for those keeping
> backups, there is no benefit, as they'll have to restore
> from backups in either case. 

Again, as Dave said, the format changes implemented for CRCS help
us support XFS.  It's not something /directly/ useful to the user,
other than possibly stopping a corruption before it gets worse, by
early detection.

If you have a corruption which is so bad that you have to go to
backups, that would be true with or without CRCs.

-Eric
