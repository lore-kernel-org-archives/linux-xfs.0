Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40967 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbeK3A7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 19:59:09 -0500
Received: by mail-qt1-f193.google.com with SMTP id d18so1977190qto.8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Nov 2018 05:53:42 -0800 (PST)
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
 <36bc3f17-e7d1-ce8b-2088-36ff5d7b1e8b@sandeen.net>
From: Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <0290ec9f-ab2b-7c1b-faaf-409d72f99e5f@gmail.com>
Date: Thu, 29 Nov 2018 08:53:39 -0500
MIME-Version: 1.0
In-Reply-To: <36bc3f17-e7d1-ce8b-2088-36ff5d7b1e8b@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 10/6/18 8:14 PM, Eric Sandeen wrote:
> On 10/6/18 6:20 PM, Dave Chinner wrote:
>>> Can you give an example of a use case that would be negatively affected
>>> if this heuristic was switched from "sunit" to "sunit < swidth"?
>> Any time you only know a single alignment characteristic of the
>> underlying multi-disk storage. e.g. hardware RAID0/5/6 that sets
>> iomin = ioopt, multi-level RAID constructs where only the largest
>> alignment requirement is exposed, RAID1 devices exposing their chunk
>> size, remote replication chunk alignment (because remote rep. is
>> slow and so we need more concurrency to keep the pipeline full),
>> etc.
> So the tl;dr here is "given any iomin > 512, we should infer low seek
> latency and parallelism and adjust geometry accordingly?"
>
> -Eric

Chiming in late here, but I do think that every decade or two (no disrespect to 
xfs!), it is worth having a second look at how the storage has changed under us.

The workload that has lots of file systems pounding on a shared device for 
example is one way to lay out container storage.

No argument about documenting how to fix this with command line tweaks for now, 
but maybe this would be a good topic for the next LSF/MM shared track of file & 
storage people to debate?

Ric
