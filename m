Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:39191 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfC2OuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:50:05 -0400
Received: by mail-it1-f193.google.com with SMTP id 139so4258801ita.4
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 07:50:05 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] block: verify data when endio
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk> <yq1ftr5rbq1.fsf@oracle.com>
 <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk> <yq1bm1trb4y.fsf@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
Date: Fri, 29 Mar 2019 08:50:03 -0600
MIME-Version: 1.0
In-Reply-To: <yq1bm1trb4y.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On 3/29/19 8:46 AM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> I didn't miss that, but it fixes nothing. That will unify the 40 bytes
>> with 8 bytes, we're still growing the bio by a LOT. And we can't even
>> nicely hide this behind some ifdef, sine distros enable everything and
>> hence we're solving nothing by doing that.
> 
> We'll just need to handle it exactly like the integrity stuff. We only
> allocate the extra bits when the underlying device indicates that it's
> required and desired.

The integrity stuff still has that nasty pointer in there. It'd be nice
to get rid of that as well, and hide it all in a parent container of the
bio.

-- 
Jens Axboe
