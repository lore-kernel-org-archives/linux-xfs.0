Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37110 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdDKHqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 03:46:12 -0400
Received: by mail-wm0-f44.google.com with SMTP id u2so54124634wmu.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 00:46:11 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
 <20170410153529.GE3991@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
Date: Tue, 11 Apr 2017 10:46:07 +0300
MIME-Version: 1.0
In-Reply-To: <20170410153529.GE3991@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 04/10/2017 06:35 PM, Brian Foster wrote:
> On Mon, Apr 10, 2017 at 12:42:33PM +0300, Avi Kivity wrote:
>> On 04/10/2017 12:23 PM, Avi Kivity wrote:
>>> Today my kernel complained that in memory metadata is corrupt and
>>> asked that I run xfs_repair.  But xfs_repair doesn't like the
>>> superblock and isn't able to find a secondary superblock.
>>>
>>> Latest Fedora 25 kernel, new Intel NVMe drive (worked for a few weeks=

>>> without issue).
>>>
>>> Anything I can do to recover the data?
> Well I can't explain why you have a checksum error, but what do you mea=
n
> that xfs_repair doesn't like the superblock? Can you provide the
> xfs_repair output?
>
> It seems strange for xfs_repair to not find the superblock of a
> filesystem that can otherwise run log recovery up until it encounters
> the buffer with a bad crc.

Sorry, should have done it earlier.

$ sudo xfs_repair /dev/nvme0n1
Phase 1 - find and verify superblock...
couldn't verify primary superblock - not enough secondary superblocks=20
with matching geometry !!!

attempting to find secondary superblock...
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E......................................................................=
=2E.......................................^C


In a previous run, after returning from lunch, xfs_repair did not find=20
the secondary superblock.


The superblock is there though:

$ sudo file -s /dev/nvme0n1
/dev/nvme0n1: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)


I can provide it if it will help.

>
> It also might be useful to find out exactly what that error reported by=

> smartctl means. Are you aware of whether it pre-existed the filesystem
> issue or not?

I believe I ran it before and did not notice the error.  I deal with=20
many disks, though, so it could have been that I just didn't notice it,=20
or that I ran it on a different machine.

>
>> Error Information (NVMe Log 0x01, max 64 entries)
>> Num   ErrCount  SQId   CmdId  Status  PELoc          LBA  NSID    VS
>>    0          1     1  0x0000  0x0286      -            0     1     -
>>
>>


If CmdId is the opcode, then it's a flush (matches the fact that LBA=3D0)=
,=20
but I'm guessing it's the tag. 0x0286 is NVME_SC_ACCESS_DENIED, which=20
doesn't appear to match, though (if I picked the right enum).



