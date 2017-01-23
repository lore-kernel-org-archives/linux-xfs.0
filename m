Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41488 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdAWV1E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 16:27:04 -0500
Subject: Re: XFS issues with NVMe SSD
References: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
 <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net>
 <20170123135048.GB33287@bfoster.bfoster>
 <20170123135348.GA25320@infradead.org>
 <CAJCQCtQnH1PgUf=9gJT=5UpZ8SCGqvN-1rAvO3HLq9nQJkF+eA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <325e2a40-0ba6-a973-8ca4-933e44b075a9@sandeen.net>
Date: Mon, 23 Jan 2017 15:27:03 -0600
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQnH1PgUf=9gJT=5UpZ8SCGqvN-1rAvO3HLq9nQJkF+eA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Bond Masuda <bond.masuda@jlbond.com>, linux-xfs@vger.kernel.org



On 1/23/17 3:25 PM, Chris Murphy wrote:
> On Mon, Jan 23, 2017 at 6:53 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, Jan 23, 2017 at 08:50:48AM -0500, Brian Foster wrote:
>>> Since this is limited hardware (I don't have access to such hardware, at
>>> least), it might also be helpful to see if you can isolate the problem
>>> from a full distro install. For example, can you format such a device
>>> external to the rootfs, mount, copy some stuff and reproduce the
>>> corruption after some sequence of unmount/remount/reboot operations?
>>
>> I have plenty of NVMe hardware, although none of them is Intel and I've
>> never seen corruption like that.  I also don't run Fedora, though :)
>>
>> Does anyone know if the Fedora installer does a fstrim run or something
>> similar?  I remember that most Intel NVMe devices had some pretty severe
>> deallocate (aka discard on NVMe) bugs.  A firmware update might be a
>> good start in that case.
> 
> The installer doesn't do fstrim or blkdiscard before installation; but
> on my SSDs at least mkfs.xfs and mkfs.btrfs result in trim. So one
> possible test would be to manually mkfs with -k, and then if it's a
> live media installation, install manually from the booted live
> environment with:
> 
> rsync -pogAXtlHrDx --exclude /dev/ --exclude /proc/ --exclude /sys/
> --exclude /run/ --exclude /boot/*rescue* --exclude /etc/machine-id
> /run/install/source/ /mnt/sysimage

Right, mkfs does do trim...

Could also pre-mkfs, and tell anaconda to re-use the partition without
re-mkfs - is that possible?

-Eric
