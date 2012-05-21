Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LH6dmC224309 for <xfs@oss.sgi.com>; Mon, 21 May 2012 12:06:39 -0500
Date: Mon, 21 May 2012 12:11:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120521171136.GR16099@sgi.com>
References: <CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<20120518171959.GQ16099@sgi.com>
	<CADLDEKssiOCVRknW3hYtxDxYHSyGr6qfepfai+UymsD6zMGopw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADLDEKssiOCVRknW3hYtxDxYHSyGr6qfepfai+UymsD6zMGopw@mail.gmail.com>
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

Hey Juerg,

On Sat, May 19, 2012 at 09:28:55AM +0200, Juerg Haefliger wrote:
> > On Wed, May 09, 2012 at 09:54:08AM +0200, Juerg Haefliger wrote:
> >> > On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
> >> >> Did anybody have a chance to look at the data?
> >> >
> >> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/979498
> >> >
> >> > Here you indicate that you have created a reproducer. =A0Can you pos=
t it to the list?
> >>
> >> Canonical attached them to the bug report that they filed yesterday:
> >> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D922
> >
> > I'm interested in understanding to what extent the hang you see in prod=
uction
> > on 2.6.38 is similar to the hang of the reproducer. =A0Mark is seeing a=
 situation
> > where there is nothing on the AIL and is clogged up in the CIL, others =
are
> > seeing items on the AIL that don't seem to be making progress. =A0Could=
 you
> > provide a dump or traces from a hang on a filesystem with a normal size=
d log?
> > Can the reproducer hit the hang eventually without resorting to the tin=
y log?
> =

> I'm not certain that the reproducer hang is identical to the
> production hang. One difference that I've noticed is that a reproducer
> hang can be cleared with an emergency sync while a production hang
> can't. I'm working on trying to get a trace from a production machine.

Hit this on a filesystem with a regular sized log over the weekend.  If you=
 see
this again in production could you gather up task states?

echo t > /proc/sysrq-trigger

Mark and I have been looking at the dump.  There are few interesting items =
to point out.

1) xfs_sync_worker is blocked trying to get log reservation:

PID: 25374  TASK: ffff88013481c6c0  CPU: 3   COMMAND: "kworker/3:83"
 #0 [ffff88013481fb50] __schedule at ffffffff813aacac
 #1 [ffff88013481fc98] schedule at ffffffff813ab0c4
 #2 [ffff88013481fca8] xlog_grant_head_wait at ffffffffa0347b78 [xfs]
 #3 [ffff88013481fcf8] xlog_grant_head_check at ffffffffa03483e6 [xfs]
 #4 [ffff88013481fd38] xfs_log_reserve at ffffffffa034852c [xfs]
 #5 [ffff88013481fd88] xfs_trans_reserve at ffffffffa0344e64 [xfs]
 #6 [ffff88013481fdd8] xfs_fs_log_dummy at ffffffffa02ec138 [xfs]
 #7 [ffff88013481fdf8] xfs_sync_worker at ffffffffa02f7be4 [xfs]
 #8 [ffff88013481fe18] process_one_work at ffffffff8104c53b
 #9 [ffff88013481fe68] worker_thread at ffffffff8104f0e3
#10 [ffff88013481fee8] kthread at ffffffff8105395e
#11 [ffff88013481ff48] kernel_thread_helper at ffffffff813b3ae4

This means that it is not in a position to push the AIL.  It is clear that =
the
AIL has plenty of entries which can be pushed.

crash> xfs_ail 0xffff88022112b7c0,
struct xfs_ail {
...
  xa_ail =3D {
    next =3D 0xffff880144d1c318,
    prev =3D 0xffff880170a02078
  },
  xa_target =3D 0x1f00003063,

Here's the first item on the AIL:

ffff880144d1c318
struct xfs_log_item_t {
  li_ail =3D {
    next =3D 0xffff880196ea0858,
    prev =3D 0xffff88022112b7d0
  },
  li_lsn =3D 0x1f00001c63,		<--- less than xa_target
  li_desc =3D 0x0,
  li_mountp =3D 0xffff88016adee000,
  li_ailp =3D 0xffff88022112b7c0,
  li_type =3D 0x123b,
  li_flags =3D 0x1,
  li_bio_list =3D 0xffff88016afa5cb8,
  li_cb =3D 0xffffffffa034de00 <xfs_istale_done>,
  li_ops =3D 0xffffffffa035f620,
  li_cil =3D {
    next =3D 0xffff880144d1c368,
    prev =3D 0xffff880144d1c368
  },
  li_lv =3D 0x0,
  li_seq =3D 0x3b
}

So if xfs_sync_worker were not blocked on log reservation it would push the=
se
items.

2) The CIL is waiting around too:

crash> xfs_cil_ctx 0xffff880144d1a9c0,
struct xfs_cil_ctx {
...
  space_used =3D 0x135f68, =


struct log {
...
  l_logsize =3D 0xa00000,

A00000/8
140000						<--- XLOG_CIL_SPACE_LIMIT

140000 - 135F68
A098

Looks like xlog_cil_push_background will not push the CIL while space used =
is
less than XLOG_CIL_SPACE_LIMIT, so that's not going anywhere either.

3) It may be unrelated to this bug, but we do have a race in the log
reservation code that hasn't been resolved... between when log_space_left
samples the grant heads and when the space is actually granted a bit later.
Maybe we can grant more space than intended.

If you can provide output of 'echo t > /proc/sysrq-trigger' it may be enough
information to determine if you're seeing the same problem we hit on Saturd=
ay.

Thanks,

Ben & Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
