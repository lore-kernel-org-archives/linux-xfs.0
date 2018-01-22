Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:37893 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbeAVTpE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jan 2018 14:45:04 -0500
Received: by mail-oi0-f52.google.com with SMTP id m65so6795536oig.5
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 11:45:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia> <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
 <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
From: Philipp Schrader <philipp@peloton-tech.com>
Date: Mon, 22 Jan 2018 11:45:02 -0800
Message-ID: <CA+0CQ228zZwk0XqR2a0fD49tbfZ=NHxsv=W=EScMU4u7Ng6F2w@mail.gmail.com>
Subject: Re: Reproducible XFS filesystem artifacts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>, Theodore Tso <tytso@mit.edu>

On Tue, Jan 16, 2018 at 8:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 17, 2018 at 2:52 AM, Philipp Schrader
> <philipp@peloton-tech.com> wrote:
>>> > I've not had much luck digging into the XFS spec to see prove that the
>>> > ctime is different, but I'm pretty certain. When I mount the images, I
>>> > can see that ctime is different:
>>> > $ stat -c %x,%y,%z,%n /mnt/{a,b}/log/syslog
>>> > 2017-12-28 11:26:53.552000096 -0800,1969-12-31 16:00:00.000000000
>>> > -0800,2017-12-28 11:28:50.524000060 -0800,/mnt/a/log/syslog
>>> > 2017-12-28 10:46:38.739999913 -0800,1969-12-31 16:00:00.000000000
>>> > -0800,2017-12-28 10:48:17.180000049 -0800,/mnt/b/log/syslog
>>> >
>>> > As far as I can tell, there are no mount options to null out the ctime
>>> > fields. (As an aside I'm curious as to the reason for this).
>>>
>>> Correct, there's (afaict) no userspace interface to change ctime, since
>>> it reflects the last time the inode metadata was updated by the kernel.
>>>
>>> > Is there a tool that lets me null out ctime fields on a XFS filesystem
>>> > image
>>>
>>> None that I know of.
>>>
>>> > Or maybe is there a library that lets me traverse the file
>>> > system and set the fields to zero manually?
>>>
>>> Not really, other than messing up the image with the debugger.
>>
>> Which debugger are you talking about? Do you mean xfs_db? I was really
>> hoping to avoid that :)
>>
>>>
>>> > Does what I'm asking make sense? I feel like I'm not the first person
>>> > to tackle this, but I haven't been lucky with finding anything to
>>> > address this.
>>>
>>> I'm not sure I understand the use case for exactly reproducible filesystem
>>> images (as opposed to the stuff inside said fs), can you tell us more?
>>
>> For some background, these images serve as read-only root file system
>> images on vehicles. During the initial install or during a system
>> update, new images get written to the disks. This uses a process
>> equivalent to using dd(1).
>>
>
> So I'm curious. Why xfs and fat and not, say, squashfs?
> https://reproducible-builds.org/events/athens2015/system-images/

It's a good question. It's largely because of historical reasons
internally. We started with XFS on the first iteration of our product.
We fixed a few minor bugs and were overall really happy with
performance etc. Later down the line came the question of system
upgrades without breaking what we currently had. Anyway, so XFS is
where we're at today.

That being said, for the future something like squashfs is definitely
a better choice. Thanks for the suggestion. I'll do more research on
that.

> A quick glance at mksquashfs --help suggests its a much better
> tool for the job (e.g. -fstime secs), not to mention that squashfs
> is optimized for the read-only root file system distribution use case.
>
> Another example of read-only root file system distributed over the
> air to a few billion devices is ext4 on Android.
> I'm not sure if Android build system cares about reproducible
> system image, but I know it used to create the "system" image with
> a home brewed tool called make_ext4fs which creates a well
> "packed" fs. This means that fs takes the minimal space it can take
> from a given set of files. mkfs.ext4 was not designed for the use
> case of creating a file system with 0% free space.

That's fascinating. I hadn't heard of that tool, but it looks straight
forward. I was imagining something like that maybe existed for XFS,
but it's starting to sound like there isn't. I'm starting to think
that I've been approaching this problem from the wrong direction :)

> I remember Ted saying that he is happy Google moved away
> from from make_ext4fs (although it probably still lives on vendor
> builds), but I wonder is the Android build system replacement for
> creating a "packed" ext4 image?
>
> I added Ted to CC for his inputs, but I suggest that you add
> linux-fsdevel to CC for a larger diversity of inputs.
>
> That is not to suggest that you should not use xfs. You probably
> have your reasons for it, but whatever was already done by
> others for other fs (e.g. e2image -Qa) may be the way to go
> for xfs. xfs_copy would be the first tool I would look into extending
> for your use case.

That sounds reasonable. Thank you for the suggestion. I'll I'll take
another look at xfs_copy.

>
> Cheers,
> Amir.
