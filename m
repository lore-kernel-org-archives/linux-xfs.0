Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:39229 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbeA0P4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 10:56:54 -0500
Received: by mail-yb0-f196.google.com with SMTP id 65so1279211ybz.6
        for <linux-xfs@vger.kernel.org>; Sat, 27 Jan 2018 07:56:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180127112833.g624srgy4qdhk6yd@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution> <CAOQ4uxiCN1yXFOs--pQhEczk8SyXX+-gk5QKF_2YO-VvvZ0sVw@mail.gmail.com>
 <20180127112833.g624srgy4qdhk6yd@destitution>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 27 Jan 2018 17:56:53 +0200
Message-ID: <CAOQ4uxi-UY1Ak3Ppu7yFux9v4S3BwgbwFYLJdivvc-Vt4REdFg@mail.gmail.com>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Jan 27, 2018 at 1:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jan 27, 2018 at 10:34:25AM +0200, Amir Goldstein wrote:
>> On Thu, Jan 25, 2018 at 7:51 AM, Dave Chinner <david@fromorbit.com> wrote:
>> >
>> > The video from my talk at LCA 2018 yesterday about the XFS subvolume and
>> > snapshot support I'm working on has been uploaded and can be found
>> > here:
>> >
>> > https://www.youtube.com/watch?v=wG8FUvSGROw
>> >
>> > I don't have the code in a reviewable form yet - there's still quite
>> > a bit of work before I get to that point, but this is a good
>> > introduction to how all the pieces will fit together....
>> >
>>
>> Very cool!
>>
>> Got any paper napkin design photo to share?
>
> No. I have some arch docs I wrote after the initial Poc on loopback
> devices and a bunch of bash, sed, awk and xfs_io hacks....
>
[...]
>
>> I suppose all subvolumes use the host fs journal?
>
> No. A subvolume is a "fully functioning filesystem" and so - by
> definition - they each have their own internal journal. The journal
> IO remapping and COW functionality all works as seen in that demo...

So is FUA from subvolume going to be handled the same as with loop
(fsync of entire image file) or more efficiently? for example by flushing
only dirty pages that are already mapped?

Cheers,
Amir.
