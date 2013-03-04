Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D55F8057
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 17:18:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CA9DAC003
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 15:18:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3Nmln9PdB9vT06qi for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 15:18:54 -0800 (PST)
Date: Tue, 5 Mar 2013 10:18:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: strange behavior of a larger xfs directory
Message-ID: <20130304231852.GO26081@dastard>
References: <4300208.uZ6HVTycB6@xrated>
 <5347920.zaxHybjLeK@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5347920.zaxHybjLeK@xrated>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com

On Mon, Mar 04, 2013 at 11:55:40PM +0100, Hans-Peter Jansen wrote:
> Am Montag, 4. M=E4rz 2013, 17:40:13 schrieb Hans-Peter Jansen:
> > Hi,
> > =

> > after upgrading the kernel on a server from 2.6.34 to 3.8.1 (x86-32), I =

> > suffer from a strange behavior of a larger directory, that a downgrade =

> > of the kernel cannot repair.
> > =

> > The best way to reproduce the problem is cd into that directory and =

> > running "vi .". It should display a full directory listing, but it only =

> > displays a about dozen entries. Another way is just using bash tab =

> > completion (e.g. ls <tab><tab> should display a screenful of items, but =

> > only shows the very same dozen of entries. Userspace is quite old =

> > (openSUSE 11.1/i586, but I cannot upgrade to a newer userspace for a =

> > couple of reasons. OTOH, a simple ls displays the full list again, =

> =

> [...]
> =

> > > # then it preceeds with getdents64 and fetches already fetched entries
> > =

> > 27177 getdents64(3, {
> >              {d_ino=3D4303329151, d_off=3D78, d_type=3DDT_UNKNOWN, d_re=
clen=3D32, d_name=3D"Black_Swan"} =

> =

> Okay, this is the culprit: 0x1007F977F overflows 32 bit, although I =

> *never* mounted anything with inode64 option. =

> =

> For some reason, the intermediate kernel 3.8.0 has used the inode64 versi=
on
> by *default*. This breaks bash tab completion and vdr. After forcing the =

> inode32 option and copying some offenders away and back in place, the iss=
ue
> vanishes. =

> =

> Unlike stated in the XFS FAQs, openSUSE 11.1 *has* issues with inode64, a=
nd
> even more so, if enabled by default.

Wonderful. Report a bug to OpenSuSE and get userspace fixed. It's
only a matter of time before btrfs and ext4 users start reporting
the same problem, as they also use 64 bit inode numbers....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
