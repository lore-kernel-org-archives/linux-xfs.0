Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f43.google.com ([209.85.161.43]:36409 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbfFMJCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 05:02:22 -0400
Received: by mail-yw1-f43.google.com with SMTP id t126so8039255ywf.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 02:02:22 -0700 (PDT)
Subject: Re: alternative take on the same page merging leak fix
References: <20190611151007.13625-1-hch@lst.de>
 <20190612010922.GA17522@ming.t460p> <20190612074527.GA20491@lst.de>
 <20190612101111.GA16000@ming.t460p>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5d781312-d28e-5bcc-4294-27facdd4a1e7@kernel.dk>
Date: Thu, 13 Jun 2019 03:02:10 -0600
MIME-Version: 1.0
In-Reply-To: <20190612101111.GA16000@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On 6/12/19 4:11 AM, Ming Lei wrote:
> On Wed, Jun 12, 2019 at 09:45:27AM +0200, Christoph Hellwig wrote:
>> On Wed, Jun 12, 2019 at 09:09:23AM +0800, Ming Lei wrote:
>>> We have to backport the fixes to -stable tree, and downstream need to
>>> ship the fix too.
>>>
>>> The issue is quite serious because the leak is in IO path and the whole
>>> system ram can be used up easily on some workloads. So I think the fix
>>> should be for 5.2, however, regression risk might be increased by
>>> pulling cleanup & re-factor in now.
>>>
>>> I really appreciate you may cook a fix-only patch for this issue.
>>> Especially the change in add pc page code isn't necessary for fixing
>>> the issue.
>>
>> Patches 3 and 4 have no dependencies on 1 and 2, and should have
>> arguably been ordered first in the series.
> 
> OK, that is good to make patch 3 &4 into 5.2, I will give a review
> soon.

I'll echo Mings sentiments here, for the series.

-- 
Jens Axboe
