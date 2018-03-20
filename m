Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:34550 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbeCTRwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 13:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <20180319233913.GA1150@dastard>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
 <CAM_iQpVBmhiN05ZpxEZ2cNLSJpczc7z=Sz7a1tnUGeQimtDTYA@mail.gmail.com> <20180319233913.GA1150@dastard>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 20 Mar 2018 10:52:24 -0700
Message-ID: <CAM_iQpUgstCYjfqHdmoPf0PniMwXPU=uGkDmfYOtb4hwi_XN9Q@mail.gmail.com>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Mar 19, 2018 at 4:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 19, 2018 at 02:37:22PM -0700, Cong Wang wrote:
>> On Mon, Oct 30, 2017 at 2:55 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> > Hello,
>> >
>> > We triggered a list corruption (double add) warning below on our 4.9
>> > kernel (the 4.9 kernel we use is based on -stable release, with only a
>> > few unrelated networking backports):
>>
>> We still keep getting this warning on 4.9 kernel. Looking into this again,
>> it seems xfs_setup_inode() could be called twice if an XFS inode is gotten
>> from disk? Once in xfs_iget() => xfs_setup_existing_inode(), and once
>> in xfs_ialloc().
>
> AFAICT, the only way this can happen is that if the inode ->i_mode
> has been corrupted in some way. i.e. there is either on-disk or
> in-memory corruption occurring.
>
>> Does the following patch (compile-only) make any sense? Again, I don't
>> want to pretend to understand XFS...
>
> No, it doesn't make sense because a newly allocated inode should
> always have a zero i_mode.

Got it.

>
> Have you turned on memory poisoning to try to identify where the
> corruption is coming from?
>

I don't consider it as a memory corruption until you point it out.
Will try to add slub_debug.


> And given that it might actually be on-disk corruption that is
> causing this, have you run xfs_repair on these filesystems to
> determine if they are free from on-disk corruption?

Not yet, I can try when it happens again.


>
> Indeed, that makes me wonder format are you running on these
> filesystems, because on the more recent v5 format we don't read

Seems I can't check the format on a mounted fs?

$ xfs_db -x /dev/sda1
xfs_db: /dev/sda1 contains a mounted filesystem

fatal error -- couldn't initialize XFS library


> newly allocated inodes from disk. Can you provide the info listed
> here:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> as that will tell us what code paths are executing on inode
> allocation.
>

The machine is already rebooted after that warning, so I don't know if
it is too late to collect xfs information, but here it is:

$ xfs_repair -V
xfs_repair version 4.5.0

$ xfs_info /
meta-data=/dev/sda1              isize=256    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=0
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
