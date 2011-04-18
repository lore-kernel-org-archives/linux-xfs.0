Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3I0WXE3221237 for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 19:32:34 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54384119C0F0
	for <xfs@oss.sgi.com>; Sun, 17 Apr 2011 17:35:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fSlTCCKyeAkPDuBP for <xfs@oss.sgi.com>;
	Sun, 17 Apr 2011 17:35:57 -0700 (PDT)
Date: Mon, 18 Apr 2011 10:35:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110418003553.GR21395@dastard>
References: <20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<BANLkTikEeXcvjgREoRCgriWAhZfnxJVtKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikEeXcvjgREoRCgriWAhZfnxJVtKQ@mail.gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Sat, Apr 16, 2011 at 02:05:51PM +0800, Yongqiang Yang wrote:
> On Sat, Apr 16, 2011 at 8:50 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Apr 14, 2011 at 11:01:04PM -0600, Andreas Dilger wrote:
> >> On 2011-04-14, at 6:09 PM, Dave Chinner <david@fromorbit.com>
> >> wrote:
> >> > No, this was explicitly laid out in the fiemap interface
> >> > discussions - it's up to the applicaiton to decide if it needs
> >> > to do a sync first. That's what the FIEMAP_FLAG_SYNC control
> >> > flag is for. =A0This forces the fiemap call to do a fsync _before_
> >> > getting the mapping. If you want to know the exact layout of the
> >> > file is, then you must use this flag.
> >> >
> >> > Even so, it is recognised that this is racy - any use of the
> >> > block map has a time-of-read-to-time-of-use race condition that
> >> > means you have to _verify_ the copy after it completes. FYI,
> >> > that's what xfs_fsr does when copying based on extent maps - if
> >> > the inode has changed in _any way_ during the copy, it aborts
> >> > the copy of that file.
> >> >
> >> > i.e. using fiemap for copying is at best a *hint* about the
> >> > regions that need copying, and it is in no way a guarantee that
> >> > you'll get all the information you need to make accurate copy
> >> > even if you do use the synchronous variant.
> >>
> >> I would tend to agree with P=E1draig. If there is data in the
> >> mapping (regardless of whether it is on disk or not), the FIEMAP
> >> should return this to the caller. =A0The SYNC flag is only intended
> >> to flush the data to disk for tools that are doing
> >> direct-to-disk operations on the data.
> >
> > What you are suggesting is that FIEMAP needs to be page cache
> > coherent, and that is far, far away from the intended use of the
> > interface. Even consiering that you need to looking for active pages
> > in the page cache when mapping extents say to me that you are
> > doing something very wrong.
> >
> > Unwritten extents remain unwritten until the data is physically
> > written to them. Therefore, to change their state, you need to sync
> No, buffered writes change their state without sync.

They shouldn't.

> > the data covering the range. =A0_Lying_ about whether an extent is in
> > the unwritten state is a really bad precedence to set, especially as
> > it is then guaranteed to change state when a crash occurs (Why did
> > recovery zero out my file? FIEMAP said it contained data before my
> > system crashed!).
> =

> All filesystems have metadata in memory which is not flushed to
> permanent storage. e.g. if a extent exists in memory, but itself and
> corresponding data are not flushed to permanent storage.

Sure, but in the case of unwritten extents, XFS does not change the
metadata state in memory until *after the physical IO is completed*.
I'm pretty sure that btrfs is the same.

IOWs, despite the fact that a buffered write has occurred, no
metadata has changed state in memory, and the extents are still
unwritten in both memory and on disk....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
