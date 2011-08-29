Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7T5ltAV050966 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 00:47:55 -0500
Received: from nm8.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 82BB219442E4
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 22:47:53 -0700 (PDT)
Received: from nm8.bullet.mail.sg1.yahoo.com (nm8.bullet.mail.sg1.yahoo.com
	[115.178.12.208]) by cuda.sgi.com with SMTP id rGzXR5Sj3zVN7o5g
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 22:47:53 -0700 (PDT)
Message-ID: <1314596870.46906.YahooMailClassic@web77720.mail.sg1.yahoo.com>
Date: Mon, 29 Aug 2011 13:47:50 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: xfsrestore Does Only Only Partial Restore
In-Reply-To: <20110829050025.GF3162@dastard>
MIME-Version: 1.0
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

Hi,

I just tried the 26 Aug 2011 commited version of xfsrestore from xfsdump, I=
 got the same message:

xfsrestore: content.c:7510: restore_extent_group: Assertion `ehdr.eh_type =
=3D=3D 4' failed.
Aborted

It is interesting that two different back-ups are corrupt after around 44 t=
o 49 GB, more than half of the back-ups!

I did not look at /var/log/messages or dmesg while doing the back-ups.  I o=
nly saw that the xfsdump session was successful.


GL

--- On Mon, 29/8/11, Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <david@fromorbit.com>
> Subject: Re: xfsrestore Does Only Only Partial Restore
> To: "Gim Leong Chin" <chingimleong@yahoo.com.sg>
> Cc: xfs@oss.sgi.com
> Date: Monday, 29 August, 2011, 1:00 PM
> On Sun, Aug 28, 2011 at 08:31:40PM
> +0800, Gim Leong Chin wrote:
> > Hi,
> > =

> > This is the very first time I tried doing a xfsrestore
> of a back
> > up and I hit some serious trouble.
> > =

> > I had openSUSE 11.1 (kernel 2.6.27) on my Acer
> notebook.=A0 I did a
> > xfsdump of /home to a WD My Passport external USB hard
> drive with
> > XFS on it.
> > =

> > I installed openSUSE 11.4 (kernel 2.6.37), then tried
> to do
> > xfsrestore from the WD USB drive.=A0 The dump file
> is 121 GB.
> > =

> > I tried two times on two different days, but each time
> the
> > xfsrestore would stop writing at the exact same point,
> 49 GB and
> > say success at the end.
> > =

> > I then copied the dump file to one hard drive on my
> desk top, and
> > did a dump to another hard drive, to /tmp/mnt3.=A0
> I get back
> > identical messages:
> =

> ....
> > I downloaded xfsdump-3.0.5.tar.gz, did a build, and
> tried to do a restore using the newly built xfsrestore:
> =

> > {>
> >=A0=A0=A0optimus:/home/chingl/archive/rat #
> /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore -f
> ./rat18Aug2011 /tmp/mnt3
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> using file dump (drive_simple) strategy
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> version 3.0.5 (dump format 3.0) - Running single-threaded
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> searching media for dump
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> examining media file 0
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> dump description:
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> hostname: rat
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> mount point: /home
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> volume: /dev/sdb3
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> session time: Thu Aug 18 12:57:36 2011
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> level: 0
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> session label: "rat_18Aug2011"
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> media label: "rat18Aug2011"
> >
> 3>/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: file
> system id: f3b08587-cf98-4b7b-99b0-dc9d4e77b631
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> session id: d8069cd0-a092-4fb2-b378-0eda33474aae
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> media id: 96370000-6e2c-40eb-9c3c-93ca42de7524
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> searching media for directory dump
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> reading directories
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> 90820 directories and 539579 entries processed
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> directory post-processing
> >=A0=A0=A0/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> restoring non-directory files
> >=A0=A0=A0xfsrestore: content.c:7510:
> restore_extent_group: Assertion `ehdr.eh_type =3D=3D 4' failed.
> =

> Which indicates that the dump file on your external drive
> is
> probably corrupt. xfs_restore only has a certain number of
> known
> extent types, and this ASSERT failure occurs if the extent
> type is
> not valid - the restore code has checked for all special
> types,
> and is now expecting a data extent, which it isn't. That's
> where the
> restore will stop.
> =

> All the other restore attempts you've made have equivalent
> "failed
> to read" errors that also indicate some kind of corruption
> in the
> dump file.
> =

> > (>Aborted 2>optimus:/home/chingl/archive/rat #
> > =

> > =

> > Could some one please assist to enlighten me what is
> going on, why
> > does the restoration fail?=A0 The xfsdump session
> looked OK.
> =

> Well, I can't tell you if the dump was ok or not without
> that
> output. Even if the dump was successful, it could have
> easily been
> corrupted by a memory or other hardware bit error on the
> way to
> disk. Were there any IO errors reported in the kernel dmesg
> messages
> while the dump was being taken?
> =

> > Is there any way I can extract back my /home back
> up?=A0 This is my
> > only back up copy.=A0 i have two other xfsdump dump
> files taken
> > earlier, I have not tried those.
> =

> No idea, you'll have to wait for the xfsdump experts to
> come online.
> =

> > Is xfsdump and xfsrestore really robust for dump to
> regular file,
> > or should I have done a tar instead?
> =

> It should be fine, but if there was a hardware related
> problem then
> all bets are off...
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
