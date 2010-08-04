Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o746rV27016375 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 01:53:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65EB811CC2F8
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 00:01:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	da3SWVHt3yTaYBAB for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 00:01:52 -0700 (PDT)
Date: Wed, 4 Aug 2010 16:53:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100804065347.GZ7362@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
	<20100804004746.GT7362@dastard>
	<AANLkTikfK6z7b=0Vpijyz-3m3+_MTtcrbeQk-B9LkK61@mail.gmail.com>
	<20100804042725.GX7362@dastard>
	<AANLkTikkwW48u_y=Tzkh=ob-YanbOpGmCaAH7q=8PpFx@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikkwW48u_y=Tzkh=ob-YanbOpGmCaAH7q=8PpFx@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: xfs@oss.sgi.com

On Wed, Aug 04, 2010 at 12:39:08AM -0400, Ilia Mirkin wrote:
> On Wed, Aug 4, 2010 at 12:27 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Aug 03, 2010 at 09:15:53PM -0400, Ilia Mirkin wrote:
> >> On Tue, Aug 3, 2010 at 8:47 PM, Dave Chinner <david@fromorbit.com> wro=
te:
> >> > Ilia,
> >> >
> >> > Can you send me the output of this for your kernel that the
> >> > traces came from:
> >> >
> >> > $ gdb <path/to/vmlinux>
> >> > (gdb) l *( xfs_write+0x2cc)
> >> >
> >> > You can run it against the vmlinux file in the kernel build
> >> > directory. =A0Basically I need to know which xfs_ilock() call in
> >> > xfs_write() one of the mysqld-test processes is stuck on.
> >>
> >> No problem - BTW, I'm running this on a 2.6.33.3 kernel (same as the
> >> one before, although diff hardware). If you want (and are fine with me
> >> "destroying" the current state), I can upgrade it to a kernel of your
> >> choice and repeat the test overnight.
> >>
> >> Naturally I didn't have CONFIG_DEBUG_INFO in there... just changed
> >> that to Y and recompiled. I'm not entirely sure that this preserves
> >> all the offsets, but at least the BUG-HUNTING doc makes allusions that
> >> it would.
> >>
> >> (gdb) l *( xfs_write+0x2cc)
> >> 0xffffffff8124342d is in xfs_write (fs/xfs/linux-2.6/xfs_lrw.c:597).
> >> 592 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!need_i_mutex && (mapp=
ing->nrpages || pos
> >> > xip->i_size)) {
> >> 593 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_iunloc=
k(xip, XFS_ILOCK_EXCL|iolock);
> >> 594 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iolock =3D=
 XFS_IOLOCK_EXCL;
> >> 595 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 need_i_mut=
ex =3D 1;
> >> 596 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock=
(&inode->i_mutex);
> >> 597 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ilock(=
xip, XFS_ILOCK_EXCL|iolock);
> >
> > Make sense. Can you run 'l *(xfs_ilock+0x2c)' as well? I just need to
> > confirm which lock it has blocked on.
> =

> (gdb) l *(xfs_ilock+0x2c)
> 0xffffffff81221001 is in xfs_ilock (fs/xfs/linux-2.6/mrlock.h:48).
> 43              down_read_nested(&mrp->mr_lock, subclass);
> 44      }
> 45
> 46      static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
> 47      {
> 48              down_write_nested(&mrp->mr_lock, subclass);
> 49      #ifdef DEBUG
> 50              mrp->mr_writer =3D 1;
> 51      #endif
> 52      }

OK, that doesn't help - it followed into the inline function
rather than telling me which of the two calls in the function it
was. I guess I'll need the disassembly output to work it out.
Can you send the output of "disass xfs_ilock" instead? Thanks.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
