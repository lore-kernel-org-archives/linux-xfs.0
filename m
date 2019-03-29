Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:40017 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbfC2OiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:38:08 -0400
Received: by mail-it1-f194.google.com with SMTP id y63so4186186itb.5
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 07:38:07 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] block: verify data when endio
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk> <yq1ftr5rbq1.fsf@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
Date: Fri, 29 Mar 2019 08:38:04 -0600
MIME-Version: 1.0
In-Reply-To: <yq1ftr5rbq1.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On 3/29/19 8:34 AM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> I told you this for the initial posting, and the objection still
>> stands.  Adding 40 bytes to struct bio is a no-go.
>>
>> So that's a big NAK on that series.
> 
> I think you missed Bob's comment that this will go in the existing
> bio_integrity field. I believe the main purpose of the series is to
> solicit feedback on the callback approach.

I didn't miss that, but it fixes nothing. That will unify the 40 bytes
with 8 bytes, we're still growing the bio by a LOT. And we can't even
nicely hide this behind some ifdef, sine distros enable everything and
hence we're solving nothing by doing that.

One potential solution could be to setup a specific bio_set for this,
and allocate your read bios out of that. Growing struct bio by an
enormous amount for this is just a non-starter to begin with, end of
story.

-- 
Jens Axboe
