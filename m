Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o755jbWu068343 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 00:45:37 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C2D611CD9DF
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 22:54:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	qOzvQQ2V8TFHiCts for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 22:54:03 -0700 (PDT)
Date: Thu, 5 Aug 2010 15:45:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100805054553.GB7362@dastard>
References: <20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
	<20100804004746.GT7362@dastard>
	<AANLkTikfK6z7b=0Vpijyz-3m3+_MTtcrbeQk-B9LkK61@mail.gmail.com>
	<20100804042725.GX7362@dastard>
	<AANLkTikkwW48u_y=Tzkh=ob-YanbOpGmCaAH7q=8PpFx@mail.gmail.com>
	<20100804065347.GZ7362@dastard>
	<AANLkTi=BA_spq8UoTR5HwDMWSFCp+qO54gTyVu2gdNBc@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=BA_spq8UoTR5HwDMWSFCp+qO54gTyVu2gdNBc@mail.gmail.com>
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

On Wed, Aug 04, 2010 at 11:40:02AM -0400, Ilia Mirkin wrote:
> On Wed, Aug 4, 2010 at 2:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Aug 04, 2010 at 12:39:08AM -0400, Ilia Mirkin wrote:
> >> On Wed, Aug 4, 2010 at 12:27 AM, Dave Chinner <david@fromorbit.com> wr=
ote:
> >> > On Tue, Aug 03, 2010 at 09:15:53PM -0400, Ilia Mirkin wrote:
> >> >> On Tue, Aug 3, 2010 at 8:47 PM, Dave Chinner <david@fromorbit.com> =
wrote:
> >> >> > Ilia,
> >> >> >
> >> >> > Can you send me the output of this for your kernel that the
> >> >> > traces came from:
> >> >> >
> >> >> > $ gdb <path/to/vmlinux>
> >> >> > (gdb) l *( xfs_write+0x2cc)
> >> >> >
> >> >> > You can run it against the vmlinux file in the kernel build
> >> >> > directory. =A0Basically I need to know which xfs_ilock() call in
> >> >> > xfs_write() one of the mysqld-test processes is stuck on.
....
> > OK, that doesn't help - it followed into the inline function
> > rather than telling me which of the two calls in the function it
> > was. I guess I'll need the disassembly output to work it out.
> > Can you send the output of "disass xfs_ilock" instead? Thanks.
> =

> Looks like it's the first one.

Yup, that's what it looks like to me, too. That means it's the
XFS_IOLOCK_EXCL it is blocking trying to get, not the
XFS_ILOCK_EXCL. Well, that makes sense, and tells me that the
lockdep "held locks" output at the end  also includes locks we are
trying to obtain. That clears up that confusion.

Ok, I'll work from there. Thanks, Ilia.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
