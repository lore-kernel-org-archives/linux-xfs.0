Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57878 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965174AbeFOCpv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 22:45:51 -0400
Subject: Re: [PATCH 2/2] mkfs: remove notion of config "type"
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
 <20180614164121.GC6825@magnolia> <20180614234239.GO10363@dastard>
 <CAB=NE6V7JmsPpkCB1zp0CuY5YTJvMonG7UJPjScKYVJZLWb3xg@mail.gmail.com>
 <20180615023304.GP10363@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <235ac120-5a94-0207-da54-badaa307502e@sandeen.net>
Date: Thu, 14 Jun 2018 21:45:49 -0500
MIME-Version: 1.0
In-Reply-To: <20180615023304.GP10363@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 6/14/18 9:33 PM, Dave Chinner wrote:
> On Thu, Jun 14, 2018 at 07:10:09PM -0700, Luis R. Rodriguez wrote:
>> Silly mobile gmail interface not letting me bottom-post... What if we treat
>> no version being present as version 0?
> 
> We haven't released anything yet so we should put it in there from
> the start rather than having to work around the lack of a version
> field later.

So, pretend I'm dumb ('cause I often am) and spell it out for me, what would
we do with a version?

If a config file contains a section or token that some version of mkfs doesn't
understand, it'll fail.

If we try to read a config file with a too-new version, we'd ... fail?

What does this gain us?

-Eric
