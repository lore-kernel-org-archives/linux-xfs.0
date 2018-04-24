Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:28805 "EHLO
        waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755800AbeDXI2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 04:28:36 -0400
Received: from waikiki.ops.eusc.inter.net ([10.155.10.49] helo=localhost)
        by waikiki.ops.eusc.inter.net with esmtpa (Exim 4.91)
        id 1fAtJS-000LS3-A7
        for linux-xfs@vger.kernel.org; Tue, 24 Apr 2018 10:28:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Apr 2018 10:28:34 +0200
From: michael.arndt@berlin.de
Subject: Re: xfs fstrim and quota
In-Reply-To: <c3cbf69c52f0e89631c796016449bbe3@berlin.de>
References: <c3cbf69c52f0e89631c796016449bbe3@berlin.de>
Message-ID: <483b7b2c592450221bb5567e64bad84e@berlin.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello *

Will fstrim operations for a thin provisioning storage and xfs quota 
conflict with each other ?

If i understand fstrim code correctly, in case of xfs / thin 
provisioning  storage it tells xfs to release unused blocks.

I have read indications that blocks are marked to the underlying storage 
as freed by zeroing them out.

Is the "write zeros" correct information, or will be commands like scsi 
unmap or FITRIM be sent to the storage ?

I found many exact references to fstrim on SSD, but no technical 
description on which operation is implemented for thin provisioning 
storages.

TIA
Micha
