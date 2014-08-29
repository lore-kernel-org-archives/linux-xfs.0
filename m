Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07ABF7F92
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 03:38:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA9948F804B
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 01:38:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ogKBOjKQPDx0eykm for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 01:37:57 -0700 (PDT)
Date: Fri, 29 Aug 2014 18:37:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount options question
Message-ID: <20140829083738.GD20518@dastard>
References: <3dc9caf6f9b415f6e4c0ebac1f1626d3@zbfmail.de>
	<20140827230732.GN20518@dastard>
	<CAAxjCEy9UyjDVrTZ4GdRyDy330wUqLGWurzrLAE6-7Q0KdYzvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEy9UyjDVrTZ4GdRyDy330wUqLGWurzrLAE6-7Q0KdYzvA@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Xfs <xfs@oss.sgi.com>, weber@zbfmail.de

On Fri, Aug 29, 2014 at 08:31:43AM +0200, Stefan Ring wrote:
> On Thu, Aug 28, 2014 at 1:07 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Aug 27, 2014 at 12:14:21PM +0200, Marko Weber|8000 wrote:
> >>
> >> sorry dave and all other,
> >>
> >> can you guys recommend me the most stable / best mount options for
> >> my new server with ssd=B4s and XFS filesystem?
> >>
> >> at moment i would set:  defaults,nobarrier,discard,logbsize=3D256k,noi=
keep
> >> or is just "default" the best solution and xfs detect itself whats bes=
t.
> >>
> >> can you guide me a bit?
> >>
> >> as eleavtor i set elevator=3Dnoop
> >>
> >> i setup disks with linux softraid raid1. On top of the raid is LVM
> >> (for some data partations).
> >>
> >>
> >> would be nice to hear some tipps from you
> >
> > Unless you have specific requirements or have the knowledge to
> > understand how the different options affect behaviour, then just use
> > the defaults.
> =

> Mostly agreed, but using "discard" would be a no-brainer for me. I
> suppose XFS does not automatically switch it on for non-rotational
> storage.

Yup, you're not using your brain. :P

mount -o discard *sucks* on so many levels it is not funny. I don't
recommend that anybody *ever* use it, on XFS, ext4 or btrfs.  Just
use fstrim if you ever need to clean up a SSD.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
