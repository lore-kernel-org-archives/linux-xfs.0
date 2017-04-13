Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33378 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753820AbdDMNwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 09:52:07 -0400
Received: by mail-wr0-f175.google.com with SMTP id l28so36176238wre.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 06:52:06 -0700 (PDT)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Re: Deadlock between block allocation and block truncation
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
Message-ID: <af73ca2f-5840-1399-9902-8f7482e29e49@gmail.com>
Date: Thu, 13 Apr 2017 16:52:03 +0300
MIME-Version: 1.0
In-Reply-To: <20170412161017.GA16590@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 12.04.2017 19:10, Christoph Hellwig wrote:
> Hi Nikolay,
> 
> I guess the culprit is that truncate can free up to two extents in
> the same transaction and thus try to lock two different AGs without
> requiring them to be in increasing order.
> 
> Does the one liner below fix the problem for you?

So after 200 runs of generic/299 I didn't hit the deadlock whereas
before it would hit in the first 30 or so. FWIW :

Tested-by: Nikolay Borisov <nborisov@suse.com>

On a different note - do you think that reducing the unmapped extents
from 2 to 1 would introduce any performance degradation during
truncation? Looking around the code this define is only used when doing
truncation, so perhaps a better thing to do would be to turn this
xfs_bunmapi arg to a boolean which signal whether we are doing
truncation or not. And if it is set to true have xfs_bunmapi unmap all
possible extents from only a single AG? I'm going to sift through the
git history to figure out where this requirement of maximum 2 extent
came to truncate, came.

Regards,
Nikolay
