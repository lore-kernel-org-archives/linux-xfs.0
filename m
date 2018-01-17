Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36010 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbeAQEFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 23:05:19 -0500
Received: by mail-yw0-f172.google.com with SMTP id q6so3458637ywg.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 20:05:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia> <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jan 2018 06:05:17 +0200
Message-ID: <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
Subject: Re: Reproducible XFS filesystem artifacts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philipp Schrader <philipp@peloton-tech.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>, Theodore Tso <tytso@mit.edu>

On Wed, Jan 17, 2018 at 2:52 AM, Philipp Schrader
<philipp@peloton-tech.com> wrote:
>> > I've not had much luck digging into the XFS spec to see prove that the
>> > ctime is different, but I'm pretty certain. When I mount the images, I
>> > can see that ctime is different:
>> > $ stat -c %x,%y,%z,%n /mnt/{a,b}/log/syslog
>> > 2017-12-28 11:26:53.552000096 -0800,1969-12-31 16:00:00.000000000
>> > -0800,2017-12-28 11:28:50.524000060 -0800,/mnt/a/log/syslog
>> > 2017-12-28 10:46:38.739999913 -0800,1969-12-31 16:00:00.000000000
>> > -0800,2017-12-28 10:48:17.180000049 -0800,/mnt/b/log/syslog
>> >
>> > As far as I can tell, there are no mount options to null out the ctime
>> > fields. (As an aside I'm curious as to the reason for this).
>>
>> Correct, there's (afaict) no userspace interface to change ctime, since
>> it reflects the last time the inode metadata was updated by the kernel.
>>
>> > Is there a tool that lets me null out ctime fields on a XFS filesystem
>> > image
>>
>> None that I know of.
>>
>> > Or maybe is there a library that lets me traverse the file
>> > system and set the fields to zero manually?
>>
>> Not really, other than messing up the image with the debugger.
>
> Which debugger are you talking about? Do you mean xfs_db? I was really
> hoping to avoid that :)
>
>>
>> > Does what I'm asking make sense? I feel like I'm not the first person
>> > to tackle this, but I haven't been lucky with finding anything to
>> > address this.
>>
>> I'm not sure I understand the use case for exactly reproducible filesystem
>> images (as opposed to the stuff inside said fs), can you tell us more?
>
> For some background, these images serve as read-only root file system
> images on vehicles. During the initial install or during a system
> update, new images get written to the disks. This uses a process
> equivalent to using dd(1).
>

So I'm curious. Why xfs and fat and not, say, squashfs?
https://reproducible-builds.org/events/athens2015/system-images/

A quick glance at mksquashfs --help suggests its a much better
tool for the job (e.g. -fstime secs), not to mention that squashfs
is optimized for the read-only root file system distribution use case.

Another example of read-only root file system distributed over the
air to a few billion devices is ext4 on Android.
I'm not sure if Android build system cares about reproducible
system image, but I know it used to create the "system" image with
a home brewed tool called make_ext4fs which creates a well
"packed" fs. This means that fs takes the minimal space it can take
from a given set of files. mkfs.ext4 was not designed for the use
case of creating a file system with 0% free space.

I remember Ted saying that he is happy Google moved away
from from make_ext4fs (although it probably still lives on vendor
builds), but I wonder is the Android build system replacement for
creating a "packed" ext4 image?

I added Ted to CC for his inputs, but I suggest that you add
linux-fsdevel to CC for a larger diversity of inputs.

That is not to suggest that you should not use xfs. You probably
have your reasons for it, but whatever was already done by
others for other fs (e.g. e2image -Qa) may be the way to go
for xfs. xfs_copy would be the first tool I would look into extending
for your use case.

Cheers,
Amir.
