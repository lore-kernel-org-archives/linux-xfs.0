Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B0887F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 23:57:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DAB0304032
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 21:57:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6XkfZL83bpJU5eTn for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 21:57:25 -0700 (PDT)
Date: Wed, 28 Oct 2015 15:56:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: make fsr use mntinfo when there is no mntent
Message-ID: <20151028045645.GQ19199@dastard>
References: <1445338883-7000-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445338883-7000-1-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 20, 2015 at 01:01:23PM +0200, Jan Tulak wrote:
> I'm resubmitting this patch from my OS X set - it wasn't included with
> others, nor in the current for-next, and I didn't got any review/reply
> to this last iteration.
> =

> So my guess is it fell under the sofa, forgotten... :-)
> =

> .........
> =

> UPDATE:
> - refactor ifdefs to platform_ functions
> - refactor also the other ifdef which I forgot to change before
> - (and rebase against current for-next)
> =

> For what fsr needs, mntinfo can be used instead of mntent on some
> platforms. Exctract the platform-specific code to platform headers.
> =

> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Code structure looks good now, but build warnings on linux:

    [CC]     xfs_fsr.o
xfs_fsr.c: In function =BFfind_mountpoint_check=BF:
xfs_fsr.c:184:26: warning: passing argument 2 of =BFstat64=BF from incompat=
ible pointer type
   if (stat64(t->mnt_dir, &ms) < 0)
                          ^
In file included from /usr/include/features.h:374:0,
                 from /usr/include/stdio.h:27,
                 from ../include/platform_defs.h:24,
                 from ../include/libxfs.h:23,
                 from xfs_fsr.c:19:
/usr/include/x86_64-linux-gnu/sys/stat.h:502:1: note: expected =BFstruct st=
at64 *=BF but argument is of type =BFstruct stat64 **=BF
 __NTH (stat64 (const char *__path, struct stat64 *__statbuf))
 ^
xfs_fsr.c:195:29: warning: passing argument 2 of =BFstat64=BF from incompat=
ible pointer type
   if (stat64(t->mnt_fsname, &ms) < 0)
                             ^
In file included from /usr/include/features.h:374:0,
                 from /usr/include/stdio.h:27,
                 from ../include/platform_defs.h:24,
                 from ../include/libxfs.h:23,
                 from xfs_fsr.c:19:
/usr/include/x86_64-linux-gnu/sys/stat.h:502:1: note: expected =BFstruct st=
at64 *=BF but argument is of type =BFstruct stat64 **=BF
 __NTH (stat64 (const char *__path, struct stat64 *__statbuf))
 ^
xfs_fsr.c: In function =BFinitallfs=BF:
xfs_fsr.c:435:39: warning: passing argument 2 of =BFplatform_mntent_next=BF=
 from incompatible pointer type
  while (platform_mntent_next(&cursor, &mp) =3D=3D 0) {
                                       ^
In file included from ../include/xfs.h:37:0,
                 from ../include/libxfs.h:24,
                 from xfs_fsr.c:19:
../include/xfs/linux.h:166:19: note: expected =BFstruct mntent *=BF but arg=
ument is of type =BFstruct mntent **=BF
 static inline int platform_mntent_next(struct mntent_cursor * cursor, stru=
ct mntent * t)
                   ^
xfs_fsr.c:436:37: warning: passing argument 2 of =BFfind_mountpoint_check=
=BF from incompatible pointer type
   mntp =3D find_mountpoint_check(&sb, &mp, &ms);
                                     ^
xfs_fsr.c:181:1: note: expected =BFstruct mntent *=BF but argument is of ty=
pe =BFstruct mntent **=BF
 find_mountpoint_check(struct stat64 *sb, struct mntent *t, struct stat64 *=
ms)
 ^
    [LD]     libxcmd.la

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
