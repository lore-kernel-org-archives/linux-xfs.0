Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57804 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbeENSem (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 14:34:42 -0400
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia>
 <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d6405778-f3cb-57c8-33d6-6ea66fe06b44@sandeen.net>
Date: Mon, 14 May 2018 13:34:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs list <linux-xfs@vger.kernel.org>



On 5/14/18 12:52 PM, Chris Murphy wrote:
> On Mon, May 14, 2018 at 11:36 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
>> On Mon, May 14, 2018 at 11:15:27AM -0600, Chris Murphy wrote:
>>> Downstream bug, Fedora Rawhide being a canary in the coal mine!
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1575797
>>>
>>> Comment 8 about the kernel warning related to freeze/thaw is curious
>>> but ends up being unrelated to this problem.
>>>
>>> The gist is that xfsprogs 4.16.0 formatted volumes aren't recognized
>>> by either GRUB user space tools, or the GRUB core.img (whether of the
>>> embedded BIOS variety or the grubx64.efi variety)
>>>
>>> Anyway, open question for XFS devs if this should be fixed in xfsprogs
>>> or GRUB. I haven't tested this with syslinux to know if it has a
>>> similar problem.
>>
>> mkfs.xfs 4.16 enables sparse inodes by default, which is why grub
>> doesn't recognise the boot fs.  grub needs fixing, or $installer needs
>> to disable sparse inodes, I think.
> 
> Is there a reason why this was made default before GRUB was fixed? Or
> would XFS devs prefer to not support /boot on XFS?

Coordination would have been good, but nobody thought about this issue.
It was a mistake, not a preference.

-Eric
