Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o68BJ2sc037076 for <xfs@oss.sgi.com>; Thu, 8 Jul 2010 06:19:02 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4F8C4336FB
	for <xfs@oss.sgi.com>; Thu,  8 Jul 2010 04:21:53 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id YWqnGeE6LPp2Mzmf
	for <xfs@oss.sgi.com>; Thu, 08 Jul 2010 04:21:53 -0700 (PDT)
Received: by vws15 with SMTP id 15so920837vws.26
	for <xfs@oss.sgi.com>; Thu, 08 Jul 2010 04:21:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100706231856.GC25018@dastard>
References: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
	<20100706231856.GC25018@dastard>
From: Shaun Adolphson <shaun@adolphson.net>
Date: Thu, 8 Jul 2010 21:21:32 +1000
Message-ID: <AANLkTilOGA-XF2V_Z_7WntgA23CHNlfx1u0I8xJtHZDz@mail.gmail.com>
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

On Wed, Jul 7, 2010 at 9:18 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jul 06, 2010 at 08:57:45PM +1000, Shaun Adolphson wrote:
> > Hi,
> >
> > We have been able to repeatably produce xfs internal errors
> > (XFS_WANT_CORRUPTED_GOTO) on one of our fileservers. We are attempting
> > to locally copy a 248Gig file off a usb drive formated as NTFS to the
> > xfs drive. The copy gets about 96% of the way through and we get the
> > following messages:
> >
> > Jun 28 22:14:46 terrorserver kernel: XFS internal error
> > XFS_WANT_CORRUPTED_GOTO at line 2092 of file fs/xfs/xfs_bmap_btree.c.
> > Caller 0xffffffff8837446f
>
> Interesting. That's a corrupted inode extent btree - I haven't seen
> one of them for a long while. Were there any errors (like IO errors)
> reported before this?
>
> However, the first step is to determine if the error is on disk or an
> in-memory error. Can you post output of:
>
> =A0 =A0 =A0 =A0- xfs_info <mntpt>
> =A0 =A0 =A0 =A0- xfs_repair -n after a shutdown
>
> Can you upgrade xfsprogs (i.e. xfs_repair) to the latest version
> (3.1.2) before you do this as well?

We have upgraded the xfsprogs to 3.1.2 and in the process of
collecting the required infomation.

>
> > We have reproduced the condition 3 times and each time we have been
> > able to remount the drive ( to replay the transaction log ) and then
> > preform and xfs_repair.
> >
> > We are just using cp to copy the file.
> >
> > Some further details about the system:
> >
> > Software:
> > - Fresh install of CentOS 5.5 64bit all patches up to date
> > - Kernel 2.6.18-194.3.1.el5.centos.plus
>
> I've got no idea exactly what version of XFS that has in it, so I
> can't say off the top of my head whether this is a fixed bug or not.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



During other testing we have also been able to reproduce the issue by
copying  a self generated 248Gig file from another system disk to the
XFS disk. The file was generated using dd with an input of /dev/zero.

All the existing data (~6TB ) was successfully copied onto the storage
with out have the error. The thing to note is that all the existing
files are much smaller than the one that we are trying to copy in (
248Gig ). And since we have been having the shutdown we have copied
many smaller files ( files < 30Gig in size ) onto the storage area
with out issue

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
