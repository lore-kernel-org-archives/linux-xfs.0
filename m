Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46358 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbeKFHmT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Nov 2018 02:42:19 -0500
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <41f009c2-8f17-ca67-6981-72160bdc94c7@sandeen.net>
Date: Mon, 5 Nov 2018 16:20:24 -0600
MIME-Version: 1.0
In-Reply-To: <20181105215139.GA3160@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 11/5/18 3:51 PM, Christoph Hellwig wrote:
> On Mon, Nov 05, 2018 at 01:10:21PM -0500, Brian Foster wrote:
>> When online discard is enabled, discards of busy extents are
>> submitted asynchronously as a bio chain. bio completion and
>> resulting busy extent cleanup is deferred to a workqueue. Async
>> discard submission is intended to avoid blocking log forces on a
>> full discard sequence which can take a noticeable amount of time in
>> some cases.
>>
>> We've had reports of this still producing log force stalls with XFS
>> on VDO,
> 
> Please fix this in VDO instead.  We should not work around out of
> tree code making stupid decisions.

Is there some downside to Brian's proposal, in principle?
It seems like it would be an improvement for device that might cause
a discard bottleneck like this.

Thanks,
-Eric
