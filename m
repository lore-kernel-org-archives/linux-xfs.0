Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbeJGHTx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Oct 2018 03:19:53 -0400
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
References: <20181004175839.18736-1-idryomov@gmail.com>
 <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard>
 <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
 <67627995-714c-5c38-a796-32b503de7d13@sandeen.net>
 <20181005232710.GH12041@dastard>
 <CAOi1vP-Z7xZk1YvWHYWQGOHfyWccFCkyn8je0HBvGhGuUrXmaQ@mail.gmail.com>
 <20181006232037.GB18095@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <36bc3f17-e7d1-ce8b-2088-36ff5d7b1e8b@sandeen.net>
Date: Sat, 6 Oct 2018 19:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <20181006232037.GB18095@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 10/6/18 6:20 PM, Dave Chinner wrote:
>> Can you give an example of a use case that would be negatively affected
>> if this heuristic was switched from "sunit" to "sunit < swidth"?
> Any time you only know a single alignment characteristic of the
> underlying multi-disk storage. e.g. hardware RAID0/5/6 that sets
> iomin = ioopt, multi-level RAID constructs where only the largest
> alignment requirement is exposed, RAID1 devices exposing their chunk
> size, remote replication chunk alignment (because remote rep. is
> slow and so we need more concurrency to keep the pipeline full),
> etc.

So the tl;dr here is "given any iomin > 512, we should infer low seek
latency and parallelism and adjust geometry accordingly?"

-Eric
