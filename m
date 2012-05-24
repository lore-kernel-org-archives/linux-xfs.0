Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OEIXj2006962 for <xfs@oss.sgi.com>; Thu, 24 May 2012 09:18:33 -0500
Date: Thu, 24 May 2012 09:23:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120524142347.GZ3963@sgi.com>
References: <CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<20120518171959.GQ16099@sgi.com>
	<CADLDEKssiOCVRknW3hYtxDxYHSyGr6qfepfai+UymsD6zMGopw@mail.gmail.com>
	<20120521171136.GR16099@sgi.com>
	<CADLDEKtVPRa-ZM_T6_-VLnCKtCtJwSNGR3VwR=qmFi1umbmTBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADLDEKtVPRa-ZM_T6_-VLnCKtCtJwSNGR3VwR=qmFi1umbmTBQ@mail.gmail.com>
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
To: Juerg Haefliger <juergh@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, May 24, 2012 at 07:45:05AM +0200, Juerg Haefliger wrote:
> > Hit this on a filesystem with a regular sized log over the weekend. =A0=
If you see
> > this again in production could you gather up task states?
> >
> > echo t > /proc/sysrq-trigger
> =

> Here is the log from a production hang:
> =

> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111805] INFO:
> task xfssyncd/dm-4:971 blocked for more than 120 seconds.
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111864] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111951]
> xfssyncd/dm-4   D 000000000000000f     0   971      2 0x00000000
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111957]
> ffff880325e09d00 0000000000000046 ffff880325e09fd8 ffff880325e08000
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111962]
> 0000000000013d00 ffff880326774858 ffff880325e09fd8 0000000000013d00
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111966]
> ffff8803241badc0 ffff8803267744a0 0000000000000282 ffff8806265d7e00
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.111971] Call Trace:
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112016]
> [<ffffffffa00f42d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112023]
> [<ffffffff8105f6f0>] ? default_wake_function+0x0/0x20
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112046]
> [<ffffffffa00f61ff>] xfs_log_reserve+0xff/0x140 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112070]
> [<ffffffffa01021fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112092]
> [<ffffffffa00e6383>] xfs_fs_log_dummy+0x43/0x90 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112117]
> [<ffffffffa01193c1>] xfs_sync_worker+0x81/0x90 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112141]
> [<ffffffffa01180f3>] xfssyncd+0x183/0x230 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112164]
> [<ffffffffa0117f70>] ? xfssyncd+0x0/0x230 [xfs]
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112170]
> [<ffffffff810871f6>] kthread+0x96/0xa0
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112176]
> [<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112180]
> [<ffffffff81087160>] ? kthread+0x0/0xa0
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112183]
> [<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112241] INFO:
> task ruby1.8:2734 blocked for more than 120 seconds.
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112295] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 23 11:44:33 sw-aw2az1-object062 kernel: [6272393.112378] ruby1.8

Great, that's the same one we saw last saturday.  The xfs_sync_worker is bl=
ocked
getting log reservation, so it doesn't push the target on the ail... which
would possibly release enough space for the log reservation it's blocked on.

I was thinking of experimenting with something like this:

Index: xfs/fs/xfs/xfs_sync.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfs.orig/fs/xfs/xfs_sync.c
+++ xfs/fs/xfs/xfs_sync.c
@@ -392,15 +392,15 @@ xfs_sync_worker(
        if (down_read_trylock(&mp->m_super->s_umount)) {
                if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
                        /* dgc: errors ignored here */
-                       if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
-                           xfs_log_need_covered(mp))
-                               error =3D xfs_fs_log_dummy(mp);
-                       else
-                               xfs_log_force(mp, 0);
+                       xfs_log_force(mp, 0);

                        /* start pushing all the metadata that is currently
                         * dirty */
                        xfs_ail_push_all(mp->m_ail);
+
+                       if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
+                           xfs_log_need_covered(mp))
+                               error =3D xfs_fs_log_dummy(mp);
                }
                up_read(&mp->m_super->s_umount);
        }

By forcing the log and pushing all of the ail before trying to cover the lo=
g we
don't deadlock that way... but it doesn't fix the greater problem with the =
ail
hang.  (It looks like that is being worked in a separate thread.)  And ther=
e may
be some other considerations with respect to covering the log later, after
pushing the ail.  Something for discussion.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
