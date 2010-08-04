Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o741FZZb002920 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 20:15:35 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0936D34AB82
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 18:23:55 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id hWbgEIzzaBsrw2pS
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 18:23:55 -0700 (PDT)
Received: by vws15 with SMTP id 15so3619892vws.26
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 18:15:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100804004746.GT7362@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
	<20100804004746.GT7362@dastard>
Date: Tue, 3 Aug 2010 21:15:53 -0400
Message-ID: <AANLkTikfK6z7b=0Vpijyz-3m3+_MTtcrbeQk-B9LkK61@mail.gmail.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
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

On Tue, Aug 3, 2010 at 8:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> Ilia,
>
> Can you send me the output of this for your kernel that the
> traces came from:
>
> $ gdb <path/to/vmlinux>
> (gdb) l *( xfs_write+0x2cc)
>
> You can run it against the vmlinux file in the kernel build
> directory. =A0Basically I need to know which xfs_ilock() call in
> xfs_write() one of the mysqld-test processes is stuck on.

No problem - BTW, I'm running this on a 2.6.33.3 kernel (same as the
one before, although diff hardware). If you want (and are fine with me
"destroying" the current state), I can upgrade it to a kernel of your
choice and repeat the test overnight.

Naturally I didn't have CONFIG_DEBUG_INFO in there... just changed
that to Y and recompiled. I'm not entirely sure that this preserves
all the offsets, but at least the BUG-HUNTING doc makes allusions that
it would.

(gdb) l *( xfs_write+0x2cc)
0xffffffff8124342d is in xfs_write (fs/xfs/linux-2.6/xfs_lrw.c:597).
592                     if (!need_i_mutex && (mapping->nrpages || pos
> xip->i_size)) {
593                             xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
594                             iolock =3D XFS_IOLOCK_EXCL;
595                             need_i_mutex =3D 1;
596                             mutex_lock(&inode->i_mutex);
597                             xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
598                             goto start;
599                     }
600             }
601

Well, at least it points at an xfs_ilock, so pretty good chance that
adding debug info didn't change anything else.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
