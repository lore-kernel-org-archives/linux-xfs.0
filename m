Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:11286 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751105AbdHBGds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 02:33:48 -0400
Subject: Re: metadata I/O error: block 0x575b6d70,("xfs_trans_read_buf_map")
 error 4 numblks 16
References: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
 <20170801222330.GO17762@dastard>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <5bea38f2-e5c6-245b-f734-4870b3eb1b57@profihost.ag>
Date: Wed, 2 Aug 2017 08:33:46 +0200
MIME-Version: 1.0
In-Reply-To: <20170801222330.GO17762@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


Am 02.08.2017 um 00:23 schrieb Dave Chinner:
> On Tue, Aug 01, 2017 at 10:12:57AM +0200, Stefan Priebe - Profihost AG wrote:
>> Hello,
>>
>> under very high load i'm getting the following error on a bcache device
>> using XFS:
>> XFS (bcache1): metadata I/O error: block 0x575b6d70
>> ("xfs_trans_read_buf_map") error 4 numblks 16
> 
> #define EINTR            4      /* Interrupted system call */
> 
> That's an EINTR error coming from the block layer. This is most
> definitely not an error that the block layer should be returning to
> the filesystem.
> 
> IOWs, you've hit a bcache bug.

Yes, thanks!

Stefan

> Cheers,
> 
> Dave.
> 
