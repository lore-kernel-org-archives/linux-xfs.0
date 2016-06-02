Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D1257CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 17:25:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 072A0AC001
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 15:25:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	D1TiPpQhxz1sC5Z8 for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2016 15:25:48 -0700 (PDT)
Date: Fri, 3 Jun 2016 08:25:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: _xfs_buf_ioapply: no ops on block 0x188e78/0x8 on vanilla 4.4.11
Message-ID: <20160602222545.GO12670@dastard>
References: <57503353.2050402@profihost.ag>
	<57503D33.6010000@applied-asynchrony.com>
	<575040D8.8070903@applied-asynchrony.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <575040D8.8070903@applied-asynchrony.com>
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
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Thu, Jun 02, 2016 at 04:21:12PM +0200, Holger Hoffst=E4tte wrote:
> On 06/02/16 16:05, Holger Hoffst=E4tte wrote:
> > On 06/02/16 15:23, Stefan Priebe - Profihost AG wrote:
> >> I found a bug report from redhat here
> >> https://bugzilla.redhat.com/show_bug.cgi?id=3D1234586 pointing to this=
 commit:
> >> xfs: handle dquot buffer readahead in log recovery correctly
> >>
> >> which isn't part of 4.4. Is it missing from linux-stable?
> > =

> > Yes, mainline 7d6a13f02356 is missing from 4.4-stable because it applie=
s,
> > but doesn't compile. :)
> > =

> > I'll look into a fix.
> =

> Well, that was easy. It also needs 233135b763 ("xfs: print name of verifi=
er
> if it fails") which added a .name to the various xfs_buf_ops types.
> Can someone confirm that these can both go into 4.4-stable?

You could just remove the line:

+       .name =3D "xfs_dquot_ra",

from 7d6a13f02356 and that will fix the backport problem and not
require any other commits to be backported. I'm fine with either
solution.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
