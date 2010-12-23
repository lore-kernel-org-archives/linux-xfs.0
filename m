Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN0sat7059916 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 18:54:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7385114786DA
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 16:56:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	iB6kPX4sjxpANmeK for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 16:56:33 -0800 (PST)
Date: Thu, 23 Dec 2010 11:56:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101223005630.GJ4907@dastard>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 07:28:29PM -0500, Justin Piszcz wrote:
> =

> =

> On Thu, 23 Dec 2010, Emmanuel Florac wrote:
> =

> >Le Wed, 22 Dec 2010 13:03:13 -0600 vous =E9criviez:
> >
> >>http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_f=
or_.3Csomething.3E
> >>
> >>which mentions getting your geometry right if it's hardware raid
> >>that can't be detected automatically.
> >
> >Just as a side note : I tried several times to manually set the
> >filesystem layout to precisely match the underlying hardware RAID
> >with sunit and swidth but didn't find that it made a noticeable
> >difference. On my 39.9 TB systems, the default agcount is 39, while the
> >optimum would be (theorically at least)  42.
> =

> Hi, I concur, for hardware raid (at least on 3ware cards) I have
> found it makes no difference, thanks for confirming.

I'd constrain that statement to "no difference for the workloads
and hardware tested".

Indeed, testing an empty filesystem will often show no difference in
performance, because typically problems don't show up until you've
started to age the filesystem significantly. When the filesystem has
started to age, the difference between having done lots of stripe
unit/width aligned allocation vs none can be very significant....

Hence don't assume that because you can't see any difference on a
brand new, empty filesystem there never will be a difference over
the life of the filesytem...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
