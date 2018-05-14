Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:33947 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbeENTIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 15:08:46 -0400
Received: by mail-ot0-f169.google.com with SMTP id i5-v6so15587994otf.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 12:08:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d6405778-f3cb-57c8-33d6-6ea66fe06b44@sandeen.net>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia> <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
 <d6405778-f3cb-57c8-33d6-6ea66fe06b44@sandeen.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 May 2018 13:08:45 -0600
Message-ID: <CAJCQCtSSEmwAzED6uzkevV_o4cxwhcZ9sf398wG-7HNCg3dOsA@mail.gmail.com>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 12:34 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 5/14/18 12:52 PM, Chris Murphy wrote:
>> On Mon, May 14, 2018 at 11:36 AM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>>> On Mon, May 14, 2018 at 11:15:27AM -0600, Chris Murphy wrote:
>>>> Downstream bug, Fedora Rawhide being a canary in the coal mine!
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1575797
>>>>
>>>> Comment 8 about the kernel warning related to freeze/thaw is curious
>>>> but ends up being unrelated to this problem.
>>>>
>>>> The gist is that xfsprogs 4.16.0 formatted volumes aren't recognized
>>>> by either GRUB user space tools, or the GRUB core.img (whether of the
>>>> embedded BIOS variety or the grubx64.efi variety)
>>>>
>>>> Anyway, open question for XFS devs if this should be fixed in xfsprogs
>>>> or GRUB. I haven't tested this with syslinux to know if it has a
>>>> similar problem.
>>>
>>> mkfs.xfs 4.16 enables sparse inodes by default, which is why grub
>>> doesn't recognise the boot fs.  grub needs fixing, or $installer needs
>>> to disable sparse inodes, I think.
>>
>> Is there a reason why this was made default before GRUB was fixed? Or
>> would XFS devs prefer to not support /boot on XFS?
>
> Coordination would have been good, but nobody thought about this issue.
> It was a mistake, not a preference.
>

Can someone point to documentation for the change to include in a
report for GRUB devs?

I found this:
https://www.spinics.net/lists/xfs/msg36686.html

But all the documentation here seems stale:
http://xfs.org/index.php/XFS_Papers_and_Documentation
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure/tmp/en-US/html/index.html



-- 
Chris Murphy
