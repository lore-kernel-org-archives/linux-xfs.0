Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6BBfacO221445 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 06:41:37 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A37B15AA323
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 04:44:28 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id J5QjnvCBC7NRjmpc
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 04:44:28 -0700 (PDT)
Received: by vws15 with SMTP id 15so3352302vws.26
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 04:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilOGA-XF2V_Z_7WntgA23CHNlfx1u0I8xJtHZDz@mail.gmail.com>
References: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
	<20100706231856.GC25018@dastard>
	<AANLkTilOGA-XF2V_Z_7WntgA23CHNlfx1u0I8xJtHZDz@mail.gmail.com>
From: Shaun Adolphson <shaun@adolphson.net>
Date: Sun, 11 Jul 2010 21:44:07 +1000
Message-ID: <AANLkTimcM9LfOHAH6q95esD4JU8Geb21750YMAh3JKBl@mail.gmail.com>
Subject: Re: CentOS 5.5 XFS internal errors (XFS_WANT_CORRUPTED_GOTO)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 8, 2010 at 9:21 PM, Shaun Adolphson <shaun@adolphson.net> wrote:
> On Wed, Jul 7, 2010 at 9:18 AM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> On Tue, Jul 06, 2010 at 08:57:45PM +1000, Shaun Adolphson wrote:
>> > Hi,
>> >
>> > We have been able to repeatably produce xfs internal errors
>> > (XFS_WANT_CORRUPTED_GOTO) on one of our fileservers. We are attempting
>> > to locally copy a 248Gig file off a usb drive formated as NTFS to the
>> > xfs drive. The copy gets about 96% of the way through and we get the
>> > following messages:
>> >
>> > Jun 28 22:14:46 terrorserver kernel: XFS internal error
>> > XFS_WANT_CORRUPTED_GOTO at line 2092 of file fs/xfs/xfs_bmap_btree.c.
>> > Caller 0xffffffff8837446f
>>
>> Interesting. That's a corrupted inode extent btree - I haven't seen
>> one of them for a long while. Were there any errors (like IO errors)
>> reported before this?
>>
>> However, the first step is to determine if the error is on disk or an
>> in-memory error. Can you post output of:
>>
>> =A0 =A0 =A0 =A0- xfs_info <mntpt>

meta-data=3D/dev/TerrorVolume/terror isize=3D256    agcount=3D130385,
agsize=3D32768 blks
              =3D                      sectsz=3D512   attr=3D1
data        =3D                      bsize=3D4096   blocks=3D4272433152, im=
axpct=3D25
              =3D                      sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2         bsize=3D4096   ascii-ci=3D0
log         =3Dinternal            bsize=3D4096   blocks=3D2560, version=3D1
             =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=
count=3D0
realtime  =3Dnone               extsz=3D4096   blocks=3D0, rtextents=3D0


>> =A0 =A0 =A0 =A0- xfs_repair -n after a shutdown

The out out of the xfs_repair -n is 6mb, below is the condensed
version. I can post the whole output if required.

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
       - agno =3D 0
.
.
.
       - agno =3D 130384
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.




>>
>> Can you upgrade xfsprogs (i.e. xfs_repair) to the latest version
>> (3.1.2) before you do this as well?

# xfs_repair -V
xfs_repair version 3.1.2


>
> We have upgraded the xfsprogs to 3.1.2 and in the process of
> collecting the required infomation.
>
>>
>> > We have reproduced the condition 3 times and each time we have been
>> > able to remount the drive ( to replay the transaction log ) and then
>> > preform and xfs_repair.
>> >
>> > We are just using cp to copy the file.
>> >
>> > Some further details about the system:
>> >
>> > Software:
>> > - Fresh install of CentOS 5.5 64bit all patches up to date
>> > - Kernel 2.6.18-194.3.1.el5.centos.plus
>>
>> I've got no idea exactly what version of XFS that has in it, so I
>> can't say off the top of my head whether this is a fixed bug or not.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>
>
>
> During other testing we have also been able to reproduce the issue by
> copying =A0a self generated 248Gig file from another system disk to the
> XFS disk. The file was generated using dd with an input of /dev/zero.
>
> All the existing data (~6TB ) was successfully copied onto the storage
> with out have the error. The thing to note is that all the existing
> files are much smaller than the one that we are trying to copy in (
> 248Gig ). And since we have been having the shutdown we have copied
> many smaller files ( files < 30Gig in size ) onto the storage area
> with out issue
>

Thanks,

Shaun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
