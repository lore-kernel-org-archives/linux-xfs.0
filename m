Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0A6u5mi062012 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 00:56:06 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	P2le4s4McZreEwyG for <xfs@oss.sgi.com>;
	Mon, 09 Jan 2012 22:56:00 -0800 (PST)
Received: by iaeo4 with SMTP id o4so480550iae.26
	for <xfs@oss.sgi.com>; Mon, 09 Jan 2012 22:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120109213925.GF4198@dastard>
References: <CANBXnM=Ec4zp-5AR3JY00taUR+W-G6+ZKJKhDj94uhpeVsp2tw@mail.gmail.com>
	<CADDb1s38ts-NAhzqyt2ZiN8m6mBVzS97uACb0XVKEKrKmV=YJA@mail.gmail.com>
	<20120109213925.GF4198@dastard>
Date: Tue, 10 Jan 2012 12:25:59 +0530
Message-ID: <CANBXnMkYUwj_A0eYHHb4wBPDyrL_ZG6kH-7sLH6Rm4Q5YFrzMg@mail.gmail.com>
Subject: Re: Cyclic Code?
From: Adil Mujeeb <mujeeb.adil@gmail.com>
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
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, xfs@oss.sgi.com

Hi Dave, Amit,

Thank you for your inputs.

On Tue, Jan 10, 2012 at 3:09 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Jan 09, 2012 at 11:10:30PM +0530, Amit Sahrawat wrote:
> > On Mon, Jan 9, 2012 at 12:22 PM, Adil Mujeeb <mujeeb.adil@gmail.com> wr=
ote:
> > > Hi list,
> > >
> > > i am new to XFS.
> > >
> > > I was going through XFS code (2.4 based) for study purpose. Its old b=
ut
> > > assuming its bit simple as compare to latest one. Moreover the XFS co=
de /
> > > design structure documents available on the internet is 2.4 based.
> > May be if you switch to a version around 2.6.20 nearabout - it will
> > make it easier to understand the code. Prior to that the complete XFS
> > source code seemed like traversing through a lot of macros... I
> > started with 2.6.18 and it was really hard to understand from that
> > version...
>
> I'd recommend starting with the current top of tree code - it is
> much, much cleaner that the code base even from 2.6.20. Remember, 2.6.20
> was released almost 5 years ago (Feb 4 2007), and there's been a
> *lot* of cleanup work done since then....
>
> > > The following code snippet is not clear to me (seems cyclic):
> > >
> > > ---------
> > > ...
> > > ...
> > > #define XFS_IFORK_NEXTENTS(ip,w) =A0 =A0 =A0 =A0xfs_ifork_nextents(ip=
,w)
> > > ...
> > > xfs_ifork_nextents(xfs_inode_t *ip, int w)
> > > {
> > > =A0=A0 =A0 =A0 =A0return XFS_IFORK_NEXTENTS(ip, w);
> > > }
> > I guess you missed something while reading the code.... I tried to
> > look at the repositry.. this is how the code looks...
> > #if XFS_WANT_FUNCS || (XFS_WANT_SPACE && XFSSO_XFS_IFORK_NEXTENTS)
> > =A0int xfs_ifork_nextents(xfs_inode_t *ip, int w);
> > =A0#define XFS_IFORK_NEXTENTS(ip,w) =A0 =A0 =A0 =A0xfs_ifork_nextents(i=
p,w)
> > =A0#else
> > =A0#define XFS_IFORK_NEXTENTS(ip,w) =A0 =A0 =A0 =A0XFS_CFORK_NEXTENTS(&=
ip->i_d, w)
> > =A0#endif
> > ....
> > #define XFS_CFORK_NEXTENTS(dcp,w) \
> > =A0 =A0 =A0 ((w) =3D=3D XFS_DATA_FORK ? (dcp)->di_nextents : (dcp)->di_=
anextents)

Amit, what i understood is XFS_IFORK_NEXTENTS is replaced by
xfs_ifork_nextents(ip,w) call which actually has this macro in the
function body.

> Yup, that XFS_WANT_FUNCS crap was for debugging the macros because
> they were too complex to debug in line. That went long ago.
>
> FYI, macros were very popular in Irix code - desite SGI having an
> awesome compiler, the SGI kernel engineers believed that function
> calls were just too expensive to call and so macros that expanded
> out to 300 lines of code were common. Hence the need to have some
> way of debugging them.
>
> Hell, I know one engineer used to compile the code and then
> disassemble in the debugger on the running machine because that was
> the *simplest way* to work out what code the macros actually
> compiled in. :-O
>
> I'm glad we've got rid of most of the macro-instead-of-function
> usage now...

Thanks for the information.
Is there any code / design document similar to XFS filesystem
structure document available for older versions.

Thanks,
Adil

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
