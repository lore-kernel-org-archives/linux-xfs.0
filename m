Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403946AbfBNF5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 00:57:47 -0500
Subject: Re: [RFC PATCH v2 1/9] block: add nr_mirrors to request_queue
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190213095044.29628-2-bob.liu@oracle.com> <20190213160408.GW23000@mit.edu>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <56d2dc78-01f8-9991-9199-372fe864d9f0@oracle.com>
Date: Thu, 14 Feb 2019 13:57:20 +0800
MIME-Version: 1.0
In-Reply-To: <20190213160408.GW23000@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

On 2/14/19 12:04 AM, Theodore Y. Ts'o wrote:
> On Wed, Feb 13, 2019 at 05:50:36PM +0800, Bob Liu wrote:
>> @nr_mirrors is 1 by default which means only one copy, drivers e.g raid1 are
>> responsible for setting the right value. The maximum value is
>> BITS_PER_LONG which is 32 or 64. That should be big enough else retry lantency
>> may be too high.
> 
> This is admittedly bike-shedding, so feel free to ignore, but...
> 
> In the case of Raid 6, "mirrors" will be a bit of a misnomer.  Would
> "nr_recovery" be better?
> 

Now the initial/default value is 1 indicating only one copy of data.
Would nr_copy be more accurate?

> Thanks for working on this!!  I would be interested in using this for
> ext4 once it's available.
> 
> 				- Ted
> 
