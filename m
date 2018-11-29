Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46235 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeK3LAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 06:00:34 -0500
Received: by mail-qt1-f196.google.com with SMTP id y20so4062096qtm.13
        for <linux-xfs@vger.kernel.org>; Thu, 29 Nov 2018 15:53:16 -0800 (PST)
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
 <0290ec9f-ab2b-7c1b-faaf-409d72f99e5f@gmail.com>
 <20181129214851.GU6311@dastard>
From: Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <39031e68-3936-b5e1-bcb6-6fdecc5988c1@gmail.com>
Date: Thu, 29 Nov 2018 18:53:14 -0500
MIME-Version: 1.0
In-Reply-To: <20181129214851.GU6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Ilya Dryomov <idryomov@gmail.com>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 11/29/18 4:48 PM, Dave Chinner wrote:
> On Thu, Nov 29, 2018 at 08:53:39AM -0500, Ric Wheeler wrote:
>> On 10/6/18 8:14 PM, Eric Sandeen wrote:
>>> On 10/6/18 6:20 PM, Dave Chinner wrote:
>>>>> Can you give an example of a use case that would be negatively affected
>>>>> if this heuristic was switched from "sunit" to "sunit < swidth"?
>>>> Any time you only know a single alignment characteristic of the
>>>> underlying multi-disk storage. e.g. hardware RAID0/5/6 that sets
>>>> iomin = ioopt, multi-level RAID constructs where only the largest
>>>> alignment requirement is exposed, RAID1 devices exposing their chunk
>>>> size, remote replication chunk alignment (because remote rep. is
>>>> slow and so we need more concurrency to keep the pipeline full),
>>>> etc.
>>> So the tl;dr here is "given any iomin > 512, we should infer low seek
>>> latency and parallelism and adjust geometry accordingly?"
>>>
>>> -Eric
>> Chiming in late here, but I do think that every decade or two (no
>> disrespect to xfs!), it is worth having a second look at how the
>> storage has changed under us.
>>
>> The workload that has lots of file systems pounding on a shared
>> device for example is one way to lay out container storage.
> The problem is that defaults can't cater for every use case.
> And in this case, we've got nothing to tell us that this is
> aggregated/shared storage rather than "the fileystem owns the
> entire device".
>
>> No argument about documenting how to fix this with command line
>> tweaks for now, but maybe this would be a good topic for the next
>> LSF/MM shared track of file & storage people to debate?
> Doubt it - this is really only an XFS problem at this point.
>
> i.e. if we can't infer what the user wants from existing
> information, then I don't see how the storage is going to be able to
> tell us anything different, either.  i.e. somewhere in the stack the
> user is going to have to tell the block device that this is
> aggregated storage.
>
> But even then, if it's aggregated solid state storage, we still want
> to make use of the concurency on increased AG count because there is
> no seek penalty like spinning drives end up with. Or if the
> aggregated storage is thinly provisioned, the AG count of filesystem
> just doesn't matter because the IO is going to be massively
> randomised (i.e take random seek penalties) by the thinp layout.
>
> So there's really no good way of "guessing" whether aggregated
> storage should or shouldn't use elevated AG counts even if the
> storage says "this is aggregated storage". The user still has to
> give us some kind of explict hint about how the filesystem should
> be configured.
>
> What we need is for a solid, reliable detection hueristic to be
> suggested by the people that need this functionality before there's
> anything we can talk about.
>
> Cheers,
>
> Dave.

I think that is exactly the kind of discussion that the shared file/storage 
track is good for. Other file systems also need to accommodate/probe behind the 
fictitious visible storage device layer...  Specifically, is there something we 
can add  per block device to help here?  Number of independent devices or a map 
of those regions?

Regards,

Ric
