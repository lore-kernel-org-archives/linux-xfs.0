Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41288 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbeDXQKa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 12:10:30 -0400
Subject: Re: xfs fstrim and quota
References: <c3cbf69c52f0e89631c796016449bbe3@berlin.de>
 <483b7b2c592450221bb5567e64bad84e@berlin.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <30bb656c-b2d8-303e-344e-a1de6698c4d1@sandeen.net>
Date: Tue, 24 Apr 2018 10:10:27 -0600
MIME-Version: 1.0
In-Reply-To: <483b7b2c592450221bb5567e64bad84e@berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: michael.arndt@berlin.de, linux-xfs@vger.kernel.org



On 4/24/18 2:28 AM, michael.arndt@berlin.de wrote:
> Hello *
> 
> Will fstrim operations for a thin provisioning storage and xfs quota conflict with each other ?
> 
> If i understand fstrim code correctly, in case of xfs / thin provisioning  storage it tells xfs to release unused blocks.
> 
> I have read indications that blocks are marked to the underlying storage as freed by zeroing them out.

Brian addressed most of this, I think, but the short answer is that no, fstrim
will in no way affect xfs quota.  Everything happening as a result of fstrim
happens well below what the quota subsystem even knows about.  Even if discard
happens via WRITE_SAME, that's not anything quota is aware of.

Short answer is: There is no conflict.

Thanks,
-Eric
 
> Is the "write zeros" correct information, or will be commands like scsi unmap or FITRIM be sent to the storage ?
> 
> I found many exact references to fstrim on SSD, but no technical description on which operation is implemented for thin provisioning storages.
> 
> TIA
> Micha
