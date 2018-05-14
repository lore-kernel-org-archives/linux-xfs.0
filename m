Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:46151 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeENRwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 13:52:20 -0400
Received: by mail-ot0-f173.google.com with SMTP id t1-v6so15287626ott.13
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 10:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180514173610.GC4933@magnolia>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 May 2018 11:52:18 -0600
Message-ID: <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 11:36 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, May 14, 2018 at 11:15:27AM -0600, Chris Murphy wrote:
>> Downstream bug, Fedora Rawhide being a canary in the coal mine!
>> https://bugzilla.redhat.com/show_bug.cgi?id=1575797
>>
>> Comment 8 about the kernel warning related to freeze/thaw is curious
>> but ends up being unrelated to this problem.
>>
>> The gist is that xfsprogs 4.16.0 formatted volumes aren't recognized
>> by either GRUB user space tools, or the GRUB core.img (whether of the
>> embedded BIOS variety or the grubx64.efi variety)
>>
>> Anyway, open question for XFS devs if this should be fixed in xfsprogs
>> or GRUB. I haven't tested this with syslinux to know if it has a
>> similar problem.
>
> mkfs.xfs 4.16 enables sparse inodes by default, which is why grub
> doesn't recognise the boot fs.  grub needs fixing, or $installer needs
> to disable sparse inodes, I think.

Is there a reason why this was made default before GRUB was fixed? Or
would XFS devs prefer to not support /boot on XFS?

-- 
Chris Murphy
