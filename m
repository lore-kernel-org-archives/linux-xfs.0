Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o815YXUo109187 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 00:34:34 -0500
Received: from web76207.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E740C3E3D5
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 22:35:12 -0700 (PDT)
Received: from web76207.mail.sg1.yahoo.com (web76207.mail.sg1.yahoo.com
	[124.108.115.134]) by cuda.sgi.com with SMTP id
	3DfqWNapZufJl4DU for <xfs@oss.sgi.com>;
	Tue, 31 Aug 2010 22:35:12 -0700 (PDT)
Message-ID: <881036.47658.qm@web76207.mail.sg1.yahoo.com>
Date: Wed, 1 Sep 2010 13:35:10 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: 4K drives, sectsz=512, bsize=4096
In-Reply-To: <1177874643.527261283294068615.JavaMail.root@mail-au.aconex.com>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>, Nathan Scott <nathans@aconex.com>
Cc: xfs@oss.sgi.com

Hi,

I would like to know how the inode size should be configured for 4 kB secto=
r drives?

Should we leave it at the default 256 bytes, or set it to the maximum of 2 =
kB?

Do inodes occupy discrete sectors, or do they occupy part of the filesystem=
 block?


GL

--- On Wed, 1/9/10, Nathan Scott <nathans@aconex.com> wrote:

> From: Nathan Scott <nathans@aconex.com>
> Subject: Re: 4K drives, sectsz=3D512, bsize=3D4096
> To: "Michael Monnerie" <michael.monnerie@is.it-management.at>
> Cc: xfs@oss.sgi.com
> Date: Wednesday, 1 September, 2010, 6:34 AM
> =

> ----- "Michael Monnerie" <michael.monnerie@is.it-management.at>
> wrote:
> =

> > On Dienstag, 31. August 2010 Eric Sandeen wrote:
> > > If you do it right (and especially vs. if you do
> it wrong) it
> > > should be a bit faster if all IOs are 4k aligned
> on the disk.
> >=A0 =

> > And that's what's interesting me: why? Won't XFS do
> all I/Os at
> > minimum =

> > for a given block size? Or is it possible XFS does
> write only a single
> > sector? I'd expect the smallest I/O size to be the
> block size, but it
> > seems I'm wrong?
> =

> Log I/O and direct writes are sector sized & aligned.
> =

> > I guess there's no way to "convert" an existing XFS
> with =

> > sectsz=3D512,bsize=3D4096 to sectsz=3D4096,bsize=3D4096? Maybe
> that's only a =

> > flag that can be changed?
> =

> There's no way (other than dump, mkfs & restore), the
> filesystem is laid
> out differently (most data structures, like superblocks and
> other metadata
> become 4K aligned).
> =

> cheers.
> =

> -- =

> Nathan
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
